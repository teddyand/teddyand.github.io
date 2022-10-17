---
layout: post
title: "jekyll plugin how to deploy on github"
author: "Teddy"
tags: jekyll
---

### jekyll插件使用概述
jekyll插件在github上只能使用部分白名單插件對於大部分插件需要定制workflow來使用,下面參考如下:[jekyll-spaceship使用與部署](https://github.com/jeffreytse/jekyll-spaceship)
* 首先來建立一個workflow並將它提交到個人repsitory(在.github/rkflows目錄下建立一個learn-github-action.yml文件):
{% highlight yml %}
name: learn-github-actions
run-name: ${{ github.actor }} is learning GitHub Actions
on: [push]
jobs:
  check-bats-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
         node-version: '14'
      - run: npm install -g bats
      - run: bats -v
{% endhighlight %}

* 之後導航到個人倉庫主目錄並且點擊Actions並且在All Workflows下將看到剛才所創建的learn-github-actin項
最終會看到![workflows actions job](https://docs.github.com/assets/cb-69522/images/help/images/overview-actions-result-updated-2.png)表明工作流運行正常.