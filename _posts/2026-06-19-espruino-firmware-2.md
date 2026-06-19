---
layout: post
title: "STM32F401CCU6 固件开发流程解析 —— 以 Espruino 项目为例"
author: "David"
header-style: text
tags: 
    - STM32
    - 嵌入式
---

STM32F401CCU6 是 ST 微控制器系列中性价比较高的 Cortex-M4F 器件，而 Espruino 项目在此基础上实现了完整的 JavaScript 解释器固件。以下从芯片特性、构建系统、板级定义、烧录方式等几个层面展开。

## 芯片概览

STM32F401CCU6 的核心参数：

| 参数 | 值 |
|------|-----|
| 内核 | ARM Cortex-M4F（单精度 FPU） |
| 主频 | 84 MHz（HSE 25MHz 晶振） |
| Flash | 256 KB |
| SRAM | 64 KB |
| 封装 | UQFN48（6x6 mm） |
| USB | OTG FS（全速） |
| 串行外设 | 3x USART, 3x SPI, 3x I2C, 1x ADC |

该芯片没有 DAC，也没有 CAN 控制器，适用于低成本、小封装的嵌入式 JavaScript 应用场景。对比同系列的 STM32F401CDU6（384KB Flash），CC 版本砍掉了 128KB 存储，但保留了完整的外设集和 FPU。

## 构建系统架构

Espruino 的构建系统以 **GNU Make** 为核心，配合 **Python 代码生成脚本** 和 **ARM GCC 工具链**，实现从板级定义到最终二进制的一站式产出。

### 基础命令

```bash
# 普通构建（含断言）
BOARD=STM32F401CCU6 make

# Release 构建（移除断言，减小体积）
RELEASE=1 BOARD=STM32F401CCU6 make

# 烧录
BOARD=STM32F401CCU6 make flash
BOARD=STM32F401CCU6 make serialflash
```

`make` 自动利用多核编译（`-j$(nproc)`），且支持 `DEBUG=1` 加入 GDB 调试符号、`SINGLETHREAD=1` 单线程编译以便定位错误。

### 构建流水线

完整的构建流程可分为 **代码生成 -> 编译 -> 链接 -> 后处理** 四个阶段：

```
board definition (.py)
        |
        |-- scripts/get_makefile_decls.py       ->  Makefile 宏定义
        |-- scripts/build_platform_config.py    ->  gen/platform_config.h
        |-- scripts/build_pininfo.py            ->  gen/jspininfo.c（引脚定义表）
        |-- scripts/build_jswrapper.py          ->  gen/jswrapper.c（JS 符号表）
        |-- scripts/build_linker.py             ->  gen/linker.ld（链接脚本）
        |
        v
ARM GCC 编译（.c -> .o）
        |
        v
LTO 链接（.o -> .elf）
        |
        v
objdump 转换
   |-- .bin（STM32 烧录）
   |-- .hex（mbed 等平台）
   |-- .lst（汇编清单，调试用）
        |
        v
scripts/check_size.sh -> 校验二进制是否超出 Flash 容量
```

## 板级定义文件

`boards/STM32F401CCU6.py` 是整个构建的"唯一真相来源"。

### Flash 分区布局

STM32F401CC 的 256KB Flash 按 Pico 风格划分为：

```
地址范围                   用途        大小
0x08000000 - 0x0800BFFF   saved_code  48 KB  (3 x 16KB 页)
0x0800C000 - 0x0803FFFF   binary      208 KB
```

`saved_code` 用于保存用户 JavaScript 代码（断电保持），`binary` 区域存放固件本身。这种布局意味着编译器链接时 `FLASH_BASE` 偏移到 `0x0800C000`，而启动文件需要正确处理向量表重定位。

### Chip 定义关键字段

```python
chip = {
  'part' : "STM32F401CCU6",        # 传递给 GCC 的 -D 宏
  'family' : "STM32F4",            # 决定使用 make/family/STM32F4.make
  'package' : "UQFN48",            # 配合 CSV 过滤出该封装的引脚
  'ram' : 64,
  'flash' : 256,
  'speed' : 84,
  'saved_code' : {
    'address' : 0x0803C000,
    'page_size' : 16384,
    'pages' : 1,
    'flash_available' : 256-16,    # 固件大小限制检查
  },
}
```

`flash_base` 声明为 `0x08000000`（STM32 Flash 的物理地址），但在没有 bootloader 的情况下链接器会使用 `0x00000000` 别名空间以获得更快的取指速度。

### Build 选项

```python
'build' : {
  'optimizeflags' : '-Os',
  'makefile' : [
    'SAVE_ON_FLASH=1',
    'DEFINES+=-DUSE_USB_OTG_FS=1',
    'DEFINES+=-DHSE_VALUE=25000000 -DPLL_M=25',
    'DEFINES+=-DPIN_NAMES_DIRECT=1',
    'DEFINES+=-DESPR_LIMIT_DATE_RANGE',
    'STLIB=STM32F401xC',
  ]
}
```

`SAVE_ON_FLASH` 是 Espruino 中最重要的体积控制开关——它会关闭 Promise、let 作用域、getter/setter、密码保护、预分词等特性，并为数学库启用瘦身版本。对于 256KB Flash 的芯片这是必要的取舍。

### 引脚定义

引脚信息来自 `boards/pins/stm32f401.csv`（直接从 ST 数据手册提取），然后通过 `pinutils.scan_pin_file()` 解析、`pinutils.only_from_package("UQFN48")` 过滤出 48 脚封装可用的引脚，再通过 `scan_pin_af_file()` 补充 Alternate Function 映射。

最终生成的 `gen/jspininfo.c` 中每个引脚结构体包含：

- **name** — 如 `PA0`
- **sortingname** — 补零后的排序名
- **port / num** — 端口和引脚号
- **functions** — Alternate Function 映射表，例如 `{ "SPI1_SCK": 5, "USART2_CTS": 7 }`

## STM32F4 架构的 Makefile 体系

### 架构标志

`make/family/STM32F4.make` 定义核心编译参数：

```makefile
ARCHFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 \
             -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
```

注意这里使用 **softfp** ABI 而非 hard-float——因为 Espruino 内部全部使用 `double`（64位），FPv4-SP-D16 只能加速 32 位 float，对 double 无帮助，反而增加代码体积。这是一个务实的工程决策。

### 标准外设库

`TARGETSOURCES` 显式列出要用到的 STM32F4 标准外设库源文件（`stm32f4xx_adc.c`、`stm32f4xx_flash.c`、`stm32f4xx_usart.c` 等 18 个模块），未启用的外设（CAN、DCMI、RNG、SAI 等）则不编译，避免浪费 Flash。

### USB 堆栈

当启用 `USE_USB_OTG_FS` 时，`make/common/STM32_USB.make` 会引入 STM32Cube LL（Low Layer）USB 驱动和 CDC 虚拟串口实现。这三层分别是：

- `stm32f4xx_ll_usb.c` — 寄存器级 USB 操作
- `stm32f4xx_hal_pcd.c` — 外设控制器驱动
- `usbd_cdc_hid.c` — CDC/HID 类实现

### 链接脚本生成

`scripts/build_linker.py` 自动生成链接脚本。它从 board 定义中读取 `flash_base`、`flash`、`ram`、`saved_code`，再根据有无 bootloader 计算实际 Flash 基址和长度。

对于 STM32F401CCU6（不使用 bootloader），生成的链接脚本关键段：

```ld
MEMORY
{
  FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 256K
  RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 64K
}

_estack = 0x20010000;
```

异常向量表要求 0x200 字节对齐（STM32 硬件要求），`.isr_vector` 段放在最前面。`libc.a`、`libm.a`、`libgcc.a` 在 `/DISCARD/` 中被丢弃——因为 Espruino 自行实现了 `strcpy`、`memcpy`、`memset`，并使用了自定义的数学库（避免拉入 malloc）。

## 烧录方式

### ST-Link 烧录（`make flash`）

```makefile
flash:
    st-flash --reset write $(PROJ_NAME).bin $(BASEADDRESS)
```

缺省使用 `st-flash`（来自开源工具链），连接 SWD 接口写入。如果连接失败会自动降级到 J-Link：

```makefile
JLinkExe -device $(CHIP) -if SWD -speed 4000 -CommandFile JLinkCommands.txt
```

### 串行 Bootloader 烧录（`make serialflash`）

STM32 出厂内置的系统 bootloader（设置在 BOOT0=1、BOOT1=0 时进入），通过 `scripts/stm32loader.py` 脚本经 USART1（PA9/PA10）以 460800 baud 写入：

```bash
python2.7 scripts/stm32loader.py -b 460800 -a $(BASEADDRESS) -ew $(PROJ_NAME).bin
```

`-e` 擦除、`-w` 写入。这是在没有调试器时唯一的烧录途径。

## JSWrapper 机制（JS 函数导出）

Espruino 的亮点之一：在 C 源码中用带 JSON 注释的方式声明 JavaScript API。

```c
/*JSON{
  "type" : "staticmethod",
  "class" : "Hello",
  "name" : "world",
  "generate" : "jswrap_hello_world"
}*/
void jswrap_hello_world() {
    jsiConsolePrint("Hello World!\r\n");
}
```

构建时 `scripts/build_jswrapper.py` 扫描所有 `jswrap_*` 源文件，提取 JSON 头，生成 `gen/jswrapper.c`——一个硬编码的符号表，存放在 Flash 中，解释器通过该表完成 JS 函数名到 C 函数指针的查找。

该脚本还需感知编译器宏定义：当 `SAVE_ON_FLASH` 启用时，对应模块的符号会被排除，避免链接时出现未定义引用。

## 技术要点总结

1. **多阶段代码生成** — Python 脚本在编译前生成 platform_config、pin table、symbol table、linker script，将板级配置与 C 代码解耦。

2. **体积优化的极端手段** — `-Os` + LTO + SAVE_ON_FLASH 系列宏 + 自定义 libc 函数 + 数学库替换，让一个完整的 JS 解释器塞进 208KB 固件空间。

3. **Flash 分区设计** — saved_code 与固件同在一个 Flash，但通过分区地址隔离，无需外部 EEPROM/SPI Flash 即可持久化用户代码。

4. **封装感知的引脚配置** — 同一颗芯片的不同封装（UQFN48 vs LQFP64）通过 CSV 列掩码 + Python 过滤，自动生成正确的引脚表。

5. **工具链无关的烧录** — 同时支持 ST-Link、J-Link、串行 bootloader、DFU 四种方式，适配从原型开发到量产的不同阶段。

## 相关文件索引

| 文件 | 说明 |
|------|------|
| `boards/STM32F401CCU6.py` | 板级定义 |
| `README_BuildProcess.md` | 构建流程文档 |
| `make/family/STM32F4.make` | STM32F4 架构 Makefile |
| `make/common/STM32.make` | STM32 公共 Makefile |
| `make/common/STM32_USB.make` | USB 堆栈 Makefile |
| `scripts/build_linker.py` | 链接脚本生成器 |
| `scripts/build_platform_config.py` | 平台配置生成器 |
| `scripts/build_pininfo.py` | 引脚表生成器 |
| `scripts/build_jswrapper.py` | JS 符号表生成器 |
| `boards/pins/stm32f401.csv` | 原始引脚数据（来自 ST 数据手册） |
