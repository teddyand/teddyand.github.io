---
layout: post
title:  "jekyll博客剪贴板拷贝功能开发有记"
date:   2022-09-22 17:30:01 +0800
categories: [Language]
---

有位科学家说过，“造原子弹就像吃饭，别人碗里有啥自己也得有啥...”,同理看着别人的github文章独有剪贴板拷贝按钮，我也想有，可是凭借着仅仅两年的C语言程序员工作经验，对于Node.js语言能否学会掌握么？万事开头难，既然决定要学他，那就努力走下去就是了。

## 博客中增加代码拷贝功能

基于上面的想法，并且有着家里的互联网加持，干就是了！开始在网上找到下面几个网址作为我开发（抄袭）的主要来源：
[一个博士的网站](https://be-my-only.xyz/blog/TeXt-copy-to-clipboard/index.html)
让我知道了如何在Jekyll博客中添加js代码，以及这些代码的主要来源[clipboardJS](https://clipboardjs.com/),由于对自己的编程不太自信（人家可是博士耶！）不敢将代码整体拷贝来用（害怕费力不讨好）但还是克隆了他的整个博客，查看了一下代码结构，想试着自己写一下（简直天方夜谭）顺道浏览了他的简历及相关Jekyll开发记录。经过冥思苦想，好在作诗的功夫在诗外，虽然代码不熟，英语至少还是能简单的表达一下的，于是在输入了"How to add copyclipboard button in jekyll"后在网上找到了[一个老外](https://www.aleksandrhovhannisyan.com/blog/how-to-add-a-copy-to-clipboard-button-to-your-jekyll-blog/#1-copy-to-clipboard-include-_includes/codeheaderhtml)的博客，并按步骤输入了代码并调试了一下。发现新的问题：就是copyCode.js代码在非安全模式下不能启用，又又又经过了一段时间的苦想，还是决定用clipboardJS代码远程调用的方法实现剪贴板功能，于是继续搜网...终于不负有心人的找到了[另一个老外](https://github.com/marcoaugustoandrade/jekyll-clipboardjs)的github代码库，嘿嘿!这个是我想要的东西，代码不多还能看懂（因为之前学习爬虫程序对于Html标记的搜寻还比较熟悉）只是button的style太吓人（有点德古拉伯爵的味道）以后有时间慢慢修改吧。


总结：人不能拿着眼前的顺逆套用过去的失误并想着：**“如果当时我.....那么我现在就.....”**这是贪心，也许人生中的失去才是我们真正的得到。！感谢三位程序大佬的无私奉献，因为有你所以我也愿意。

![](//www.html5rocks.com/en/tutorials/video/basics/devstories.webm)
