---
layout: post
title:  "Espruino固件开发实战"
author: "David"
header-style: text
tags: 
    - STM32
    - 嵌入式
---

## 前言

Espruino 是一个开源的 JavaScript 解释器，专为微控制器设计。它允许开发者用 JavaScript 而非 C/C++ 来编写嵌入式程序，大幅降低了嵌入式开发的门槛。本文以 STM32F401CCU6 (Black Pill 开发板) 为例，详细讲解如何配置、编译和定制 Espruino 固件。

## Espruino 项目结构

克隆 Espruino 源码后，主要目录结构如下：

```
.
├── Makefile                    # 主构建文件
├── boards/                     # 开发板配置文件 (*.py)
│   ├── BLACKPILL_F401CCU6.py   # STM32F401CCU6 Black Pill
│   ├── PICO_R1_3.py           # Espruino Pico
│   ├── NUCLEOF401RE.py        # STM32 Nucleo-F401RE
│   └── pins/                   # GPIO引脚定义CSV文件
│       ├── stm32f401.csv
│       └── stm32f401_af.csv
├── src/                        # Espruino核心源码（C语言）
├── libs/                       # 功能库
│   ├── filesystem/             # 文件系统（FatFs）
│   ├── graphics/               # 图形库
│   └── network/                # 网络库
├── scripts/                    # Python构建脚本
│   ├── build_platform_config.py # 生成平台配置
│   ├── build_linker.py         # 生成链接脚本
│   └── build_jswrapper.py      # 生成JS函数绑定
├── targets/                    # 芯片平台层
│   └── stm32/                  # STM32F4 平台代码
├── targetlibs/                 # 厂商库 (STM32 HAL等)
│   └── stm32f4/lib/
└── make/                       # Makefile包含文件
    ├── common/
    │   ├── ARM.make            # ARM通用构建规则
    │   └── STM32.make          # STM32特定构建规则
    └── targets/
        └── ARM.make            # ARM编译输出规则
```

## 核心概念：Board 配置文件

每个开发板的配置是一个 Python 文件（`boards/<BOARD_NAME>.py`），包含三大部分：

### 1. `info` — 构建信息

```python
info = {
    'name': "Black Pill F401CCU6",
    'default_console': "EV_SERIAL1",     # 默认控制台（USB串口）
    'default_console_tx': "A9",          # 串口TX引脚
    'default_console_rx': "A10",         # 串口RX引脚
    'variables': 500,                    # JS变量数（直接影响RAM占用）
    'bootloader': 0,                     # 是否有独立bootloader
    'binary_name': 'espruino_%v_blackpill_f401ccu6.bin',
    'build': {
        'optimizeflags': '-Os',          # 优化选项（-Os=代码体积优化）
        'libraries': [                   # 启用的功能库
            'USB_HID',
        ],
        'makefile': [                    # 额外编译选项
            'DEFINES+=-DUSE_USB_OTG_FS=1',
            'DEFINES+=-DSTM32F401xC',
            'STLIB=STM32F401xC',
            'PRECOMPILED_OBJS+=$(ROOT)/targetlibs/stm32f4/lib/startup_stm32f401xx.o'
        ]
    }
}
```

### 2. `chip` — 芯片信息

```python
chip = {
    'part': "STM32F401CCU6",
    'family': "STM32F4",
    'package': "UQFN48",
    'ram': 64,           # 64KB RAM
    'flash': 256,        # 256KB Flash
    'speed': 84,         # 84MHz主频
    'usart': 3, 'spi': 3, 'i2c': 3,
    'adc': 1, 'dac': 0,
    'saved_code': {
        'address': 0x08004000,
        'page_size': 16384,
        'pages': 0,
        'flash_available': 256   # 固件可用Flash大小（KB）
    }
}
```

### 3. `devices` 和 `board` — 板级外设定义

```python
devices = {
    'LED1': {'pin': 'C13'},
    'BTN1': {'pin': 'A0', 'pinstate': 'IN_PULLUP'},
    'USB': {'pin_dm': 'A11', 'pin_dp': 'A12'},
}
board = {
    'top': ['3.3V', 'PB12', 'PB13', ...],
    'bottom': ['GND', 'VBAT', 'PC13', ...],
}
```

## 构建流程

### 环境要求

- ARM GCC 交叉编译工具链 (`arm-none-eabi-`)
- Python 3
- GNU Make

### 构建命令

```bash
# 清理之前的编译产物
make clean

# 编译指定开发板的固件
BOARD=BLACKPILL_F401CCU6 make
```

编译成功后，生成的 `.bin` 文件位于 `bin/` 目录下。构建系统会自动执行 `scripts/check_size.sh` 检查固件大小是否不超过芯片的 Flash 容量。

### 构建过程详解

执行 `make` 后，构建系统依次执行：

1. **生成平台配置** — `build_platform_config.py` 解析 board `.py` 文件，生成 `gen/platform_config.h`
2. **生成引脚信息** — 解析 pins CSV 文件，生成引脚映射表
3. **生成 JS 函数绑定** — `build_jswrapper.py` 扫描所有 `jswrap_*.c` 文件，生成 JS 函数与 C 函数的映射表
4. **编译源码** — 编译 Espruino 内核、平台代码和功能库
5. **链接** — 使用 `build_linker.py` 生成的自定义链接脚本链接所有目标文件
6. **生成二进制** — 生成 `.bin` 和 `.lst`（反汇编列表）文件
7. **大小检查** — 验证固件不超过 Flash 容量

## Flash 空间优化

STM32F401CCU6 仅有 256KB Flash，而 Espruino 固件很容易接近这个上限。以下是常用的优化手段：

### 1. 代码体积优化标志 (`SAVE_ON_FLASH`)

```python
'DEFINES+=-DSAVE_ON_FLASH',
```

这个宏会启用一系列 JavaScript 语言特性的裁剪，禁用不常用的高级语法以节省代码空间：

| 宏定义 | 作用 | 节省空间 |
|--------|------|----------|
| `SAVE_ON_FLASH` | 启用整体代码体积优化模式 | 约 80KB+ |
| `SAVE_ON_FLASH_MATH` | 使用精简版数学函数（sin/atan） | 约 5-8KB |
| `ESPR_PACKED_SYMPTR` | 将符号偏移量压缩到函数指针中 | 约 2KB |
| `ESPR_LIMIT_DATE_RANGE` | 限制 Date 对象年份范围 | 约 1KB |
| `ESPR_NO_REGEX_OPTIMISE` | 禁用正则表达式优化 | 约 2KB |

### 2. `SAVE_ON_FLASH` 自动禁用的特性

```c
// src/jsutils.h
#ifdef SAVE_ON_FLASH
#define ESPR_NO_OBJECT_METHODS      1    // 禁止对象方法语法糖
#define ESPR_NO_PROPERTY_SHORTHAND  1    // 禁止属性简写
#define ESPR_NO_GET_SET            1     // 禁止 getter/setter
#define ESPR_NO_LET_SCOPING         1    // 禁止 let 块级作用域
#define ESPR_NO_PROMISES            1    // 禁止 Promise
#define ESPR_NO_CLASSES             1    // 禁止 class 语法
#define ESPR_NO_ARROW_FN            1    // 禁止箭头函数
#define ESPR_NO_REGEX               1    // 禁止正则表达式
#define ESPR_NO_TEMPLATE_LITERAL    1    // 禁止模板字符串
#endif
```

### 3. 启用/禁用功能库

`libraries` 列表中的每个库会增加固件体积：

| 库 | 功能 | 增加体积 |
|----|------|----------|
| `USB_HID` | USB HID（键盘/鼠标模拟） | ~1KB |
| `GRAPHICS` | 图形库 | ~8-12KB |
| `FILESYSTEM` | 文件系统（FatFs） | ~18KB |
| `NET` | TCP/IP 网络 | ~15-25KB |
| `TLS` | TLS 加密 | ~20-30KB |
| `NEOPIXEL` | WS2812 灯带控制 | ~3KB |

## 案例分析：添加 FILESYSTEM 支持

在 Black Pill F401CCU6 (256KB Flash) 上添加文件系统支持的尝试，是一个典型的嵌入式固件开发案例。

### 分析过程

1. **基线测量**：编译原始固件，得到大小 256,072 字节（剩余 6KB）
2. **添加 FILESYSTEM**：在 `libraries` 中添加 `'FILESYSTEM'` 后，固件超出 256KB 限制 12,900 字节
3. **Flash 溢出原因**：
   - FatFs 文件系统库：~12KB
   - JS 文件操作 API：~3KB
   - `jsvDefragment` 内存整理函数：~0.5KB
   - 其他关联代码：~3KB
4. **解决途径**：
   - 升级到更大 Flash 芯片（如 STM32F401CEU6，512KB）
   - 裁剪更多功能模块
   - 使用 `E.save()` 替代完整的 FatFs 文件系统

### 关键发现：`jswrap_file.c` 依赖 `jsvDefragment`

```c
// libs/filesystem/jswrap_file.c
if (!file->dataVar) { // 内存分配失败
    jsvDefragment();  // 整理内存碎片后重试
    file->dataVar = jsvNewFlatStringOfLength(sizeof(JsFileData));
}
```

而 `jsvDefragment` 函数在 `SAVE_ON_FLASH` 模式下会被排除编译：

```c
// src/jsvar.c
#ifndef SAVE_ON_FLASH
void jsvDefragment() { /* ... */ }
#endif
```

因此，启用 FILESYSTEM 时需要修改此处条件，让 `jsvDefragment` 在 `USE_FILESYSTEM` 下也编译：

```c
#if !defined(SAVE_ON_FLASH) || defined(USE_FILESYSTEM)
void jsvDefragment() { /* ... */ }
#endif
```

## 实践建议

### 1. 选择合适的芯片

| 芯片型号 | Flash | RAM | 封装 | 适用场景 |
|----------|-------|-----|------|----------|
| STM32F401CCU6 | 256KB | 64KB | UQFN48 | 基础项目，可少量定制 |
| STM32F401CEU6 | 512KB | 96KB | UQFN48 | 需FILESYSTEM/网络功能 |
| STM32F411CEU6 | 512KB | 128KB | UQFN48 | 高运算需求（100MHz） |

### 2. 定义多个固件变体

参考 Espruino Pico 的多固件方案：

```python
'binaries': [
    { 'filename': 'espruino_%v_pico_full.bin', 
      'description': "全部功能" },
    { 'filename': 'espruino_%v_pico_wiznet.bin', 
      'description': "WIZNet以太网（无调试器）"},
]
```

可以通过不同配置编译出适合不同场景的固件。

### 3. 使用 `make serialflash` 烧录

对于 STM32 芯片，编译完成后可直接烧录：

```bash
BOARD=BLACKPILL_F401CCU6 make serialflash
```

### 4. 调试技巧

- 使用 `make lst` 生成反汇编列表，排查固件大小
- 使用 `BOARD=xxx make varsonly` 查看构建变量
- 使用 `RELEASE=1` 编译发行版（移除断言）

## 总结

Espruino 的构建系统设计精良，通过 Python 配置文件 + Makefile 的组合，让开发者能够灵活地定制固件功能。对于 STM32 平台，关键因素是 Flash 空间的精确管理：每个功能库、每个编译选项都会影响最终的固件体积。

理解 Board 配置文件的三个核心部分（构建信息、芯片信息、板级外设），掌握 Flash 优化技巧，就能为各种 STM32 开发板定制自己专属的 Espruino 固件。

完整的示例代码和配置文件可在 [GitHub](https://github.com/espruino/Espruino) 获取。
