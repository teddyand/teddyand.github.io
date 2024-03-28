---
layout: post
title:  "淘宝stm32F401C×板分析报告"
author: "david chen"
tags: report
excerpt_separator: <!--more-->
---
### 前言
无论匈牙利在19世纪末至20世纪30年代的精英教育制度还是二次大战后中、日、美的民主制教育。追求的都是在经济条件许可下为有志于学习的人提供尽可能稳定的学习氛围，从而培养出高效率、高成才度的人才。<!--more--> 然而总有些人需要牺牲自己去做一些高水平的人不屑于做、低水平的人不能做的事情。工作并非大学毕业后才能做的事情，当然也并非退休以后不能做的事情，其实没有什么所谓的工作，其实你在做的只不过是他人（老板/客户）觉得有价值的事情

从以上这些论断可以得到有关创（业）客教育的几个关键词：经济、稳定、效率、牺牲、做（工作）。结合这些年来的创（业）客潮流，及自身对于教育行业和嵌入式系统几十年来剪不断、理还乱的情结。特做如下报告。


### stm32单片机应用展望
在我刚刚创业的初期，ARM开发可说是一个天花板级别的存在，不仅因为高昂的开发设备（编程器件、正版软件...）还有他相对复杂的数学运算功能，可以说是可望而不可及。几十年过去了，当前的开源软/硬件方案因为库函数的使用、ISP技术的使用和芯片flash存储单元的指数级增加，让处于中底层技术爱好者蠢蠢欲动。

#### 淘宝stm32F401C×单片机概述
对于淘宝的感情，我们可以用又爱又恨来形容，有多少人为它“剁手”、它又为我们带来了多少便利？！然而对于一些创客群体，似乎视淘宝为创新精神的杀手。但在软件行业向来有“避免重复造轮”的说法，因此如何处理好淘宝的关系成了我们需要谨慎对待的问题
话不多说言归正传：淘宝上stm32F401系列最小系统板价格在20～30元RMB，其核心为ARM Cortex -M4 32位 微控制单元和浮点运算单元 具有（105*100万）条指令/秒的运算能力 11路定时 1路数模转换 11路通讯接口（I2C 3、SPI 4、USART 3、SDIO 1）共81个IO端口 84M时钟频率 JTAG和SWD调试接口（本案例不会用到）UFQFPN48引脚封装。

[STM32F401CUD6数据书](https://www.espruino.com/datasheets/STM32F401xD.pdf)、
[STM32F401CUD6应用手册](https://www.espruino.com/datasheets/STM32F401xD_ref.pdf)根据芯片具体型号的不同只有Flash存储大小不同，其余接口及复用功能全部相同。

|  | CBU6  |  CCU6    | CDU6   | CEU6    |
|:----: | :----:   |  :-----:   | :-----:  |	:-----:  |
|flash| 128 K  | 256K  | 384K | 512K |
|pin |48|48|48|48|

#### ISP技术
![USB转TTL电平电路](https://img.alicdn.com/imgextra/i4/49758426/TB2NVVgoC0mpuFjSZPiXXbssVXa_!!49758426.jpg)把计算机的USB接口转成单片机的USART串口让计算机可以与单片机相互通信，而boot0、boot1两个引脚的状态决定了单片机的工作方式。**注:在stm32F4×系列单片机中BOOT0为B2引脚，BOOT1为A4（固定）**
启动模式说明：
![boot 逻辑表](https://tse1-mm.cn.bing.net/th/id/OIP-C.GiVrS97P96ilxx_IvOdDpgHaBh?pid=ImgDet&rs=1)
当boot0为1、boot1为0时，单片机复位后将运行Bootloader程序。Bootloader程序是由ST公式在芯片出厂时写入单片机的一段程序用户不能修改。这段程序的任务就是与计算机上ISP软件相连把HEX、bin文件写入单片机flash或ram的。ISP模式多用于开发过程中的程序调试。Boot0为0无论Boot1为何状态，单片机再次复位后都会运行Flash里面的用户程序。

因此针对stm32F4系列开发板通过USB转ttl时需要将IO口中的某路USART×（淘宝建议用PA9/PA10）与RX/TX连接来下载固件。


#### 当前流行的计算机编程语言
由于开源思想的注入，通过精通操作系统、编译原理...的计算机高手，对底层库的封装与编译。许多新的语言皆可作为硬件的直接编程语言来使用，也为本报告及其后相关板卡的应用开发提供了广阔的前景。

* javascript
产生于1995年的计算机语言
* python
产生于1990年的语言应用前景广阔在时髦的人工智能、大数据、领域
* C/C++
分别产生与1970年和1985年的计算机底层语言最为接近与硬件适配度极高

##### 学习资源

[![Espruino pico](https://www.espruino.com/refimages/Pico_angled.jpg)](https://www.espruino.com/Pico)
[![micropython](https://raw.githubusercontent.com/micropython/micropython/master/logo/upython-with-micro.jpg)](https://github.com/micropython/micropython/tree/v1.8.2)

### stm32F401C×板开发可行性分析
#### 刷固件
根据stm32F401C×最小系统原理图

![stm32F401C*](https://res.nuedc-training.com.cn/forum/202104/29/221134rfuuvnuzs4zl5is5.png)

##### Espruino下
[Espruino build](https://github.com/espruino/Espruino/blob/master/README_Building.md)/boards/PICO_R1_3.py需要做如下修改
```
......
chip = {
  'part' : "STM32F401CDU6",	/*此处改为STM32F401CCU6
  'family' : "STM32F4",
  'package' : "UQFN48",
  'ram' : 96,	#改为64
  'flash' : 384,	#此处该为256
  'speed' : 84,
  'usart' : 6,
  'spi' : 3,
  'i2c' : 3,
  'adc' : 1,
  'dac' : 0,
  'saved_code' : {
    'address' : 0x08004000,
    'page_size' : 16384, # size of pages 16k
    'pages' : 3, # number of pages we're using
    'flash_available' : 384-64 # 256-64 Saved code is before binary, test against full size minus offset
  },
  'place_text_section' : 0x00010000, # note flash_available above
};

devices = {
  'OSC' : { 'pin_in' :  'H0', # checked
            'pin_out' : 'H1' }, # checked
  'OSC_RTC' : { 'pin_in' :  'C14', # checked
                'pin_out' : 'C15' }, # checked
  'BTN1' : { 'pin' : 'C13', 'pinstate' : 'IN_PULLDOWN' }, #此处改为A0
  'LED1' : { 'pin' : 'B2' },	#此处改为 C13
  'LED2' : { 'pin' : 'B12' },	#此处可注销
  'USB' : { 'pin_charge' :  'B0', 	#可注销
            'pin_vsense' :  'A9',	#可注销
            'pin_dm' : 'A11',   # checked
            'pin_dp' : 'A12' }, # checked
  'JTAG' : {				#可注销
        'pin_MS' : 'A13',
        'pin_CK' : 'A14',
        'pin_DI' : 'A15'
          }
};
......
};
......
```
在linux下使用设置路径
`source scripts/provision.sh PICO_R3_1
`

编译命令
`make clean && BOARD=PICO_R3_1 RELEASE=1 make
`

* Micropython下