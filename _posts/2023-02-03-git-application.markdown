---
layout: post
title:  "git应用（一）"
author: "david chen"
tags: Example
excerpt_separator: <!--more-->
---

### 拉取代码
```
1. mkdir myproj "建立目录"
2. git init	"初始化仓库"
3. git remote add origin git@github.com:***/****.git "与远程仓库建立连接" <!--more-->
4. git fetch origin source（source为远程仓库的分支名）"拉取远程分支到本地"
5. git checkout -b dev(本地分支名称) origin/source(远程分支名称) "在本地创建分支dev并切换到该分支"
6. git pull origin develop(远程分支名称) "把远程分支上的内容都拉取到本地"
```
完成上述步骤后可在本地myproj目录下看到远程分支（source）下的文件

### 推送代码
如果远程已经有指定的分支，使用下面命令进行关联： 
```
 git branch --set-upstream-to=<仓库名>/<分支名> 
```
命令执行之后，使用 git branch -vv 可以查看分支关联情况
```
git add .
git commit -m "memo"
git push origin
```

```
git checkout master -- src/main.js
```
上述命令将从名为master的分支中拉取src/main.js文件。[源](https://geek-docs.com/git/git-questions/197_git_how_to_pull_a_specific_file_with_git.html)
**待续**