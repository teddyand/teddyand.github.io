---
layout: post
title:  "物联网开发之‘InnoWay’"
date:   2022-10-6 16:30:01 +0800
categories: [Language]
tags: report
---


## 物联网（IoT,internet of things）前言

[物联网](https://baike.baidu.com/item/%E7%89%A9%E8%81%94%E7%BD%91/7306589)开发


### 软件开发‘自由’之路
“世上本没有路，走的人多了也就成了路” innovation是创新之意，也许创新都是从无路可走开始，因为外在无路可走人才开始格外关注起自己的需求，才是真正的从心（新）出发！歌德在《浮士德》中说过：“恐惧与希望是人类的两大敌人，因为前者让人什么也不敢做而后者让人什么都想干！！” 做为一名长期的灵活就业者，梦想有朝一日进大企业大公司从事专业开发似乎已属天方夜谭。但小公司的“事无巨细”似乎又是teddy所不愿意，好在“天生我才必有用”和特殊身份的加持让他至今还能在喜欢的道路上踽踽而行。希望文章能让后来者能在专业的道路上少走些弯路。

#### 硬件准备
<center class="half">
    <img src="https://ts1.cn.mm.bing.net/th/id/R-C.f35eed1972c78e1a9dbab217971decd1?rik=lD2GeGO8eg47Fg&riu=http%3a%2f%2fwww.lingzhilab.com%2flzbbs%2farduino%2fimg%2fArduino-UNO-R3%2fArduino-UNO-R3-img4.jpg&ehk=xqBU2FrtYREu5uQR5YmNLwJfmRYXos4kUSdTjXKqUfw%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1" width=150 height=70 data-zoomable /><img src="https://ts1.cn.mm.bing.net/th/id/R-C.62b1584a3e6b63caf338b40913e2a0d0?rik=JbNqfh6t40PH5w&riu=http%3a%2f%2fspotpear.cn%2fpublic%2fuploads%2fpicture%2fproduct%2fesp32%2fesp-wroom-32%2fesp-wroom-32-12.jpg&ehk=L7%2bKxbFuqt0zftoYEY%2bRBnF51DhuqqiHlYvPgV2ts54%3d&risl=&pid=ImgRaw&r=0" width=150 height=70 data-zoomable /><img src="https://tse4-mm.cn.bing.net/th/id/OIP-C.ArDMWXO6r6ShtwFhVfHqWAHaFj?pid=ImgDet&rs=1" width=150 height=70 data-zoomable />        
</center>
arduino(系列), esp8266 node mcu, stm32当前的开源硬件方案比起我们刚入行时动辄上百上千元的硬件编程器和试验平台，不知要方便了多少，这大概要归功于ISP技术的使用和芯片存储单元的指数级增加，推荐在经济允许的情况下尽量使用开源技术支持强的产品。虽然模块化编程可以省去不少测试设备的成本，但如果真的对底层硬件的工作方式和细节着迷的话也可采用51、stm32等芯片编程烧写加设备调试的方式，**千万不要求新求强求异，该舍弃的就舍弃，路是可以回头的**,teddy在这方面是有过血的教训的。

#### 软件准备
<center class="half">
    <img src="https://pic.clubic.com/v1/images/1808623/raw" width=150 height=70 data-zoomable /><img src="https://tse4-mm.cn.bing.net/th/id/OIP-C.oIjlRy0Vh1XwgLxwmXUHEwAAAA?pid=ImgDet&rs=1" width=150 height=70 data-zoomable /><img src="https://pic4.zhimg.com/v2-9fb026c6b2d2d27e67e7481fe0832861_720w.jpg?source=172ae18b" width=150 height=70 data-zoomable />        
</center>
“工欲善其事，必先利其器”，做底层驱动就要用C用汇编，做系统集成就要用PERL，人工智能离不开Anacond、VS，手机开发用Android studio...而物联网开发离不开以下利器：arduino IDE,  node.js, johhny-five espruino mongodb

#### 程序语言
<center class="half">
    <img src="https://ts1.cn.mm.bing.net/th/id/R-C.c631220701cb8668e7fc96647083c8a3?rik=olDk%2bczUjvGzGA&riu=http%3a%2f%2fimg.cnlandscaper.com%2ffile%2fupload%2f201905%2f241747232825293226.jpg&ehk=m4RmY5LTNCt%2f%2bf2E8M311i6G5iTRoYQ2Z6EXlSdbxtw%3d&risl=&pid=ImgRaw&r=0" width=150 height=70 data-zoomable /><img src="https://www.pxcodes.com/d/file/cc73ad518c884e61bffc6c24ed00a46d.jpg" width=150 height=70 data-zoomable /><img src="https://ts1.cn.mm.bing.net/th/id/R-C.f9ced5052d152aa379857cfe1050b8a2?rik=jBRVrLJLLGtQSA&riu=http%3a%2f%2fjohnny-five.io%2fimg%2fstatic%2fjohnny-five-fb.png&ehk=P96dlggYXpmLp%2flmr4YgD%2fHd2ZkZe30yLX7s4mWF460%3d&risl=&pid=ImgRaw&r=0" width=150 height=70 data-zoomable /><img src="https://ts1.cn.mm.bing.net/th/id/R-C.861c3903a5c043278bf347db15ca3151?rik=fJrcfnMUe57J2A&riu=http%3a%2f%2fwww.hiholiday.com%2fuploads%2fallimg%2f200324%2f152121E39-2.jpg&ehk=K%2bHwSgpfvVWnRAsaGf3HaFOoO9h2dmBh0f7RHYWmaNo%3d&risl=&pid=ImgRaw&r=0" width=150 height=70 data-zoomable />
</center>
“不入这园林，怎知这春色如许！！”teddy经常怀疑自己参加工作之初对程序员身份选择的正确性，因为这确实是一个让人即觉得伟大又觉得渺小的行业，伟大的是，当你用新学到的语言启动了一个芯片，运行了一个技术博客，爬取了一份数据...你会觉得自己就是造物主成就满满！而当你面对着日新月异的知识而曾经的所学又无处应用时，你有会觉得自己被时代淘汰了！！这让teddy时时想起就业之初领导对他的敦促：“你要努力呀！！”也让他想起在职教育老师说过的话：“既然选择了程序员就不要被语言所困，最好什么语言都能掌握！！”以本人目前的认识这几门语言对物联网开发帮助很大：C语言、javascript语言、python语言.....（到底什么是对人进取的最好鞭策？认识待提高）

#### 系统集成
<img align="left" src="https://img.zcool.cn/community/019355603dc99611013f3745757e77.jpg@1280w_1l_2o_100sh.jpg" width=150 height=200 data-zoomable />
“我有世间最好的调料，谁能借我一些食材，我就能作出世上最美味的饭菜”——teddy小的时候曾经想用家里存的木头掏空做个铅笔盒子，但没有合适的工具（条件不允许）只能放弃，后来身为大学基础课老师的父亲告诉他这句话，.....是啊如果对美食都失去了尝试的愿望，那生活还有什么滋味呢？“勇于尝试”也许是我们人生道路上的最好鞭策了吧？！

<br>

<br>