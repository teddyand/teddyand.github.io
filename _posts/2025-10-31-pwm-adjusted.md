---
layout: post
title:  "智能车车速PWM自适"
author: "David"
header-style: text
tags: 
    - stem教育
    - Maker
    - 智能车
mathjax: true    
---

# ESP8266(NODEMCU)智能车车速自适应

## 一、现象及解决思路
智能车运行中首先遇到的问题是当供电电池电量下降时，车速也会跟着下降，此时电机会发生堵转现象，即[esp8266智能车测速]({{site.url}}/2025/10/08/pwm-calib/)所说最小启动pwm不能支持车轮运转。这就需要动态调整pwm——电量越高车速越慢，电量越低车速越快，直到电压临界值时锁定小车pwm为零(不动)，这样小车在运行过程中始终保持一个（相对）恒定速度。


## 二、硬件实现
先对电池（电压）采样，然后采取查表法或动态调整法输出一个变化的pwm值。

### 采样分压电路设计（以 2S Li-ion 7.4V 为例）

假设电池电压范围：**6V ~ 8.4V（充满 ~ 放电）**

你想将这个范围映射到 ESP8266 A0 的 **0 ~ 1V**，那么可以这样设计分压：

#### ✅ 推荐分压电阻（举例）：

- R1 = 10kΩ
- R2 = 2.2kΩ
- 分压公式：  
\\(V_{ADC} = V_{bat} \times \frac{R2}{R1 + R2}\\)

代入：
$$
V_{ADC} = 8.4V \times \frac{2.2k}{10k + 2.2k} \approx 8.4 \times 0.18 \approx 1.51V \quad（略超，可调）
$$

> 更稳妥推荐：**R1 = 15kΩ，R2 = 2.2kΩ**

$$
V_{ADC} = 8.4V \times \frac{2.2k}{15k + 2.2k} \approx 8.4 \times 0.126 \approx 1.06V （接近 1V，安全）
$$

或者更保险一点：**R1 = 18kΩ，R2 = 3.3kΩ**

$$
V_{ADC} \approx 8.4 \times \frac{3.3}{18+3.3} \approx 8.4 \times 0.154 \approx 1.29V （仍略高，但 ESP8266 A0 最高耐受约 1V，建议不超过 1V）
$$

👉 **建议最终选择：R1 = 15kΩ，R2 = 2.2kΩ，输出约 1.0V @ 8.4V，比较安全，且覆盖大部分使用场景**

> **分压后的电压接入 ESP8266 的 A0（GPIO 0）**

---

## 三、软件实现

### 1. **读取电池电压**

```cpp
const int batteryPin = A0;  // ADC 引脚
const float R1 = 15000.0;   // 15k
const float R2 = 2200.0;    // 2.2k
const float VREF = 1.0;     // ESP8266 ADC 最大约 1.0V
const float ADC_RESOLUTION = 1023.0;

float readBatteryVoltage() {
  int adcValue = analogRead(batteryPin); // 0 ~ 1023
  float voltage_adc = adcValue * (VREF / ADC_RESOLUTION); // 得到分压后的电压，比如 0.8V
  float batteryVoltage = voltage_adc / (R2 / (R1 + R2));   // 还原为真实电池电压
  return batteryVoltage;
}
```

> 📌 注意：`analogRead()` 返回值是 0 ~ 1023，对应 0V ~ 1V（ESP8266 的 ADC 满量程约为 1.0V）

---

### 2. **根据电压计算目标 PWM 值（恒速策略）**

你可以：

#### ✅ 方法一：查表法（推荐，准确可控）

| 18650x2电压 (V) |  1.2Vx4镍氢电压（V）  | 目标 PWM 值（举例） |
|--------------|-------------------|---------------------|
| 8.4 （满电） |  >=5.6(满电)  | 160                 |
| 7.4          |  5.2~5.6  |180                 |
| 7.0          |   4.8~5.2  |200                 |
| 6.4          |   4.4~4.8  |220                 |
| 6.0          |  <=4.4 不建议使用需要充电  |240                |
| 5.0          |     | 255（接近最大）     |

在代码中做一个简单的 **if-else 或 map 映射**：

```cpp
int getAdjustedSpeedForBattery(float batteryVoltage) {
  if (batteryVoltage > 8.0) return 160;
  if (batteryVoltage > 7.4) return 180;
  if (batteryVoltage > 7.0) return 200;
  if (batteryVoltage > 6.4) return 220;
  if (batteryVoltage > 6.0) return 240;
  return 255; // 低电量时尽量用最大占空比维持速度
}
```

---

#### ✅ 方法二：线性比例法（简化，但不够精准）

你也可以按比例映射，比如：

```cpp
float voltageRatio = batteryVoltage / 8.4;  // 以满电 8.4V 为基准
int basePWM = 160; // 满电时的基础 PWM
int adjustedPWM = basePWM / voltageRatio;  // 电压越低，PWM 越大
adjustedPWM = constrain(adjustedPWM, 160, 255);
return adjustedPWM;
```

但这种方式不如查表直观和稳定，推荐 **方法一：查表**

---

### 3. **在电机控制函数中使用动态 PWM**

修改你原来的 `forward()`、`backward()` 等函数，不再使用固定 speed，而是调用：

```cpp
int dynamicSpeed = getAdjustedSpeedForBattery(readBatteryVoltage());
forward(dynamicSpeed);  // 动态调整后的 PWM 值
```

---

## ✅ 四、完整示例（整合进你的 forward 函数）

```cpp
...
// ======================
// 电机引脚定义
// ======================
// Motor A（通常是左电机）
#define AIN1 5  // D1 → GPIO5
#define AIN2 4  // D2 → GPIO4

// Motor B（通常是右电机）
#define BIN1 14 // D5 → GPIO14
#define BIN2 12 // D6 → GPIO12
//=================================
//  电压参考采样获得电机转速恒定（相对）
//=================================
const int batteryPin = A0;  // ADC 引脚
const float R1 = 15000.0;   // 15k
const float R2 = 3000.0;    // 3k
const float VREF = 3.3;     // ESP8266 ADC 最大约 3.3V
const float ADC_RESOLUTION = 1023.0;

float readBatteryVoltage() {
  int adcValue = analogRead(batteryPin); // 0 ~ 1023
  float voltage_adc = adcValue * (VREF / ADC_RESOLUTION); // 得到分压后的电压，比如 0.8V
  float batteryVoltage = voltage_adc / (R2 / (R1 + R2));   // 还原为真实电池电压
  return batteryVoltage;
}

int getAdjustedSpeedForBattery(float batteryVoltage) {
  batteryVoltage -=0.5;
  float voltageRatio = batteryVoltage / 5.6;  // 以满电 8.4V 为基准
  int basePWM = 130; // 满电时的基础 PWM
  int adjustedPWM = basePWM / voltageRatio;  // 电压越低，PWM 越大  
  adjustedPWM = constrain(adjustedPWM, 130, 255);
  if ( batteryVoltage < 4.6) adjustedPWM = 0;
  Serial.print("Battery: ");
  Serial.print(batteryVoltage, 2);
  Serial.print("V, Ratio: ");
  Serial.print(voltageRatio, 2);
  Serial.print(", PWM: ");
  Serial.println(adjustedPWM);
  return adjustedPWM;
}
// ======================
// 电机控制函数
// ======================
void stopMotors() {
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);
  digitalWrite(BIN1, LOW);
  digitalWrite(BIN2, LOW);
}

void driveMotor(int pwmPin1, int dirPin1, int pwmPin2, int dirPin2, int speed) {  
  if (speed > 0) {
    analogWrite(pwmPin1, speed);
    digitalWrite(dirPin1,LOW);
    analogWrite(pwmPin2, speed);
    digitalWrite(dirPin2, LOW);
  } else {
    stopMotors();
  }
}

void forward() {
  int speed = getAdjustedSpeedForBattery(readBatteryVoltage());  
  driveMotor(AIN2, AIN1, BIN1, BIN2, speed);
}

void backward() {
  int speed = getAdjustedSpeedForBattery(readBatteryVoltage());  
  driveMotor(AIN1, AIN2, BIN2, BIN1, speed);
}

void turnRight() {
  int speed = getAdjustedSpeedForBattery(readBatteryVoltage());  
  driveMotor(AIN1, AIN2, BIN1, BIN2, speed);
}

void turnLeft() {
  int speed = getAdjustedSpeedForBattery(readBatteryVoltage());  
  driveMotor(AIN2, AIN1, BIN2, BIN1, speed);
}

// ======================
// setup()：初始化
// ======================
void setup() {
  Serial.begin(115200);

 // 设置电机控制引脚为输出模式
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  
  // 初始化时电机停止
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);
  digitalWrite(BIN1, LOW);
  digitalWrite(AIN2, LOW);
  
  // 可选：设置PWM频率，默认1kHz，可根据需要调整
   analogWriteFreq(200); // 设置为5kHz

  stopMotors();

...  
```

> 你可以将 `readBatteryVoltage()` 和 `getAdjustedSpeedForBattery()` 提取为工具函数，复用

---

## ✅ 五、进阶优化（可选）

| 功能 | 说明 |
|------|------|
| **OLED 显示电池电压 / PWM** | 加一块 OLED，实时显示电量和调整后的 PWM，便于调试 |
| **低电量报警** | 当电压低于某值（如 6.0V），通过蜂鸣器 / LED 提示 |
| **自动降速保护** | 极低电量时限制功能，防止电池过放损坏 |
| **校准功能** | 让用户在不同电量下手动校准最佳 PWM 值 |
| **电压平滑滤波** | 对 ADC 采样做滑动平均，避免抖动 |

---

## ✅ 六、总结

| 功能 | 实现方法 |
|------|----------|
| **电池电压检测** | 通过电阻分压电路 + ESP8266 A0 模拟输入读取 |
| **电压转换计算** | 根据分压比还原真实电池电压（公式计算） |
| **恒速策略** | 根据电压查表或计算，动态调整 PWM 占空比 |
| **电机控制** | 将动态 PWM 值传入 `analogWrite()`，驱动 DRV8833 |
| **效果** | 电池电量变化时，电机仍然保持“用户感觉一致的速度” |

---

 😊🔋🚗💨
