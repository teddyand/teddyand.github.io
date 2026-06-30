---
layout: post
title: "用 Espruino 驱动编码电机：从能转到走直"
header-style: text
tags: 
    - stem教育
    - 智能车
    - Espruino 
---

事情的起因是我想搭个能自己跑直线的小车。

裸电机好办，给电就转。但"转多快"、"转了多远"、"走没走直"，这些全都答不上来。一台不知道自己走了多远的小车，跟一个蒙眼走路的人没有区别。

于是我把吃灰的 Espruino Pico 和几块钱的 DRV8833 焊在一起，写了两版驱动，踩了一路坑。

## 硬件

DRV8833 是个双路 H 桥，每路电机给三个脚控制：两个方向脚（IN1/IN2）决定正反转，一个 PWM 脚决定速度。再加上两个带编码器的减速电机，每个电机屁股后面甩出四根线（编码器 A/B 相 + 电源）。

| 信号 | 左轮 | 右轮 | 说明 |
|------|------|------|------|
| IN1  | B8   | B10  | 方向脚 1 |
| IN2  | B9   | B11  | 方向脚 2 |
| PWM  | B6   | B7   | 调速，`analogWrite` |
| ENC A| A0   | A2   | 编码器 A 相 |
| ENC B| A1   | A3   | 编码器 B 相 |

IN1=1、IN2=0 正转，反过来反转，两个都 0 就停。PWM 占空比 0 到 1 对应 0% 到 100% 速度。逻辑就这么简单，难点全在编码器和控制上。

## 第一版：能转就行

先把电机跑起来，编码器能数数。

```js
// 电机方向 + PWM 调速，speed 取 -1.0 ~ 1.0
MotorController.prototype.setLeftSpeed = function(speed) {
  speed = Math.max(-1.0, Math.min(1.0, speed));
  if (speed > 0) {
    digitalWrite(motorPins.left.in1, 1);
    digitalWrite(motorPins.left.in2, 0);
    analogWrite(motorPins.left.pwm, speed, {freq: 1000});
  } else if (speed < 0) {
    digitalWrite(motorPins.left.in1, 0);
    digitalWrite(motorPins.left.in2, 1);
    analogWrite(motorPins.left.pwm, -speed, {freq: 1000});
  } else {
    digitalWrite(motorPins.left.in1, 0);
    digitalWrite(motorPins.left.in2, 0);
    analogWrite(motorPins.left.pwm, 0);
  }
};
```

编码器是个正交编码器，A、B 两相相位差 90°。谁先跳变决定了转向，所以每个跳变边沿都进中断读一次两相电平，比较前后状态就能判方向、加减计数：

```js
setWatch(function(e) {
  var a = digitalRead(motorPins.left.encA);
  var b = digitalRead(motorPins.left.encB);
  if (a !== encoder.left.lastA) {
    if (a === b) encoder.left.count++;
    else         encoder.left.count--;
  }
  encoder.left.lastA = a;
  encoder.left.lastB = b;
}, motorPins.left.encA, {repeat: true, edge: 'both'});
```

前进、后退、左转、右转，各包一层 `setSpeeds`，小车就能动了。`motors.forward(0.5)` 跑起来，串口读编码器，数字蹭蹭往上涨。

**但第一版有两个问题。**

一是 PWM 频率设的 1000 Hz，电机发出一种尖锐的"嗡——"，在安静的房间里格外折磨人。1 kHz 正好人耳最敏感的频段。

二是编码器引脚配的 `input`，悬空时电平乱跳，电机一抖就误触发，计数忽大忽小根本没法用。

## 第二版：让它闭嘴，并走直

针对上面两个坑分别动刀。

PWM 频率拉到 20 kHz，超过人耳上限，电机瞬间安静了：

```js
var config = {
  pwmFreq: 20000,   // 超声段，听不见了
  encoderPPR: 12,
  wheelDiameter: 6.5,
  wheelTrack: 15.0
};
```

编码器引脚改成 `input_pullup`，内部上拉把悬空电平钉死，误触发基本消失：

```js
pinMode(pins.left.encA, "input_pullup");
pinMode(pins.left.encB, "input_pullup");
```

光走直还不够，我想让它"走指定距离"。这需要两样东西：把编码器计数换算成距离，再套个 PID 闭环。

**里程换算。** 一圈的脉冲数除以轮子周长，就是每厘米对应的脉冲数。编码器计数除以这个系数，就是走过的厘米数：

```js
MotorController.prototype.getDistance = function() {
  var pulsesPerCm = config.encoderPPR / (Math.PI * config.wheelDiameter);
  return {
    left: encoder.left.count / pulsesPerCm,
    right: encoder.right.count / pulsesPerCm,
    average: (encoder.left.count + encoder.right.count) / (2 * pulsesPerCm)
  };
};
```

注意 `encoderPPR` 要按实际解码倍频标定——四倍频解码下实际计数值是标称 PPR 的四倍，这个数得拿尺子量着调。

**航向角。** 差速小车的转向靠两轮速度差，右轮比左轮多走 `dR - dL`，车身就转个角度。除以轮距换算成弧度，再转成度：

```js
MotorController.prototype.getAngle = function() {
  var distance = this.getDistance();
  var diff = distance.right - distance.left;
  return (diff / config.wheelTrack) * (180 / Math.PI);
};
```

**PID 闭环。** 有了距离反馈，就能盯着误差跑。`moveDistance` 起步记录当前里程，每 100 ms 算一次"目标距离 - 当前距离"作为误差，过 PID 输出新的速度。误差压到 0.5 cm 以内就停：

```js
var pidInterval = setInterval(function() {
  var currentDistance = self.getDistance().average;
  error = targetDistance - currentDistance;

  integral += error * 0.1;
  var derivative = (error - lastError) / 0.1;
  var output = Kp * error + Ki * integral + Kd * derivative;
  lastError = error;

  if (Math.abs(error) < 0.5) {           // 到了，停
    clearInterval(pidInterval);
    self.stop();
    if (callback) callback();
    return;
  }
  output = Math.max(-1, Math.min(1, output));
  self.setSpeeds(direction * Math.abs(output) * speed,
                 direction * Math.abs(output) * speed);
}, 100);
```

`turnAngle` 是同一套逻辑换个反馈量——把目标从距离换成航向角，左右轮反向转。调好 `Kp/Ki/Kd` 之后，`motors.turnAngle(90, 0.4, cb)` 能稳稳转个直角，回调里继续下一条指令。

## 调参手记

PID 的三个数没法靠算，只能开着车撞墙调。

- `Kp` 先给，太小磨蹭、太大超调冲过头。`moveDistance` 我给了 2.0，`turnAngle` 给 1.5（转向惯量比直线小）。
- `Ki` 消稳态误差，但太大会积分饱和、来回抖。直线 0.1、转向 0.05，刚好。
- `Kd` 抑制超调，压住快到目标时的那一脚刹车。0.5 / 0.3。

距离精度收在 0.5 cm，角度收在 2°。对一辆亚克力板搭的小车来说够用了。

## 扩展方向

代码能跑，但离"好用"还有距离：

- 现在两轮是同步给速，没做左右轮速度平衡，长直线还是会慢慢跑偏——可以加个串级 PID，外环控方向、内环控两轮速差。
- `moveDistance` 用的轮径和 PPR 是写死的，换个电机就得改代码，可以做成上电自标定。
- 编码器中断是软件 `setWatch`，转速太高会丢脉冲。真要飙车得上硬件正交解码。

不过现在的小车能走直线、能转直角、能报里程，作为一个 side project 已经到了"刚好有用"的那个点。

## 文件

- `motor.js`（基础版，方向控制 + 编码器计数）
- `motor2.js`（PID 版，里程/航向换算 + 闭环控制）

两份文件，一块 Pico，一个 DRV8833，从"嗡嗡叫着乱转"到"安静地走直"。嵌入式 JavaScript 最迷人的地方大概就在这——几百行代码，让一堆塑料和铜线有了方向感。
