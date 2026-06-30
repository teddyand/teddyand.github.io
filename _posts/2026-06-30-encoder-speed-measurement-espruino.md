---
layout: post
title: "编码器正反转测速：从脉冲到转速，用 Espruino 读懂电机的心跳"
header-style: text
tags: 
    - stem教育
    - 智能车
    - Espruino    
---

上一篇文章写了怎么让编码电机走直线、转直角。但有读者问了一个很实在的问题：

> **"你怎么知道电机是正转还是反转？转速到底怎么测出来的？"**

这其实是两个问题。先说编码器怎么判方向，再说怎么算转速。两个问题都回到同一个信号上去——编码器输出的那两路方波。

## 正交编码器：两路信号，一个答案

带编码器的电机屁股后面通常甩出四根线：电机电源正负，加上两根信号线，分别叫 A 相和 B 相。

这两根线输出的都是方波脉冲。电机转一圈，A 和 B 各输出固定数量的脉冲（常见 12、20、48 个）。关键不是脉冲数量，而是**它们谁先跳变**。

<img src="https://images-1303887003.cos.ap-beijing.myqcloud.com//images/encode.png" alt="正转编码器波形" style="width:100%;max-width:800px;display:block;margin:1.5em auto;border-radius:6px">


### 正转：A 领先 B

电机正转时，A 相的上跳沿永远比 B 相早到 90°（电气角度）。你同时盯着两个信号看，A 跳上去了，B 还是低电平——这就表明在正转。

<img src="https://images-1303887003.cos.ap-beijing.myqcloud.com//images/encoder-forward.svg" alt="正转编码器波形" style="width:100%;max-width:800px;display:block;margin:1.5em auto;border-radius:6px">


### 反转：B 领先 A

反转时反过来。B 先跳上去，A 才跟着跳。读到的时序关系完全镜像。

<img src="https://images-1303887003.cos.ap-beijing.myqcloud.com//images/encoder-reverse.svg" alt="反转编码器波形" style="width:100%;max-width:800px;display:block;margin:1.5em auto;border-radius:6px">

这个相位关系是编码器最核心的信息。哪怕没有其他传感器，只看这两根线的跳变顺序，就能知道电机往哪转。

<!-- more -->

## 正交解码：四倍频与方向判断

解码的方式不唯一。你可以在每个上升沿读一次，这叫单倍频；也可以在上升沿和下降沿都读，翻倍成两倍频；更激进的做法是 A、B 两相的四个边沿都触发中断，四倍频。

下面的代码就是四倍频解码——每个边沿进一次中断，读两相电平，比较前后状态判方向：

```js
// motor.js 中的四倍频正交解码
setWatch(function(e) {
  var a = digitalRead(motorPins.left.encA);
  var b = digitalRead(motorPins.left.encB);
  if (a !== encoder.left.lastA) {
    if (a === b) encoder.left.count++;   // 正转
    else         encoder.left.count--;   // 反转
  }
  encoder.left.lastA = a;
  encoder.left.lastB = b;
}, motorPins.left.encA, {repeat: true, edge: 'both'});

setWatch(function(e) {
  var a = digitalRead(motorPins.left.encA);
  var b = digitalRead(motorPins.left.encB);
  if (b !== encoder.left.lastB) {
    if (a === b) encoder.left.count--;   // 反转
    else         encoder.left.count++;   // 正转
  }
  encoder.left.lastA = a;
  encoder.left.lastB = b;
}, motorPins.left.encB, {repeat: true, edge: 'both'});
```

**为什么要在 A 和 B 上都设中断？** 因为只监听一路信号，你只能知道脉冲数，不知道方向。两路都监听，每次跳变都检查另一相的电平——"A 上升时 B 是高还是低？"——答案就是方向。

编码器计数 `encoder.left.count` 就是一个有符号整数。正转累加，反转递减，始终反映旋转的净位移。

> **一个实战细节：** `input_pullup` 比 `input` 重要得多。电机刚启动时电流大、干扰多，悬空的编码器引脚会疯狂误触发。内部上拉把电平钉住，误计数从每分钟几百次降到几乎为零。`motor.js` 第一版就是踩了这个坑，第二版才老老实实加上 `input_pullup`。

## 测速：从脉冲到 RPM 的两种路径

有了计数，下一步是算速度。没有速度反馈，小车跑不直、机器人走不准。

### 方法一：固定时间窗口计数法

最简单。固定一个时间窗口（通常 1 秒），数这个窗口内来了多少个脉冲，换算成转速。

```js
// fans_1.js 中的秒级计数
var counter = 0;

function onChanged(e) {
  counter++;
  digitalWrite(C13, e.state);
}

function onSecond(e) {
  // counter × (60s / 脉冲数每转) = RPM
  console.log(counter * 60 / 2);
  counter = 0;
}

setWatch(onChanged, SENSE, { edge: "both", repeat: true });
setInterval(onSecond, 1000);
```

PC 风扇的测速线每转输出 2 个脉冲，所以乘 60 除以 2。

**优点**是简单，**缺点**是延迟。你永远要等整秒结束才知道这秒的平均速度。转速突然飙高，你要傻等一整秒才看到 —— 对实时控制来说太慢了。

### 方法二：脉冲间隔法

不等了 —— 直接在脉冲到来的时刻算瞬时速度。

```js
// fans_1.js 中的脉冲间隔测速
var lastPulseTime;

function onChanged(e) {
  if (e.state) {                                    // 只在上升沿算
    var timeDiff = e.time - lastPulseTime;          // 相邻脉冲间隔
    lastPulseTime = e.time;
    rpm = 60 / timeDiff;                            // 瞬时 RPM
    digitalWrite(A9, rpm < 900);
  }
  counter++;
  console.log(rpm);
}
```

核心公式一行：

```
RPM = 60 / Δt
```

其中 `Δt` 是两个相邻脉冲的时间间隔（秒）。一个脉冲来了，记下时间戳；下一个脉冲来了，减一下，`60 / 差值` 就是瞬时转速。

<img src="https://images-1303887003.cos.ap-beijing.myqcloud.com//images/pulse-interval-rpm.svg" alt="脉冲间隔测速原理" style="width:100%;max-width:800px;display:block;margin:1.5em auto;border-radius:6px">

**两种方法的延迟对比：**

| 方法 | 延迟 | 适用场景 |
|------|------|----------|
| 计数法 | 固定 1 秒 | 低速监控、日志记录 |
| 间隔法 | ≤1 个脉冲周期 | 实时控制、PID 反馈 |

对 PC 风扇（720 RPM、约 12 Hz 信号），间隔法的延迟最多 83 ms，比计数法的 1 秒快了 12 倍。电机转速越高，延迟越短 —— 高速时需要的正是更快的反馈。

## 给编码电机做一次完整测速

把方向判断和速度测量结合起来，就是完整的编码电机测速驱动：

```js
// motor2.js - 编码器测速示例
var encoder = {
  left: { 
    count: 0, lastA: 0, lastB: 0,
    lastTime: 0, speed: 0, lastCount: 0
  }
};

// 正交解码（四倍频）
function leftEncoderHandler() {
  var a = digitalRead(pins.left.encA);
  var b = digitalRead(pins.left.encB);
  if (a !== encoder.left.lastA || b !== encoder.left.lastB) {
    if (a === b) encoder.left.count++;   // 方向判定
    else         encoder.left.count--;
    encoder.left.lastA = a;
    encoder.left.lastB = b;
  }
}

setWatch(leftEncoderHandler, pins.left.encA, {repeat:true, edge:'both'});
setWatch(leftEncoderHandler, pins.left.encB, {repeat:true, edge:'both'});

// 定期计算速度（脉冲/秒）
setInterval(function() {
  var now = getTime();
  var dt = now - encoder.left.lastTime;
  if (dt > 0) {
    encoder.left.speed = (encoder.left.count - encoder.left.lastCount) / dt;
    encoder.left.lastCount = encoder.left.count;
    encoder.left.lastTime = now;
  }
}, 100);
```

这里用了**计数法的变体**而不是脉冲间隔法：每 100 ms 读一次累计计数的差值，除以时间窗口得到平均速度。比 1 秒窗口更新快 10 倍，比纯脉冲间隔法稳定（不会因为个别脉冲抖动而跳变）。

实际应用中，我一般这样选：

- **PID 闭环控制** → 100 ms 滑动窗口，兼顾更新率和稳定性
- **状态监控、报警** → 脉冲间隔法，响应最快
- **里程累计** → 原始累计计数，不需要换算成速度

## 怎样验证测速准不准？

最直观的方法：**把测出来的转速跟理论值对比。**

给定一个 PWM 占空比（比如 50%），用示波器看编码器波形，算算频率。Espruino 串口打印的 RPM 换算回频率（RPM × 脉冲每圈 / 60），应该跟示波器读数吻合。

没有示波器也行。给电机一个固定 PWM，`console.log` 连续打 20 秒转速读数，看方差。电机机械惯性大，转速本身不该剧烈抖动——如果读数在 ±30% 范围内乱跳，大概率是编码器误触发，检查上拉电阻和电源滤波。

另一个简单办法：让电机空载匀速转，记下 10 秒内进中断的总次数，除以 10 得到每秒脉冲数，再换算成 RPM。跟串口打印的数值对比，误差应该在 1-2% 以内。

## 总结：构建测速环节的技术要点

编码电机测速这件事情，拆开来看就三层：

1. **信号层** — 正交编码器的 A/B 两相，相位差判方向，边沿跳变数脉冲。用 `input_pullup` 抗干扰。
2. **解码层** — 每个边沿都进中断，读两相电平比较。四倍频解码每转能拿到 4xPPR 个脉冲，低速下精度更高。
3. **转速层** — 计数法简单但有固定延迟，间隔法响应快但容易受单脉冲抖动影响。实际工程中 100 ms 滑动窗口是很好的折中。

这三个层面跟 DRV8833 的驱动力控制是正交的。驱动只管给电，编码器只管反馈——两者各司其职，PID 在中间把它们串起来。

## 文件

- `fans_1.js` — 脉冲间隔法测速原型（PC 风扇场景）
- `motor.js` — 基础版编码器驱动（四倍频正交解码 + DRV8833 方向控制）
- `motor2.js` — 改进版编码器驱动（含速度计算、里程换算、PID 闭环）
- `images/encoder-forward.svg` — 正转编码器 A/B 相波形图
- `images/encoder-reverse.svg` — 反转编码器 A/B 相波形图
- `images/pulse-interval-rpm.svg` — 脉冲间隔测速原理图

从 PC 风扇到编码电机，测速的本质就一句话：**数脉冲，量间隔。** 前者告诉你转了多少，后者告诉你转得多快。两样凑齐了，电机就有了心跳。
