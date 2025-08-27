


## 2023大卫的创客工厂年终项目总结——拉清单
立冬之后是小雪，今年总结提前写！！疫情这三年创客项目可圈可点，鉴于[试玉行动](https://davidit.top/2022/07/16/jadeI/)的原则——利用现有资源开展创客项目体验。将过往的创客项目列具清单以供后继展开可持续研究。

### 项目
1. wechaty[^1]项目：是一个聊天机器人对话项目，该项目可以外挂于微信平台，通过一些条件甚至算法触发微信相关事件（推送图文、语音、视频消息;）支持多人群聊<!--more-->，智能对话，消息处理等功能。你可以通过6行代码，搭建一个聊天机器人。应用到nodejs、typescript、....等技术，具有javascript技术的人可以较顺利实现所需功能。该项目是一些具有留学背景的人利用业余时间开发起来的，并在国内实现了项目众筹，引起业界关注。但是目前似乎正被微信平台的智能推荐功能所取代，但不失为一个软件程序员学习typescript项目的很好的练手起始平台，但是每个月200元的token费用及服务器租用金（各平台不同）有些让人望而却步。

2. espruino[^2]、micripython[^3]、arduino mblog、codecraft[^4]多语言控制智能车项目:在当前习近平主席出访美国旧金山参加23年度APEC会议的大背景下，主席强调的开放的大门只会继续打开而不会关闭的当下。该项目具有STEM教育的特色，结合blockly[^5]、Mixly[^6]——青少年图形化编程入门及算法思维养成的传习。在寓教于学中可以让青少年建立起计算思维、了解多种程序语言、具备模块化硬件知识、增强动手能力、强化抽象思维与发散型工程化思维能力。是AI时代最好的stem教学手段。

3. 大数据与算法：作为一个初级程序员水平的创客，一直对算法爱恨交织，到底具有什么样的数学水平才是一个合格程序员应该具备的良好素质。鉴于此创客希望从一个入门级的水平来从新审视自己或者对后来有志于此的人提供一个参照。

4. gollum[^7] wiki博客平台搭建：配合pandoc软件及github.io博客及自媒体平台（微信公众号等）起到卡片笔记写作的功能，将各种文档写作碎片化并专业化

5. 文学作品阅读：阅读了多部名人传记《纳什》《冯.诺依曼》《狄更斯》《歌德》相关文学作品《远大前程》《大卫.科博菲尔》（中/英）《九三年》英文版从而引起对维多利亚时代，法国大革命时代文学家及其作品的兴趣，继而对写作发生兴趣。准备继续阅读《双城记》《悲惨世界》《教授与疯子》从而完成对人性救赎、勇气、父权、科学与革命共同体概念等问题的思考。


### 项目列表

| 项目 | 程度描述 | 举例 | 参考书目 | 
| ------ | ------ | ------ | ------ |
| wechaty | [入门视频](https://v.qq.com/x/page/k0726ho4rce.html)、[本地运行起步](https://wechaty.js.org/docs/getting-started/running-locally) 通过[localtunel](https://localtunnel.github.io/www/)开放本机端口运行微信[official-account](https://github.com/wechaty/puppet-official-account)服务器 | [javascript](http://davidit.top/2022/09/16/nodejs-scraper/) | [博客:应用文章](https://wechaty.js.org/blog/)、[wechaty 公众号开发](https://wechaty.js.org/2020/11/01/wechaty-puppet-oa-released/) |
| 智能车 |  | [项目repo](https://github.com/teddyand/balance-vehicle)、[app制作](http://davidit.top/2021/11/13/cordova-framework/)、 [愿景](http://davidit.top/2024/04/27/PID-theory/)|   |
| 大数据与算法 | 算法即神秘由高深似乎影响这我们的生活，如何将算法从生活中提炼又作用于生活是一个程序员对自我修养的高级要求 | [文1](https://mp.weixin.qq.com/s?__biz=MzU4MTQ3OTE1NQ==&mid=2247484886&idx=6&sn=ffc94bd6f489ccfcd5b7d081c3998113&chksm=fd47ba4aca30335c4c38c7abadd8a8d848c95de434644430dd02bd8772f0fa3602f8559347ff&token=329935964&lang=zh_CN#rd)、[文2](https://mp.weixin.qq.com/s?__biz=MzU4MTQ3OTE1NQ==&mid=2247484886&idx=4&sn=160b872b4362a5e746fbf2d926c3a49a&chksm=fd47ba4aca30335c737514a382a50ed66957539016faf3b1dcd2f3007f3ff4f519b8e7142d8d&token=564283773&lang=zh_CN#rd) | |
| 温湿度监控 | 在例文的基础上希望实现esp8266+node.js 后台数据库方式实现现多点网络温度监控,进一步对esp32、esp8266的开发环境做深入了解 | [一个温湿度监控项目](https://www.jianshu.com/p/11808de7922f) |  |
| django网站 |一个部署与新浪云的博客，熟悉python语言与Django框架的个人笔记博客每次充值云豆对于使用数据库的内容极其消耗云豆（每次充值10RMB）不经访问，因此考虑经济允许条件下租用服务器加域名的方式（已完成）|[repo](https://github.com/teddyand/django_on_SAE/tree/master)||
| next.js框架 |一个使用了react类似框架技术、模板、rest api、json-server、等相关技术结合ai内容虚拟的人物简历、文章展示网站,后期结合graphql 与postgre数据库网络存取技术|[myrepo](https://github.com/teddyand/triple-city), [大卫三城记](https://www.triplecity.site/) ||
| 我的wiki与博客 | [博客](https://teddyand.github.io/)、[维基](https://github.com/teddyand/balance-vehicle/wiki/Review),结合jekyll vitepress博客框架及文档工具pandoc、latex overleaf介绍博客搭建，写作等相关技术 |  [论文1](https://mp.weixin.qq.com/s?__biz=MzU4MTQ3OTE1NQ==&mid=2247484379&idx=5&sn=2d65b110f7c822fcdd3263ccc97077d4&chksm=fd47bc47ca303551cae9e45248dd47acdc1e1d85169a851c8a74bd4e7af792ac08f18e200183&token=1004565564&lang=zh_CN#rd),[论文2](https://mp.weixin.qq.com/s/CEFcK2jr145Bd7P5EholzQ) |  |
| 我的阅读 | 通过书籍（纸质）的阅读，帮助AI时代的人们（程序员）找到心理与技术的平衡点，不卷，不颓、不凡尔赛。如何保持一个良好的终生编程习惯 | [笔记1](https://davidit.top/2023/03/03/scientific-genius-von/)、[笔记2](https://davidit.top/2023/02/05/beautiful-mind/)、[笔记3](https://mp.weixin.qq.com/s?__biz=MzU4MTQ3OTE1NQ==&mid=2247484886&idx=7&sn=b286c185d71a2d55d4611d4351747b8f&chksm=fd47ba4aca30335cdb5f809e12331b79efc935a86def149832a52b59ffa0fc13c855c7048714&token=329935964&lang=zh_CN#rd) | [书目](https://mp.weixin.qq.com/s/heuMaSWijv6HOYeZPwsdjQ) |




### Reference
[^1]:[wechaty](https://github.com/wechaty/wechaty)
[^2]:[espruino](https://www.espruino.com/)
[^3]:[micropython](https://micropython.org/)
[^4]:[codecraft](https://ide.tinkergen.com/)
[^5]:[blockly](https://developers.google.cn/blockly?hl=zh-cn)
[^6]:[mixly](https://mixly.readthedocs.io/zh-cn/latest)
[^7]:[gollum](https://github.com/gollum/gollum)