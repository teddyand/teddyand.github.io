---
layout: post
title:  "Ruby爬虫初探"
date:   2021-10-18 09:50:01 +0800
categories: jekyll update
---

***写作本文的目的借博主关注的作家岳南的新浪博客介绍Ruby爬虫的使用。***

## 借助交互Ruby控制台改善
Mechanize为编写爬取工具提供了强大的基础，有两个原因：其一，便于发送HTTP请求；其二，为搜索远程文档提供了强大的句法。我们已经见识到如何使用Mechanize轻松发送GET请求，下面探索如何使用它过滤大量文档，获取重要文本内容。我们可以在Ruby IRB（交互式Ruby shell）中手动探索爬取过程。

{% highlight ruby %}
$ irb -r./scraper
2.7.2 :001 > scraper=Scraper.new
 => #<Scraper:0x090e36d0 @root="http://blog.sina.com.cn/s/articlelist_1311... 
2.7.2 :002 > page=scraper.agent.get "#{scraper.root}#{1}.html"
 => 	
#<Mechanize::Page
... 
2.7.2 :003 > items=page / "a[title=\"\"]"
 => [#<Nokogiri::XML::Element:0x6cca name="a" attributes=[#<Nokogiri::XML:... 
2.7.2 :004 > items[0].text
 => "西南联大缘何大师辈出？" 
2.7.2 :005 > items[0].values[2]
 => "http://blog.sina.com.cn/s/blog_4e3308af01032aht.html" 
2.7.2 :006 > page1=scraper.agent.get(items[0].values[2]) 
 => 
#<Mechanize::Page
... 
2.7.2 :007 > body = page1 / "div[id=sina_keyword_ad_area2]"
 => [#<Nokogiri::XML::Element:0xac08 name="div" attributes=[#<Nokogiri::XM... 
2.7.2 :008 > body.text.strip

{% endhighlight %}

第一行启动IRB,并使用-r开关加载当前目录中的爬虫库。如果你以前没用过IRB,有几件事要知道，了解这些事之后，你的生活会变得更轻松。IRB中有提示符，指明使用Ruby的版本和运行命令的序号。IRB的功能众多，这里所涉极少。命令序号可用于重放历史，还能用于控制作业，这与很多其他类型的shell相似。在IRB提示符后面可以输入Ruby代码，irb会立即执行，然后输出结果，在=>符号后面打印返回值。在试验Ruby的过程中，经常会遇到复杂的返回值，例如scraper.agent.get的返回值是一个Mechanize Ruby对象。这个对象很大，打印时要消耗大量资源。这里，我们简略了返回值的大部分。为了节省空间，以后讨论IRB时对复杂对象依然如此。上述命令中第二行将HTTP GET请求保存为一个page对象。获得这个对象之后如何从中提取信息呢？Mechanize提供了一个精巧的语法糖（syntatic sugar）　,搜索DOM结构特别方便，即“/”运算符。如第三行代码中如果查询找到了内容，那么将返回一个由Mechanize对象组成的数组。这里它将返回页面代码中 ```<a titile=　.../>”```既“作家岳南”的博客相关网页内容。第四行代码显示其作家第一篇文章标题。第五行显示作家第一篇文章链接地址。第六行代码接着爬取第五行链接相关的html代码。第七行搜索正文相关的html位置。第八行显示正文内容并去皮。
[代码详见][scraper.rb]　"run.rb“　运行结果显示为：
<details>
	<summary>作家岳南的新浪博客目录（截至　2012 Oct 8th）</summary>
	<pre><code>大师之后再无大师
一位走过白银时代的骑士
徐志摩该不该烧死？
南渡北归：大师远去，再无大师
王侯将相，就是有种
李霖灿：从圣地归来
秦始皇帝陵是否被盗？
杨振宁晚年重返清华园的隐秘
“九一八”夜晚,影星胡蝶在哪里？
清华校长梅贻琦，一个传奇的存在
抗战胜利，首都为何设在北平
我的写作缘起
在彼此忧患的眼睛里
诗人穆旦与远征军
地雷战：知识者未被引爆的命运
微斯人，吾谁与归？
一个遥远美丽的地方
..........
	</code></pre>	
</details>




## 使用Liquid Markup编写主索引文件


[scraper.rb]: https://github.com/teddyand/teddyand.github.io/blob/main/scraper.rb