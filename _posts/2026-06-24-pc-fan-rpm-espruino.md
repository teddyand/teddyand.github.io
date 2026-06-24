---
layout: post
title: "用 Espruino 给 PC 风扇装转速表"
author: "David"
header-style: text
tags: 
    - stem教育
    - STM32
    - Espruino    
---

事情的起因很简单：我的开发机太吵了。

周日下午调试 ESP8266，机箱风扇忽然像波音 747 起飞一样轰鸣。我盯着那坨黑色塑料，心里只有一个念头——**兄弟你转那么快到底图啥？**

我当然可以进 BIOS 调转速，但那样太正常了。一个合格的 maker，应该用代码把问题复杂化。

## 硬件

PC 风扇有三根线：红（供电）、黑（地）、黄（测速信号）。黄线是个开漏输出，每转一圈输出 2 个脉冲。

手边有块吃灰半年的 Espruino Pico，直接怼上去：

| 风扇线 | Espruino | 说明 |
|--------|----------|------|
| 黄线   | A8       | 测速信号输入 |
| 红线   | 5V       | 供电 |
| 黑线   | GND      | 地 |

不需要任何电阻电容。硬件部分五分钟搞定。

## 第一版：每秒计数

思路直白——每秒数脉冲，算 RPM。

```js
var SENSE = A8;
var counter = 0;

function onChanged(e) {
  counter++;
  digitalWrite(C13, e.state);
}

setWatch(onChanged, SENSE, { edge: "both", repeat: true });

function onSecond(e) {
  digitalWrite(A9, counter < 30);   // 低于 30 脉冲/秒亮灯报警
  console.log(counter * 60 / 2);     // counter × 60s ÷ 2 脉冲/转
  counter = 0;
}

setInterval(onSecond, 1000);
```

运行起来，串口打印 `720`、`718`、`723`。风扇稳稳 720 RPM，安静如鸡。

**问题在哪？** 延迟。你满转冲上 3000 RPM，它要等一整秒才反应过来。等你看到数字，风扇已经叫完了。

## 第二版：脉冲间隔

不等了——直接在脉冲到来时算瞬时转速。

```js
var rpm;
var counter = 0;
var SENSE = A8;
var lastPulseTime;

function onChanged(e) {
  if (e.state) {
    var timeDiff = e.time - lastPulseTime;
    lastPulseTime = e.time;
    rpm = 60 / timeDiff;              // 60s ÷ 脉冲间隔 = RPM
    digitalWrite(A9, rpm < 900);      // 低于 900 RPM 亮灯
  }
  counter++;
  digitalWrite(C13, e.state);
}

function onSecond(e) {
  if (counter == 0) digitalWrite(A9, 1);
  counter = 0;
  console.log(rpm);
}

setWatch(onChanged, SENSE, { edge: "both", repeat: true });
setInterval(onSecond, 1000);
```

改动不到 10 行，延迟从"最差一秒"变成"最大一个脉冲周期"。

## 精度说明

这里算的是瞬时转速，不是平均值。风扇机械惯性大，转速本身不会突变，单脉冲间隔算出来的数值已经很稳。

如果需要更平滑的读数，加个 5 次滑动平均即可：

```js
var readings = [];
function smoothRPM(rpm) {
  readings.push(rpm);
  if (readings.length > 5) readings.shift();
  return readings.reduce((a, b) => a + b, 0) / readings.length;
}
```

不过对我来说没必要——灯亮了就行。


<video width="520" height="400" controls>
   <source src="https://images-1303887003.cos.ap-beijing.myqcloud.com/videos/espruino_fan.mp4" type="video/mp4">
</video>

## 实测数据

| 转速       | 声音           |
|------------|----------------|
| < 900 RPM  | 报警灯亮       |
| 720 RPM    | 空载，安静     |
| 1200 RPM   | 轻度编译，轻风 |
| 1800 RPM   | 中度负载，可闻 |
| 2400+ RPM  | 满载，明显噪音 |

## 扩展方向

这个项目到此为止。但扩展方向很明确：

- 加 PWM 信号线，用 PID 控制转速
- 接 MQTT 推手机通知
- 连继电器，温度过高自动断电

不过目前的报警灯已经足够。一个好的 side project 不需要做完——做到刚好有用的那个点就够了。

## 文件

代码就两个文件，放在仓库里：

- `fan.js`（276 字节）——基础计数版
- `fans_1.js`（608 字节）——精密脉冲间隔版

整套代码没有任何 `require`，没有 npm，没有 webpack。就一块板子，一根杜邦线，85 行 JavaScript。

这大概就是嵌入式 JavaScript 最迷人的地方。
