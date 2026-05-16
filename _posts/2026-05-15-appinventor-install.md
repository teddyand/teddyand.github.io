---
layout: post
title:  "appinventor安装指南"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
---


好的，我已经把你给出的 **两份资料（官方 README + Windows/Linux 构建指南）** 合并整理成一份 **干净的 Markdown 文档**，保留了 **标题层级、代码块、注意事项**，可以直接用于本地文档或 GitHub Pages / Obsidian。

---

# 在 Windows 和 Linux 上构建 MIT App Inventor（开源开发指南）

> 作者：Pradevel（2021‑04‑22）  
> 更新说明：适用于 MIT App Inventor 官方源码  
> 适用平台：**Windows / Linux**

---

## 一、准备说明

- 本指南适用于 **本地构建 MIT App Inventor**
- 如果你只是想使用 App Inventor，**不需要编译源码**
- 官方公共实例：https://appinventor.mit.edu

---

## 二、系统与环境要求

| 依赖 | 版本要求 |
|---|---|
| Java JDK | **Java 8 / 11（OpenJDK 推荐）** |
| Ant | **1.10+** |
| Google Cloud SDK | 含 App Engine Java 组件 |
| Git | 任意新版 |
| Node.js（测试用） | 20+（可选） |
| Firefox（测试用） | 最新版（可选） |

⚠️ **注意**  
- 仅 JRE **不够**，必须是 **JDK**
- Windows 下建议使用 **PowerShell / CMD**
- Git Bash 需要显式加 `.cmd` / `.sh`

---

## 三、Windows 构建指南

### 1️⃣ 安装 Java

- 下载并安装 **Java 8 JDK**
- 验证：
```powershell
java -version
```
应显示 **1.8.x**

---

### 2️⃣ 安装 Apache Ant

下载地址：
```
https://apachemirror.wuchna.com//ant/binaries/apache-ant-1.10.10-bin.zip
```

步骤：
1. 解压到如：`C:\apache-ant`
2. 配置环境变量：
   - `ANT_HOME` → `C:\apache-ant`
   - `PATH` → `%ANT_HOME%\bin`

验证：
```powershell
ant -version
```

---

### 3️⃣ 安装 Google Cloud SDK

在 **PowerShell** 中执行：

```powershell
(New-Object Net.WebClient).DownloadFile(
  "https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe",
  "$env:Temp\GoogleCloudSDKInstaller.exe"
)

& $env:Temp\GoogleCloudSDKInstaller.exe
```

完成后安装 **App Engine Java 组件**：
```powershell
gcloud components install app-engine-java
```

✅ 确保 `java_dev_appserver.cmd` 在 PATH 中：
```
C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin
```

---

### 4️⃣ 下载并初始化源码

```powershell
git clone https://github.com/mit-cml/appinventor-sources
cd appinventor-sources
git submodule update --init
```

---

### 5️⃣ 编译并运行

#### 生成 Auth Key
```powershell
cd AppInventor
ant MakeAuthKey
```

#### 编译主项目
```powershell
ant noplay
```

> `noplay` 会跳过 Companion（AiPlay）构建，可选

#### 启动主服务器
```powershell
java_dev_appserver.cmd --port=8888 --address=0.0.0.0 appengine/build/war/
```

#### 启动 Build Server（新终端）
```powershell
cd appinventor/buildserver
ant RunLocalBuildServer
```

✅ 访问：
```
http://localhost:8888
```

---

### 6️⃣ 常见 Windows 错误

#### ❌ BUILD FAILED（blockly-all.js 找不到）
```text
Warning: Could not find file ... blockly-all.js
```

✅ 解决方法：
- 将 `appinventor-sources` 加入杀毒软件白名单
- 重新执行：
```powershell
ant clean
ant noplay
```

---

## 四、Linux 构建指南（Ubuntu / Debian）

### 1️⃣ 安装依赖

```bash
sudo apt update
sudo apt install openjdk-8-jdk openjdk-8-doc openjdk-8-jre-lib
sudo apt install ant
sudo apt install google-cloud-sdk
sudo apt install google-cloud-sdk-app-engine-java
```

验证：
```bash
java -version
ant -version
```

---

### 2️⃣ 下载源码

```bash
git clone https://github.com/mit-cml/appinventor-sources
cd appinventor-sources
git submodule update --init
```

---

### 3️⃣ 编译并运行

```bash
cd AppInventor
ant MakeAuthKey
ant noplay
```

#### 启动主服务器
```bash
java_dev_appserver.sh --port=8888 --address=0.0.0.0 appengine/build/war/
```

#### 启动 Build Server（新终端）
```bash
cd appinventor/buildserver
ant RunLocalBuildServer
```

✅ 访问：
```
http://localhost:8888
```

---

## 五、常见问题 FAQ

### Q1：`java_dev_appserver` 命令未找到
✅ 确认 Google Cloud SDK 已加入 PATH  
✅ Windows 使用 `.cmd`，Linux 使用 `.sh`

---

### Q2：运行时端口被占用
```bash
netstat -ano | findstr 8888
```
或修改 `--port`

---

### Q3：Git Bash 无法运行命令
✅ 必须加后缀：
```bash
java_dev_appserver.cmd
java_dev_appserver.sh
```

---

## 六、补充说明（来自官方 README）

- 推荐使用 **Java 11（OpenJDK）**
- 如需修改源码，建议先在  
  👉 https://groups.google.com/g/app-inventor-open-source  
  讨论设计
- 自动化测试需要 **Node 20+、Firefox**
- iOS 构建仅支持 macOS（Xcode 14+）

---

## 七、参考链接

- GitHub 仓库  
  https://github.com/mit-cml/appinventor-sources
- 官方文档  
  https://appinventor.mit.edu/explore/open-source
- 设计文档建议：Google Docs（开放评论）

---

如果你需要，我可以再帮你：
- ✅ 拆成 **Windows.md / Linux.md**
- ✅ 改成 **Obsidian 双链格式**
- ✅ 做成 **中文技术博客**
- ✅ 精简成 **“10 分钟快速搭建版”**

你想下一步怎么用这份文档？ 😊