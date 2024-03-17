---
layout: post
title:  "jekyll spaceship plugin develop"
author:	Teddy
date:   2022-11-05 17:10:01 +0800
tags:	Jekyll
---

I want to add local video and audio site to [jekyll-spaceship](https://github.com/jeffreytse/jekyll-spaceship). Would you give me some director on how to stat and how to do?


### audio plugin
There are 3 main audio site here I want to add:
1. QQ music
2. kugou muisc
3. netease music




<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=298 height=52 src="//music.163.com/outchain/player?type=2&id=1826179038&auto=1&height=32"></iframe>
網易音乐外链播放 大風吹

![](http://music.163.com/song/media/outer/url?id=170749.mp3)
網易音乐播放 沧海一声笑

![](//music.163.com/song/media/outer/url?id=4878606.mp3)
网易 播放　红尘笑

```
![](//music.163.com/song/media/outer/url?id=4878606.mp3)
```
最終決定使用网易音樂播放,原因其臨時音頻文件播放地址以//music.163.com/*../*..mp3格式符合jekyll-spaceship普通音频插件播放格式．

11月05日笔记　　待续．．．．．

About how to write a jekyll plugin:

* [How to write jekyll plugin](https://ayastreb.me/writing-a-jekyll-plugin/)

* [Build a custom jekyll command plugin](https://maxchadwick.xyz/blog/building-a-custom-jekyll-command-plugin#:~:text=Open%20the%20Gemfile%20of%20your%20Jekyll%20site.%20Specify,do%20gem%20%27jekyll-hello%27%2C%20%270.1.0%27%2C%20%3Apath%20%3D%3E%20%27%2FUsers%2Fmaxchadwick%2FProjects%2Fjekyll-hello%27%20end)

### video plugin
<div style="position: relative; width: 100%; height: 0; padding-bottom: 75%;">
    <iframe src="//player.bilibili.com/player.html?aid=757070901&cid=309296739&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="position:absolute; height: 70%; width: 70%;"> </iframe>    
</div>

 ![video](//www.html5rocks.com/en/tutorials/video/basics/devstories.webm)

 ![video](//techslides.com/demos/sample-videos/small.ogv?allow=autoplay)



