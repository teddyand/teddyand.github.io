---
layout: post
title:  "arduino esp32环境配置有记"
author: "David"
header-style: text
tags: 
    - stem教育 
    - Maker    
mathjax: true
---

# arduino安装es32开发板

## 问题
当前国家号召设备更新，我也h赶上了这波红利。过去使用了20年的e2140安装xubuntu20.04几乎i已经到达了这个级别的机器的极限能力，做文档处理、网站开发、硬件编程时需要忍受龟速运行。毕竟运行了20年的机器，许多软硬件已经是在超期服役了。之所以坚持为的只是不被这个飞速h发展的智能时代所淘汰。

更换了新硬件后，首先就是arduino環境安裝的問題，當前流行的esp32多種開發板都需要 espressif公司開發的板载包，但试过了网上的许多方法都不能成功下载运行,比如：[Getting Started with ESP32 in Arduino IDE - Beginner's Guide](https://www.espboards.dev/blog/setting-up-arduino-ide-esp32/)

## 解决
由于本人i是自动化专业毕业，不太喜欢各种手动方式安装，于是结合之前使用经验，虽然在新的电脑上可以使用[Watt toolkit](https://steampp.net/)加快软件开发的速度，但是要解决下载esp32 zip包还是需要[半自动github提速](https://gitee.com/toollab/github-hosts)功能，并使用下面命令启动DNS
```
resolvectl statistics #查看缓存
resolvectl flush-caches #刷新缓存
```
最后用一个BLINK程序来结束这次安装吧。
## 总结
网上得来终究浅，不经过一番实践探索，一个环境能够运行得流畅顺手是不可能的。

还型