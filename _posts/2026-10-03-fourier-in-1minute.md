---
layout: post
title: "一分钟傅里叶教程"
header-style: text
tags:
  - Math
  - Fields

mathjax: true
---
# 傅里叶级数：从热流到现代科技

*本文改编自应用数学家 Chris Budd 在格雷沙姆学院（Gresham College）的讲座之一。想了解这个免费公开讲座系列的更多信息，请见[格雷沙姆学院讲座系列页面](http://www.gresham.ac.uk/series/mathematics-and-the-making-of-the-modern-and-future-world)。*

有一个数学分支，它为解决一个问题而生，后来却解决了许多其他问题——傅里叶级数就是它最漂亮的例子之一。[约瑟夫·傅里叶](http://www-groups.dcs.st-and.ac.uk/~history/Biographies/Fourier.html)是19世纪法国数学家，他感兴趣的问题是热如何在物体中流动。他最初的贡献是如今被称为**热方程**的方程：它是**偏微分方程**（一种包含未知函数及其偏导数的方程）的一个例子，描述物体的温度 \(T\) 如何同时依赖于时间 \(t\) 和空间 \(x\)。用现代记号，热方程是：


$$
\frac{\partial T}{\partial t} = k \frac{\partial^2 T}{\partial x^2},
$$

其中 \(k\) 是物体的**热导率**，这个数衡量物体导热的能力。

如果你能求出这个方程的解，它就会告诉你物体在每个点 \(x\) 和时间 \(t\) 的温度 \(T(x,t)\)。傅里叶的第一个非凡洞见是：可以把 \(T(x,t)\) 表示成一组简单函数之和，然后以这些函数求解热方程。一个很好的类比是：一块砖一块砖地盖房子，比一口气盖好容易得多。他的第二个非凡洞见在于选择哪些函数来构造温度。他选择的是[正弦和余弦](http://www.bbc.co.uk/education/guides/zq4w7ty/revision)函数，它们来自三角学（研究三角形的学问），于是他把 \(T\) 写成：

$$
T(x,t)=\frac12 a_0(t)+[a_1(t)\cos(x)+b_1(t)\sin(x)]+[a_2(t)\cos(2x)+b_2(t)\sin(2x)]+[a_3(t)\cos(3x)+b_3(t)\sin(3x)]+[a_4(t)\cos(4x)+b_4(t)\sin(4x)]+\cdots
$$

这个求和会无限延续下去。下一项是 \\([a_5(t)\cos(5x)+b_5(t)\sin(5x)]\\)，再下一项是 \\([a_6(t)\cos(6x)+b_6(t)\sin(6x)]\\)，以此类推。

其中的 \\(a_0(t), a_1(t), a_2(t)\\) 以及 \\(b_1(t), b_2(t)\\) 等都是系数，其具体取值取决于初始条件（见下文“系数”部分）。

这样的表达式现在称为**傅里叶级数**。

**系数**

\\(a_n(t)\\) 和 \\(b_n(t)\\) 定义为

\\[
a_n(t)=A_n e^{-k n^2 t},\qquad b_n(t)=B_n e^{-k n^2 t},
\\]

其中 \\(A_n\\) 和 \\(B_n\\) 的取值取决于初始条件。

乍一看，用这种方式表示 \(T\) 非常奇特。毕竟，三角函数和热流之间能有什么联系？然而，这恰好是求解上述热方程的正确选择。它把问题分解成一组更简单的问题，每个都可以单独求解，再组合起来得到原问题的解。事实上，在傅里叶最初洞见之后不久，人们就发现，用正弦和余弦来构造函数还能解决大量其他问题，包括描述波的运动、气体的行为、许多与重力、静电、电磁学有关的问题，甚至股票市场的行为。

继傅里叶伟大发现之后，许多数学家着手扩展和推广他的思想，在此过程中发现了许多漂亮结果，其中包括对[莱昂哈德·欧拉](http://www-groups.dcs.st-and.ac.uk/~history/Biographies/Euler.html)最初发现的奇妙公式的简洁推导：

$$
\frac{\pi^2}{6}=1+\frac{1}{2^2}+\frac{1}{3^2}+\frac{1}{4^2}+\frac{1}{5^2}+\cdots
$$

傅里叶级数及其在计算机上的离散形式，在现代技术中起着根本性的作用。特别是，我们用它们来合成和处理声音、信息和图像；没有它们，音乐、电视和视频产业就不会存在。

## 进一步阅读和收听

想进一步了解傅里叶分析，请收听这期由 Chris Budd 参与的[播客](https://plus.maths.org/content/podcast-11-june-2008-catching-waves)。

关于受傅里叶级数启发的数学应用，更多内容见：

- [拯救生命：断层扫描的数学](https://plus.maths.org/content/saving-lives-mathematics-tomography)
- [吃、喝、快乐：确保安全](https://plus.maths.org/content/eat-drink-and-be-merry)
- [从 Abel 到 iPod](https://plus.maths.org/content/abel-ipod)
- [职业访谈：音频软件工程师](https://plus.maths.org/content/career-interview-audio-software-engineer)
- [职业访谈：计算机音乐研究者](https://plus.maths.org/content/career-interview-computer-music-researcher-0)

