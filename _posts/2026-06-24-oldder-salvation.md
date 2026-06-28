---
layout: post
title: "一本书的救赎"
author: "David"
header-style: text
tags: 
    - stem教育
    - STM32
    - Espruino  
    - 软件 
---

# 一本读了十年的书

2017年，我在图书馆 IT 区的角落里翻到一本书，封面上画着一块小巧精致的电路板。没想到十年后，它真的改变了我做产品的方式。《自己动手做嵌入式产品》[^1]

![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/out.png)

因为之前在另一本嵌入式书籍《完美图解物联网IOT实操》[^2]中记录了Espruino origin板，当我看到这本《自己动手做嵌入式产品》时，想要动手一试的感觉油然而生。

经过淘宝的比较和购买我找到一块stm32f401ccu6最小系统板。但不能完美烧录网站提供的固件且缺少书中实验工具（一个旧的酷睿CPU风扇），于是又与这本书擦肩而过了。

![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/out2.png)

书中的简洁实例，及作者在字里行间透露出的对电子实验，程序设计的喜爱与童年经历的怀念深深勾起了我心中的共鸣。

事情的转机出现在疫情过去后的第三年，此时人工智能的飞速发展，使得智能产品的开发更加方便。而实验工具也因为我的一次蓄谋已久的装机计划而得以（免费）实现。我使用当下流行的codex框架加DEEPseek模型，成功地将Espruino Pico板的固件烧录到了STM32F401CCU6最小系统板中。见我的固件开发笔记[^3]

![](https://images-1303887003.cos.ap-beijing.myqcloud.com//images/esp-exp.png)

对于手头有工具，有米，有技术的人来说实现一个嵌入式开发很容易，但是如果没有，就会很麻烦，但是时间给了我最好的答案。因为爱要用。

你也有过一本改变了你的书吗？欢迎在评论区分享。

[^1]: [《自己动手做嵌入式产品》](https://baike.baidu.com/item/%E8%87%AA%E5%B7%B1%E5%8B%95%E6%89%8B%E5%81%9A%E6%99%BA%E8%83%BD%E7%94%A2%E5%93%81/53277591)
[^2]: [《完美图解物联网IOT实操》](http://www.broadview.com.cn/book/5754)
[^3]: [Espruino固件开发](https://davidit.top/2026/06/19/espruino-firmware-2/ )
