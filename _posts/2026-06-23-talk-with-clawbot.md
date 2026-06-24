---
layout: post
title: "和麻小聊天"
author: "David"
header-style: text
tags: 
    - 笔记
    - AI
---


Codex 没有官方“个人微信插件”，目前都是社区桥接方案，核心是两种：官方安全的 **微信 ClawBot + codex-wechat-channel**，以及有风控的第三方扫码桥接（codex-wechat / CodexBridge）。推荐走 ClawBot，步骤如下。

## 前置准备
- Linux 下装好 **Node.js ≥ 22**（含 npm/npx），已装 Codex CLI 并用 `codex auth` 登过 OpenAI 账号，确保 `~/.codex/auth.json` 存在。
- 手机微信升级到 **iOS 8.0.70+ / 安卓最新版**，在 我 → 设置 → 插件 里启用官方 **ClawBot**（灰度中，没有就等更新）。

## 安装并配置 codex-wechat-channel（ClawBot 桥接，推荐）
这是社区 npm 包，把 ClawBot 消息转成本地 Codex app-server 线程，纯文本/图片都能过，官方协议零封号风险。

1. 安装（全局或 npx 都行）：
```bash
npm install -g codex-wechat-channel
codex-wechat-channel help
```
2. 微信扫码登录，绑定 ClawBot：
```bash
codex-wechat-channel setup
```
终端打印二维码 → 用手机微信扫 → 在微信里确认绑定 ClawBot。凭据存到 `~/.codex/channels/wechat/account.json`。
3. 启动桥接，可指定工作目录和模型：
```bash
codex-wechat-channel start --cwd /home/你的项目 --model gpt-5.4
```
后台常驻用 `codex-wechat-channel bridge start`，Linux systemd 可做开机自启。
4. 使用：手机微信联系人里会出现 **ClawBot**，直接发文字“帮我看看这个项目最近 git log”“新建一个 utils.py 写 md5”，Codex 在本机跑命令/改代码，纯文本回微信；发图片会当 localImage 传给 Codex 分析。

## 第三方扫码桥接（codex-wechat / CodexBridge，有风控）
不走 ClawBot，用微信扫码登录本地 bot，直接桥接 Codex CLI，适合 Linux 本地但属逆向/iLink 非官方，有封号可能。

- codex-wechat（参考实现）：`npm install` → 配 `.env`（工作目录、白名单微信 ID）→ `npm run login` 扫终端二维码 → `npm run start`，微信里用 `/codex bind /path` 绑定项目，之后发自然语言就是 Codex 任务。
- CodexBridge：让 Codex 自己跑“帮我对接个人微信”，它克隆项目、装依赖、生成二维码，扫完用 `/h /status` 测通，再发“帮我看 D:\project 最近改动”。

## 实操要点
- ClawBot 只能私聊你本人，不能加群、不能主动发消息，纯消息通道。
- Linux 服务器跑 bridge 要一直前台或 systemd 保活，休眠/断网 Codex 不回。
- 第三方扫码桥接务必在 `.env` 设 `ALLOWED_USER_IDS` 只允自己微信，防陌生人控你机器。
- Codex 内部插件 `/plugins` 没有微信项，这俩都是外部 npm 桥接，和 CLI/MCP 配置无关，装完直接终端启服务就行。