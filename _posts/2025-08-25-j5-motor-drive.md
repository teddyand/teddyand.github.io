---
layout: post
title:  "智能车驱动接线"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
    - 智能车
---

# 智能车（j5）mortor dirve by sn754410

## 总览
![双桥驱动](https://johnny-five.io/img/breadboard/motor-hbridge-dual.png)

## 芯片引脚
![sn754410引脚图](https://ts1.tc.mm.bing.net/th/id/R-C.43c3655afbf3788ac3474528b3b01fc5?rik=waxmuGWJ6yI3WA&riu=http%3a%2f%2fwww.pyroelectro.com%2ftutorials%2fsn754410_dual_motor_control%2fimg%2fsn754410_pinout.jpg&ehk=v%2bHFgdwWPCy6T5EUg7g98%2bwRok3tz8W1aVTBa7PGV54%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1)

## 接线


### 正转
![正传](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/dual_motor_fast.gif)

### 反转
![反转](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/dual_motor_slow.gif)


|   1A(方向引脚)值   |       2A(速度引脚)值           |  结果  |
| :--- | :---------------------: | :-------: |
|  HIGH |  LOW |  电动机按方向1旋转（正向）  |
|  HIGH |  HIGH |  没有电流流过电动机  |
|  LOW |  HIGH |  电动机按方向2旋转（反向）  |
|  LOW |  LOW |  没有电流流过电动机  |

## PWM调速
[参考——恨晚](http://www.pyroelectro.com/tutorials/sn754410_dual_motor_control/theory.html)

### pwm技术应用之呼吸灯
呼吸灯是一种通过亮度渐变模拟呼吸节奏的LED灯光效果，其核心原理基于PWM（脉冲宽度调制） 技术。以下是呼吸灯工作原理的全面解析：

理解呼吸灯原理不仅限于LED控制，其PWM技术和渐变思想广泛应用于电机控制、电源管理和音频处理等领域，是嵌入式系统开发的基础技能之一。