---
layout: post
title:  "蓝牙遥控流水灯开发有记"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
---

# 制作一个蓝牙遥控流水灯
## 1. 硬件准备
- 1个esp32(wemos d1 r32开发板)
- 1个手机（android或ios）
- 8个led灯
- 8个220欧电阻
- 1个面包板
- 1个杜邦线包
## 2. 软件准备
- 1个esp32的开发环境（arduino ide或者microblocks）
- 1个蓝牙串口调试工具（android上使用bluetooth serial app，ios上使用ble console app）
- 1个app inventor app
## 3. 电路连接
见下图：
![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/flow_led.png)
于arduino uno板不同wemos d1 r32板属于低电平点亮，所以需要在led灯和引脚之间连接一个220欧电阻，（如图），来将led灯的负极连接到esp32的引脚，而引脚的正极连接到esp32板5V上。此处使用wemos d1 mini代替wemos d1 r32板。具体引脚见[积木式项目开发](https://davidit.top/2026/04/21/microblocks/)
## 4. 程序设计

### 第一步设计一个流水灯程序（见图）：
![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/water_bit.png)
**注： 因为esp32引脚编号不像arduino那样连续，所以需要根据引脚编号来连接电路,在此先建立一个引脚映射表：（如图）**此程序为一个双向流水灯

### 第二步设计一个使用手机现成蓝牙调试APP控制led灯的程序(见图):
![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/ble_seri_led.png)
之后打开app 连接蓝牙并发送字符串（10,11,20,21,30,31,40,41...）会看到led灯依次打开熄灭。
### 第三步设计一个app inventor app来控制led灯（见图）：
esp32端：
![esp32端microblocks程序](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/ble_led.png)
app inventor端：
![app inventor端运行截图](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/appinventor_ble_led.png)

### 第四步加入手机加速度传感器来控制led灯（见图）：

开发中........