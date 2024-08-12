---
layout: post
title:  "Cordova框架试用"
author: David
date:   2021-11-13 07:50:01 +0800
categories: [笔记,计算机]
tags:	[软件,arduino,Esp]
excerpt_separator: <!--more-->
---

## 认识Cordova
本章将介绍一款开发者使用HTML5,Javascript和CSS等Web技术,开发手机平板电脑等运行App框架:PhoneGap/
Cordova,及及创建运行App操作界面外观的JQuery Mobile框架。前者付费后者免费<!--more-->

<center class="half">
    <img src="https://spotsolutions.com/wp-content/uploads/2017/06/cordova_logo_normal_dark_large.png" width=300 height=100 data-zoomable /><img src="https://cms-assets.tutsplus.com/uploads/users/1855/posts/29323/image/angular-ionic.jpg" width=300 height=100 data-zoomable />        
</center>

#### 手机网页与手机App的不同
其实Cordova[^C]就是由一个Web浏览器核心，加上插件所组成的框架。这就是为什么我们可以用网页技术创建App 
——因为每个Cordova App就相当于一个定制的Web浏览器。

## Cordova的环境配置
博主曾在windows 7环境与Xubuntu20.04环境成功配置了Cordova Android手机App编译环境，现就配置体会与过程记录如下：
开发Android App需要安装软件如下：

- Java软件开发包（JDK）;
- Node.js(及内置npm);
- Apache Ant;
- Android 的软件开发工具（SDK）;
- Cordova命令行工具。

Node.js的安装参照[试玉]({{site.url}}/posts/jadeI/)，其余软件的安装说明见下。

### 下载与安装JDK
* Xubuntu JDK 安装[^1]

`` sudo apt-get install openjdk-8-jdk``

`` java -version``

* Windows 7 安装需要在[Oracle 官网](https://www.oracle.com/java/technologies/downloads/#java8)下载相应软体[^2]

### 下载设置Android SDK
Android开发者网页提供的标准开发工具叫作Android Studio(注：博主刚参加工作时对Visual Studio一往情深)
* Xubuntu下安装Android SDK [^3]
* Win7下安装Android SDK[^2]    
为了更敏捷的学习只安装需要的SDK工具并附软体下载地址[^4](注：对于windows用户，建议下载.exe格式安装程序，可免除后续一些设置) 

默认安装路径：
``C:\Users\用户名\AppData\Local\Android\android-sdk``

建议改为成其他路径，方便日后系统参数设置操作  
``C:\Users\用户名\Android\Android-sdk ``


* 利用SDK Manager下载其他必要的库。    
维持默认选取Tools里的三个工具，以及Extra里的两个选项：Android Support Library 以及Google USB Driver(驱动 Linux下可不选)。单击（安装）进行安装。

* 环境变量设置    
在 .bashrc文件或PATH变量中添加ANDROID_HOME，值设置成安装路径。接着再添加两项路径设置如下:(注：ANDROID_HOME可自定义 ANDROID_SDK_ROOT亦可)

``%ANDROID_HOME%\tools``

``%ANDROID_HOME%\plarform-tools``


### 安装Cordova工具和Ant 
Cordova工具通过npm安装。[^5](注：尽量选取稍旧版本安装，如果对自己的电脑和操作系统很自信可选最新版安装)

``npm update -g cordova        (升级已安装软体为最新)``

``npm uninstall -g cordova     (卸载当前软体)``

``npm install -g cordova@*.0.0 (安装*.0.0版本软体)``

#### 安装Ant
Ubuntu安装[^6]

### 使用Cordova创建手机App
Cordova工具可帮助创建一个基本App。在创建之前，需要先添加一个保存App的文件建夹。（ordova）

``$cordova create cordova``
该目录下包含：config.xml、package.json两个文件和一个www目录。

#### 添加Android平台

``cd cordova``

``cordova platform add android``


增加了node_modules和platforms、plugins三个目录
#### 编译Android App与安装SDK平台

``$cordova build android``

编译过程中可能提示缺少相应的android开发工具，使用sdkmanager安装相应的Android系统平台文件（如：android-22等）SDK下载完毕后，再次运行“cordova build android”命令就编译成功了。

### 启用Android手机的USB Debug功能
Cordova项目创建完成后，可直接上传到android手机测试。步骤如下：
- 在相应的Android手机设置项的“开发者选项”设置勾选“USB调试” 选项。
- 将手机通过USB线连接到电脑，然后在命令提示符输入如下命令，列举目前连接道电脑上的Android设备。初次连接，系统可能会提示“未授权”

``$adb devices``

adb[^7]就是android设备调试器。
- 若系统回应unauthorized,请进入设置项“开发者选项”，按一下“撤回USB除错授权”选项。
- 运行如下两个命令，重新启动adb服务器。

``$adb kill-server``

``$adb start-server``
- 此时手机将出现询问连接。
- 单击确定后，再次运行如下命令，手机与电脑将连接成功。

``adb devices``

#### 将App部署到目前连接的手机上测试

``cordova run android --device``

## 一个实例
手机APP 控制aruino uno 点亮熄灭led灯 
通过电脑USB配对蓝牙[^8]或者通过arduino配置蓝牙[^9](注：具体参数依据个人)

[^C]:[cordova官方](https://cordova.apache.org/#getstarted)
[^1]:[ubuntu安装JDK](https://www.leftso.com/blog/1009.html#:~:text=Ubuntu%2020.04%20%E5%AE%89%E8%A3%85jdk8%20%E5%A4%8D%E5%88%B6%20sudo,apt-get%20install%20openjdk-%208%20-jdk)
[^2]:[win7安装JDK和Android SDK](https://blog.csdn.net/xiaoyu_wu/article/details/102654343)
[^3]:[Xubuntu安装 Android SDK](https://blog.csdn.net/qq_25017839/article/details/89847824)
[^4]:[Android SDK下载地址](https://www.cnblogs.com/auguse/p/13807169.html)
[^5]:[Cordova](https://cordova.apache.org/#getstarted)
[^6]:[Ubuntu安装Ant](https://www.yundongfang.com/Yun40649.html#:~:text=%E5%9C%A8%20Ubuntu%2020.04%20LTS%20Focal%20Fossa%E4%B8%8A%20%E5%AE%89%E8%A3%85Apache,Ant%20%E6%AD%A5%E9%AA%A41.%E9%A6%96%E5%85%88%EF%BC%8C%E9%80%9A%E8%BF%87apt%E5%9C%A8%E7%BB%88%E7%AB%AF%E4%B8%AD%E8%BF%90%E8%A1%8C%E4%BB%A5%E4%B8%8B%E4%BB%A5%E4%B8%8B%E5%91%BD%E4%BB%A4%EF%BC%8C%E7%A1%AE%E4%BF%9D%E6%89%80%E6%9C%89%E7%B3%BB%E7%BB%9F%E8%BD%AF%E4%BB%B6%E5%8C%85%E9%83%BD%E6%98%AF%E6%9C%80%E6%96%B0%E7%9A%84%E3%80%82%20sudo%20apt%20update%20sudo%20apt%20upgrade)

[^7]:[adb](https://developer.android.google.cn/studio/command-line/adb?hl=zh-cn)
[^8]:[电脑蓝牙配对](https://blog.csdn.net/SH_LYPTK/article/details/108916676)
[^9]:[arduino设置蓝牙](https://github.com/rwaldron/johnny-five/wiki/Getting-Started-with-Johnny-Five-and-HC-05-Bluetooth-Serial-Port-Module)