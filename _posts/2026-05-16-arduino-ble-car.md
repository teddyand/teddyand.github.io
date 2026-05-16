---
layout: post
title:  "arduino蓝牙车再探"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
---

>  随着人工智能的进步我们可以通过与元宝、豆包、Deepseek对话来制作一个由sn754410（任意选择）驱动的arduino蓝牙智能车，下面记录了我的开发过程。

# 开发有记

## 开发驱动
最有意思的事情是让你的小车动起来，这与上帝造人似乎是一个原理。通过下面的对话：

```
给我一个基于sn754410驱动的arduino双轮驱动程序，两线控制。
```

智能体会提供详细的引脚接线控制方案，最终会给出一段程序代码。因为我们在前面的[项目](https://mp.weixin.qq.com/s/_6EVKahVF224oKq8B2ihrA)中已经制作好了小车的框架并用johnny-five项目测试过了，[智能车接线](https://davidit.top/2025/08/25/j5-motor-drive/)，考虑到这是一个用于stem教育的产品,它可用于多种平台，mblock、mixly、mind+、codelab等引脚需要事先安排。此处用5、6、10、11给出驱动。

![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/blecar_firststep.png)

## 开发通信
既然是智能体，它就需要一个与我们沟通的渠道，这里我们选择了hc-05蓝牙模块，两个[蓝牙配对](https://davidit.top/2025/08/14/robocar-1/),这个过程中所有碰到的问题我们都可以问智能体来解决。我更关注串口助手波特率与arduio串口波特率一致的问题。
### vscode的使用
用vscode打开上面这个arduino项目,安装豆包TRAE插件，后我们可以为它添加蓝牙串口通信功能。

在TRAE对话框中输入：
```
加入蓝牙软件串口控制电机运动并接收网页滑块传输的速度数值实时改变电机速度
```
经过一阵思索后TRAE给出**类似**下面代码：

![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/blecar_secstep.png)

这是添加应用后的样子呈现，之所以说类似，是因我本文的生成并非逐步按照开发流程记录，而是经过项目功能实现后的复盘，（并非指哪打哪里的神准）而是打到哪里算哪里的随性，这个过程中发现所谓的智能体也并非百分百的不差，也许正是这样的不准确也为我们使用者提供了更多比较与专注的空间与可能！！

## 远程控制（手机端及电脑端）
开发中........

