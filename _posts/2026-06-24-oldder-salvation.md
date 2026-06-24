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
泰迪疫情前某日（2017年）在图书馆闲逛，在IT领域中找到了一本书，名为[《自己动手做智能产品》](https://baike.baidu.com/item/%E8%87%AA%E5%B7%B1%E5%8B%95%E6%89%8B%E5%81%9A%E6%99%BA%E8%83%BD%E7%94%A2%E5%93%81/53277591)书中介绍了espruino的使用方法，以及如何使用它来开发智能产品。因为之前对另一本嵌入式书籍![《完美图解物联网IOT实操》](https://ts1.tc.mm.bing.net/th/id/R-C.6af656fcf06ad5b28131dbb2152ad260?rik=fuRtzEvbuOt1PQ&riu=http%3a%2f%2fdownload.broadview.com.cn%2fLargeCover%2f18092c3c1f4d13b6cfa4&ehk=XpvZHXRVl92VP%2b5%2f9ifmm09MrqqI%2bVBa4390nQy1yzM%3d&risl=&pid=ImgRaw&r=0)有过较为深入的了解。不知为何这类进口翻译的书籍特别吸引泰迪这个嵌入式爱好者？但因为书中的实例板卡，在淘宝上的售价有些难以承受（手指大小的一块板卡200￥）而国内替代品 stm32f103RCT6最小系统板又过于宽大，对于曾学过嵌入式开发的泰迪来说有些不够完美。好在淘宝的丰富产品让他找到了一块可以替换书中的Espruino Pico板的 STM32F401CCU6最小系统板口香糖大小（20￥），但是不能完美烧录网站提供的固件，加上书中实验工具的缺少（一个旧的酷睿CPU风扇）。这本书就作为了草草浏览而过去了，但是书中的简洁实例，及作者在字里行间透露出的对电子实验，程序设计的喜爱与童年经历的怀念深深勾起了泰迪心中的共鸣。以至于几次去图书馆，他都要将书带回家赏味一番才肯放手，也为自己的水平不够而叹息。

事情的转机出现在疫情过去后的第三年，此时人工智能的飞速发展，使得智能产品的开发更加方便。而实验工具也因为泰迪的一次蓄谋已久的装机计划而得以（免费）实现。![intel fan](https://m.360buyimg.com/mobilecms/s750x750_jfs/t1/98306/13/4766/98540/5de8d199E7dcc9ffb/19727e84bbd59ada.jpg!q80.dpg)

泰迪使用当下流行的codex框架加DEEPseek模型，成功地将Espruino Pico板的固件烧录到了STM32F401CCU6最小系统板中。见[Espruino固件开发](https://davidit.top/2026/06/19/espruino-firmware-2/)

对于手头有工具，有米，有哈数（技术）的人来说实现一个嵌入式开发很容易，但是如果没有，就会很麻烦，但什么是我能够跨越10年的时间将一本本来可能擦肩而过的进口翻译书籍变成了切实可行的操作指南呢？我想说我要感谢国家，感谢家人，感谢自己的努力（坚持）。因为爱要用，不是因为看见才去相信，而是因为相信才会看见。![感恩](https://ts3.tc.mm.bing.net/th/id/OIP-C.sf4yQCuThYsJ90eA50L3XAHaEg?r=0&rs=1&pid=ImgDetMain&o=7&rm=3)，祝愿祖国繁荣昌盛，人民幸福。
