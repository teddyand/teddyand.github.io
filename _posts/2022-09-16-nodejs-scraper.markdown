---
layout: post
title:  "一个Node.js爬虫气象预报程序"
author: "David"
header-style: text
tags:  
    - 语言
    - Maker
---

## An example from 《javascript on things》[^0]

<img align="right" src="https://ts1.cn.mm.bing.net/th/id/R-C.e700faf802f8cbbe2b700d2fedc397cf?rik=6YVDd1f4sBe0Mw&riu=http%3a%2f%2fimg95.699pic.com%2fphoto%2f40162%2f1277.gif_wh300.gif&ehk=%2bbSVVgmwZk0N4t%2f7bMYncg9PR7k0BZhLbss0elFRLQc%3d&risl=&pid=ImgRaw&r=0"/>
秋风起秋天到，在这个暑气消退，秋意渐凉的季节，“风”是主角，他带来了干爽也降低了温度，作为一名maker如何获取最新的天气预报并且用肉眼可观的方法告诉我们是否改增减衣服，注意保暖避免风寒是我比较关心的事情。这里介绍一个利用node.js下的Johhny-five库配合arduino uno控制板加RGB LED开发的和风天气预报灯。首先我们需要登录和风天气[^1]控制台，获取天气预报API密钥，并clone一份常见城市列表（可用Sublime text3）打开并从中找到要查询城市的位置代码（9位），继续创建weatherball.js文件。将获得的数据存入'API_KEY'、'AREA_CODE'、’API_URL‘变量中。并使用request API调用 key 再实例化一个开发板变量代码如下：（由于和风天气采用gzip格式加密json数据因此需要注明gzip为true并且采用get方式获得数据，这与书中略有不同。RGB灯的应用可参考[^2]）蓝牙模块配对参考[^3]arduino蓝牙模块接线[^4]

<details>
    <summary>和风天气json数据</summary>
    <pre><code>
{
    "code": "200",
    "updateTime": "2022-09-23T14:35+08:00",
    "fxLink": "http://hfx.link/2bm1",
    "daily": [{
        "fxDate": "2022-09-23",
        "sunrise": "05:43",
        "sunset": "17:51",
        "moonrise": "02:51",
        "moonset": "16:42",
        "moonPhase": "残月",
        "moonPhaseIcon": "807",
        "tempMax": "28",
        "tempMin": "19",
        "iconDay": "101",
        "textDay": "多云",
        "iconNight": "151",
        "textNight": "多云",
        "wind360Day": "0",
        "windDirDay": "北风",
        "windScaleDay": "3-4",
        "windSpeedDay": "16",
        "wind360Night": "0",
        "windDirNight": "北风",
        "windScaleNight": "3-4",
        "windSpeedNight": "16",
        "humidity": "69",
        "precip": "0.0",
        "pressure": "1018",
        "vis": "25",
        "cloud": "25",
        "uvIndex": "4"
    }, {
        "fxDate": "2022-09-24",
        "sunrise": "05:43",
        ......
        
</code></pre></details>

{% highlight javascript  %}
const request = require('request');
const five    = require('johnny-five');    

const API_KEY = '07834ec34198482694053ac7fa2d4abd';
const AREA_CODE = '101021200';
const API_URL   =   'https://devapi.qweather.com/v7/weather/3d?';

const board   = new five.Board();
board.on('ready', () => {
  console.log('Powered by Dark Sky: https://www.qweather.com/weather/');
  const rgb        = new five.Led.RGB({ pins: [3, 5, 6] });
  const requestURL = `${API_URL}location=${AREA_CODE}&key=${API_KEY}`;
  var url = requestURL;
  request.get({
    url:url,
    gzip: true // 加上这句即可
    }, function (error, response, body) {            
         const forecast = JSON.parse(body);
         console.log(forecast);
         const tempDelta  = forecast['daily'][1]['tempMax'] - forecast['daily'][0]['tempMax'];
         if (tempDelta > 4) {
             rgb.color('#ff0000'); // warmer
         } else if (tempDelta < -4) {
                 rgb.color('#ffffff'); // colder
           } else {
                rgb.color('#00ff00'); // about the same
            }
          })  
})
{% endhighlight %}
代码的意图是从json数据中获取今明两天的白天温度，并判断是否温差在正负4度之内绿灯，大于正4度蓝灯则表示升温可减衣物，小于负4度红灯为降温需要增加衣物。并判断是否当天风力大于等于7级，如大于则闪烁报警注意避风减少出行。**此段程序适用于北方秋冬季节多风干燥地区**


参考及更多阅读：

[^0]:[javascript on things](https://www.manning.com/books/javascript-on-things)
[^1]:[和风天气开发文档](https://dev.qweather.com/docs/api/)
[^2]:[RGB灯的使用](http://johnny-five.io/examples/led-rainbow/)
[^3]:[蓝牙模块配对](https://blog.csdn.net/SH_LYPTK/article/details/108916676)
[^4]:[arduino蓝牙接线](https://github.com/rwaldron/johnny-five/wiki/Getting-Started-with-Johnny-Five-and-HC-05-Bluetooth-Serial-Port-Module)