---
layout: post
title:  "johnny-five前端控制入门"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
    - 智能车
---

# Linux环境下Johnny-Five前端控制框架

在Linux环境下构建一个前端控制框架来操作Johnny-Five硬件，可以通过多种方式实现。下面我将提供一个完整的解决方案，使用Web技术栈创建一个直观的硬件控制界面。

## 方案概述

我将使用以下技术栈：
- **后端**: Node.js + Express + Johnny-Five
- **前端**: HTML5 + CSS3 + JavaScript (Vanilla JS，但可轻松适配React/Vue)
- **通信**: WebSocket (Socket.IO) 实现实时双向通信
- **UI**: 响应式设计，兼容桌面和移动设备

## 项目结构

```
johnny-five-web-control/
├── server.js              # Node.js后端服务器
├── package.json           # 项目依赖
├── public/                # 静态文件
│   ├── index.html         # 主页面
│   ├── css/
│   │   └── style.css      # 样式文件
│   └── js/
│       └── app.js         # 前端逻辑
└── README.md
```

## 实现步骤

### 1. 环境准备

```bash
# 创建项目目录
mkdir johnny-five-web-control
cd johnny-five-web-control

# 初始化npm项目
npm init -y

# 安装依赖
npm install express socket.io johnny-five serialport
```

### 2. 后端服务器 (server.js)

```javascript
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const five = require('johnny-five');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// 提供静态文件
app.use(express.static('public'));

// Arduino连接
let board = new five.Board({
  port: '/dev/ttyACM0', // 根据实际情况修改
  repl: false
});

let led = null;
let servo = null;

board.on('ready', () => {
  console.log('Arduino连接成功!');
  
  // 初始化组件
  led = new five.Led(13);
  servo = new five.Servo(9);
  
  // 监听WebSocket连接
  io.on('connection', (socket) => {
    console.log('客户端连接');
    
    // 处理LED控制
    socket.on('led-control', (data) => {
      if (data.state === 'on') {
        led.on();
      } else if (data.state === 'off') {
        led.off();
      } else if (data.state === 'blink') {
        led.blink(500);
      }
      io.emit('led-status', {state: data.state});
    });
    
    // 处理舵机控制
    socket.on('servo-control', (data) => {
      servo.to(data.angle);
      io.emit('servo-status', {angle: data.angle});
    });
    
    // 断开连接
    socket.on('disconnect', () => {
      console.log('客户端断开连接');
    });
  });
});

board.on('error', (err) => {
  console.log('Arduino连接错误:', err);
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`服务器运行在 http://localhost:${PORT}`);
});
```

### 3. 前端界面 (public/index.html)

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Johnny-Five硬件控制面板</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>硬件控制面板</h1>
            <p id="connection-status">连接状态: 等待连接...</p>
        </header>
        
        <div class="control-section">
            <h2>LED控制</h2>
            <div class="button-group">
                <button id="led-on" class="btn btn-success">打开LED</button>
                <button id="led-off" class="btn btn-danger">关闭LED</button>
                <button id="led-blink" class="btn btn-warning">闪烁LED</button>
            </div>
            <div class="status">
                <p>LED状态: <span id="led-status">未知</span></p>
            </div>
        </div>
        
        <div class="control-section">
            <h2>舵机控制</h2>
            <div class="slider-container">
                <input type="range" id="servo-slider" min="0" max="180" value="90" class="slider">
                <span id="servo-value">90°</span>
            </div>
            <div class="status">
                <p>舵机角度: <span id="servo-status">90°</span></p>
            </div>
        </div>
    </div>

    <script src="/socket.io/socket.io.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
```

### 4. 样式设计 (public/css/style.css)

```css
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f4f4f4;
    padding: 20px;
}

.container {
    max-width: 800px;
    margin: 0 auto;
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

header {
    text-align: center;
    margin-bottom: 30px;
}

.control-section {
    margin-bottom: 30px;
    padding: 20px;
    border: 1px solid #e1e1e1;
    border-radius: 5px;
}

.button-group {
    display: flex;
    gap: 10px;
    margin: 15px 0;
    flex-wrap: wrap;
}

.btn {
    padding: 10px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.3s;
}

.btn-success {
    background-color: #28a745;
    color: white;
}

.btn-danger {
    background-color: #dc3545;
    color: white;
}

.btn-warning {
    background-color: #ffc107;
    color: black;
}

.btn:hover {
    opacity: 0.9;
}

.slider-container {
    display: flex;
    align-items: center;
    gap: 15px;
    margin: 15px 0;
}

.slider {
    flex: 1;
    height: 10px;
}

.status {
    margin-top: 15px;
    padding: 10px;
    background-color: #f8f9fa;
    border-radius: 4px;
}

#connection-status {
    font-weight: bold;
    color: #6c757d;
}

.connected {
    color: #28a745 !important;
}

.disconnected {
    color: #dc3545 !important;
}

@media (max-width: 600px) {
    .button-group {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
    }
}
```

### 5. 前端逻辑 (public/js/app.js)

```javascript
// 建立Socket连接
const socket = io();

// 连接状态指示
const connectionStatus = document.getElementById('connection-status');

// 更新连接状态
socket.on('connect', () => {
    console.log('已连接到服务器');
    connectionStatus.textContent = '连接状态: 已连接';
    connectionStatus.classList.add('connected');
    connectionStatus.classList.remove('disconnected');
});

socket.on('disconnect', () => {
    console.log('与服务器断开连接');
    connectionStatus.textContent = '连接状态: 断开连接';
    connectionStatus.classList.remove('connected');
    connectionStatus.classList.add('disconnected');
});

// LED控制
const ledOnBtn = document.getElementById('led-on');
const ledOffBtn = document.getElementById('led-off');
const ledBlinkBtn = document.getElementById('led-blink');
const ledStatus = document.getElementById('led-status');

ledOnBtn.addEventListener('click', () => {
    socket.emit('led-control', {state: 'on'});
});

ledOffBtn.addEventListener('click', () => {
    socket.emit('led-control', {state: 'off'});
});

ledBlinkBtn.addEventListener('click', () => {
    socket.emit('led-control', {state: 'blink'});
});

// 更新LED状态
socket.on('led-status', (data) => {
    ledStatus.textContent = data.state === 'on' ? '开启' : 
                           data.state === 'off' ? '关闭' : '闪烁';
});

// 舵机控制
const servoSlider = document.getElementById('servo-slider');
const servoValue = document.getElementById('servo-value');
const servoStatus = document.getElementById('servo-status');

servoSlider.addEventListener('input', () => {
    const angle = servoSlider.value;
    servoValue.textContent = `${angle}°`;
    socket.emit('servo-control', {angle: parseInt(angle)});
});

// 更新舵机状态
socket.on('servo-status', (data) => {
    servoStatus.textContent = `${data.angle}°`;
    servoSlider.value = data.angle;
    servoValue.textContent = `${data.angle}°`;
});

// 初始化页面
document.addEventListener('DOMContentLoaded', () => {
    console.log('控制面板已加载');
});
```

## 使用说明

1. **硬件准备**:
   - 将Arduino连接到Linux计算机
   - 确保已上传StandardFirmata固件
   - 确认Arduino设备路径（通常是`/dev/ttyACM0`或`/dev/ttyUSB0`）

2. **启动应用**:
   ```bash
   # 确保已安装所有依赖
   npm install
   
   # 启动服务器
   node server.js
   ```

3. **访问控制界面**:
   - 打开浏览器访问 `http://localhost:3000`
   - 确保浏览器和设备在同一网络下（如果是远程访问）

4. **控制硬件**:
   - 使用按钮控制LED的开关和闪烁
   - 使用滑块控制舵机角度




## 扩展功能

这个基础框架可以轻松扩展以支持更多硬件组件：

1. **添加传感器数据显示**:
   ```javascript
   // 后端
   const temperature = new five.Thermometer({
     controller: "LM35",
     pin: "A0"
   });
   
   temperature.on("change", () => {
     io.emit('temperature-data', {celsius: temperature.celsius});
   });
   
   // 前端
   socket.on('temperature-data', (data) => {
     document.getElementById('temperature').textContent = `${data.celsius}°C`;
   });
   ```

2. **添加更多执行器控制**:
   - 电机控制
   - 继电器控制
   - RGB LED控制

3. **添加用户认证**:
   - 简单的登录系统
   - 控制权限管理

4. **数据记录**:
   - 记录硬件状态变化
   - 生成使用报告

## 故障排除

1. **串口权限问题**:
   ```bash
   sudo usermod -a -G dialout $USER
   # 然后重新登录
   ```

2. **端口占用**:
   - 修改server.js中的PORT变量

3. **Arduino未识别**:
   - 检查设备连接
   - 确认设备路径

这个框架提供了一个完整的起点，您可以根据具体需求进行定制和扩展。它结合了现代Web技术和硬件控制，创建了一个直观的用户界面来控制Johnny-Five硬件。