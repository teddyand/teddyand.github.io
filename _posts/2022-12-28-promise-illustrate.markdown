---
layout: post
title:  "javascript中的异步编码"
author: "teddy"
tags: theory
excerpt_separator: <!--more-->
---
[![Netlify Status](https://api.netlify.com/api/v1/badges/5a235694-f18f-4b36-ba90-a6638db1f878/deploy-status)](https://app.netlify.com/sites/davidit/deploys)

javascript和Node.js高度依赖异步编码范式，这是一个非常难的主题。我现在试着纪录一下。浏览器于web服务器之间连接的性质是异步的，而Node.js主要围绕这一概念设计。<!--more--> 顾名思义，同步编码中代码的执行是顺序完成的，这也是绝大部分程序的执行方式；而异步编码代码的执行可以不于主流代码一致比如:使用REST API和操作数据库时。接下来看看同步异步之间的差别，为何使用异步方式，什么时候使用。及使用时面对的三个难题，并使用promise来缓解问题，最后介绍两个关键字async和await。

#### 加载单个文件
同步方式：
```
console.log('Starting synchronous file load');  
var textFileContent = fs.readFileSync('bicyle_routes.txt','utf8'); 
console.log('...finished synchronous file load.');  
```
@startuml

[*] --> A 
A : 在加载文件之前，代码执行
A --> B
B : 以同步方式加载bicycle_routes.txt
B --> C
C : 在文件加载完成后，代码继续执行 

note left of A : console.log('Starting synchronous file load'); 
note left of B : var textFileContent = fs.readFileSync('bicyle_routes.txt','utf8'); 
note left of C : console.log('...finished synchronous file load.');  
@enduml

同步方式容易理解，也容易解释。但有一个问题，就是同步操作期间，它会阻止主线程执行任何其他工作。

@startuml
concise "用户接口" as UI
scale 100 as 50 pixels
@UI
0 is 处理请求
+200 is 同步方式加载bicycle_routes.txt
+500 is 处理请求
@enduml
在基于UI的应用程序中，如果出现阻止，UI将无法响应。如果在node.js中出现这种情况，你的服务器将变得无法响应，也就是在同步操作执行过程中，服务器将无法在响应HTTP请求。如果操作快速结束，（如图）不会产生太大差异，如果同步操作很长，或者有多个同步操作要逐个完成，那么HTTP请求会超时并在浏览器中显示错误消息。在其他一些语言中，同步编码是标准方式，这种情况下，我们可通过将此类占用大量资源的操作委派给一个工作线程来避免发生问题。但在Node.js中无法这样使用线程，因为Node.js通常被认为是单线程的。为避免阻止主线程，必须使用异步编码。下图中Node.js使用异步加载函数: readFile。调用此函数将启动文件加载操作，并立即返回到调用代码，文件内容会以异步方式加载到内存中。当文件加载完成时，将调用回调函数，并提供文件中的数据。

```
console.log('Starting asynchronous file read...');
fs.readFile('bicycle_routes.txt','utf8',
	function (err,textFileContent) {
		console.log('...finished asynchronous file load.');
	}
);
console.log('Continue code execution...');
```
@startuml

[*] --> A 
A : 在加载文件之前，代码执行
A --> B
B : 以异步方式加载bicycle_routes.txt
B --> c
B --> D : 异步操作
D --> C
D : 异步操作在主线程流之外发生
c : 在异步文件加载操作执行过程中，代码继续执行
c --> C
C : 在将来的某个时刻，当异步文件加载操作完成时，调用回调函数

note left of A : console.log('Starting asynchronous file load'); 
note left of B 
	fs.readFile('bicycle_routes.txt','utf8',
	function (err,textFileContent) {
		console.log('...finished asynchronous file load.');
	}
);
end note
note left of c : console.log('Continue code execution...');
note left of C : console.log('...finished asynchronous file load.');  
@enduml

回调是一个Javascript函数，当单个异步操作完成时，会自动调用该函数，对于普通（非promise）的回调，不管操作失败还是成功，最终都会调用回调函数。如果失败，会向回调传递一个错误对象，指出操作失败。我们很快还会进一步了解错误处理相关内容。现在，使用的是异步编码，文件加载操作不会锁定主线程，主线程可以继续处理其他工作，例如响应用户请求如图：

@startuml
hide time-axis
scale 1 as 50 pixels
concise 异步线程
concise 主线程

@异步线程
2 is 以异步方式加载bicycle_routes.txt
10 is {hidden}

@主线程
0 is 处理请求
2 is {hidden}
4 is 处理其他请求
7 is {hidden}
10 is 执行回调

@enduml
上面是加载一个文件是的同异步编码的情况，接下来我将扩展其为加载多个文件的例子。

### 加载多个文件
假定有一系列文件需要加载，这些文件按照国家/地区加以区分，例如bicycle_routes_usa.txt、bicycle_routes_australia.txt、bicycle_routes_england.txt等。我们需要加载这些文件并将他们组合起来，以访问完整的数据集。以同步方式执行会产生很大问题，长时间锁定主线程，使其无法处理其他工作见图
@startuml
hide time-axis
concise "用户接口" as UI
scale 100 as 50 pixels
@UI
0 is 处理请求
+200 is 加载bicycle_routes_usa.txt
+400 is 加载bicycle_routes_australia.txt
+600 is 加载bicycle_routes_england.txt
@enduml

@startuml
hide time-axis
scale 1 as 50 pixels
concise 异步线程
concise 主线程

@异步线程
2 is 加载bicycle_routes_usa.txt
6 is {hidden}
8 is 加载bicycle_routes_australia.txt
12 is {hidden}
14 is 加载bicycle_routes_england.txt

@主线程
0 is 处理请求
2 is {hidden}
6 is 回调
8 is {hidden}
12 is 回调
14 is {hidden}
@enduml
在上图的基于回调的异步编码时，会遇到第一个大问题。如图每个回调都必须调用后续异步操作，并设置其回调。这导致了回调嵌套：按照缩进级别定义每个回调的代码。随着异步操作变得越来越长，缩进也变得越来越深。最终导致“回调地狱”。为了获得更好性能和处理能力，也许应该并行执行多个异步操作见图
@startuml
hide time-axis
scale 1 as 50 pixels
concise 异步线程1
concise 异步线程2
concise 异步线程3
concise 主线程

@异步线程1
4 is 加载第三个文件
6 is {hidden}

@异步线程2
3 is 加载第二个文件
5 is {hidden}

@异步线程3
2 is 加载第一个文件
4 is {hidden}

@主线程
0 is 处理请求
1.5 is {hidden}
6 is 执行回调1
7 is {hidden}
7.5 is 执行回调2
8.5 is {hidden}
9 is 执行回调3

@enduml
这意味着，CPU和IO系统可以尽快工作，将所有文件加载到内存中，但此过程不会阻碍主线程。现在的问题是如何才能知道什么时候所有问题都已完成？由于它们可以按照任意顺序完成，因此，在所有三个回调全部完成后才能执行的任何后续操作必须合理进行编码，使其可以被任意回调触发。执行的最后一个回调将触发后续操作。如何管理多个独立回调是新问题。

### 错误处理
在传统的异步编码中，无法使用try/catch语句来检测和处理错误。之所以不能，是因为无法在异步代码中检测错误。实际上，我们必须通过检查error对象来处理错误，可以选择该对象作为第一个参数传递给回调函数。如果此参数位null，则表明没有发生任何错误，否则，可以查询该error对象，来确定错误性质。


在处理单个异步操作时，此机制没问题。但多个连续异步操作情况会复杂得多。任何一个异步操作都可能失败，并且他们可按任意顺序执行。如果并行异步或并行和顺序异步组合时，情况更复杂。
@startuml
hide time-axis
scale 1 as 50 pixels
concise 异步线程1
concise 异步线程2
concise 异步线程3
concise 主线程

@异步线程1
4 is 加载第三个文件
6 is {hidden}

@异步线程2
3 is 加载第二个文件
5 is {hidden}

@异步线程3
2 is 加载第一个文件
4 is {hidden}

@主线程
0 is 处理请求
1.5 is {hidden}
6 is 执行回调1
7 is {hidden}
7.5 is 执行回调2 #gray
8.5 is {hidden}
9 is 执行回调3

@enduml