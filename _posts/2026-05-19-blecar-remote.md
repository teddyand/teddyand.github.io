---
layout: post
title:  "arduino蓝牙车远程（语音）控制"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
---

# 远程控制（电脑端）

通过注册百度ai开放平台，实名认证获得api key后在控制台搜索语音技术，我们可以创建一个自己的[语音助手](https://console.bce.baidu.com/ai-engine/speech/overview/index)。通过它我们可以实现语音识别，文本合成等功能。
点击在线调试功能，我可以在浏览器中直接调试语音助手的接口，实现语音识别和文本合成的功能。随意选取一段语言代码用trae帮我们生成一个某框架下（express、flask、django、vue、react等）的语音识别服务。

![百度语音助手测试码](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/baidu_recognize.png)

随着现代科技的发展，远程控制成为了一种常见的方式。在蓝牙车远程控制中，电脑端通过蓝牙与车端进行通信，实现对车的控制。依靠百度ai的智能助手，电脑端可以通过语音指令来控制车的运动。以前我也不敢相信，今天却可以仅仅用一个晚上睡前加晨起的几个小时时间实现。

结合前面提到的[j5智能车前端控制](https://davidit.top/2025/09/02/react-j5-car/)，我们可以实现网页按钮+语音指令来控制车的运动。