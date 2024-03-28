---
layout: post
title:  "MongoDB使用有记"
author: "david chen"
date:   2024-03-21 10:5７:01 +0800
tags:	Tutorial
excerpt_separator: <!--more-->
---

MongoDB是一种非关系型数据库，与传统的mysql等关系数据库不同。随着社会发展大数据时代的到来、信息量的增加，碎片化、不对等化数据的查询运算要求是现代信息数据的主要特点。<!--more-->过去那种严格定义数据集合、字段形式的关系数据库对高并发数据写入、查询上亿信息速度、分库分表到一定规模后的扩展、修改表结构的便捷性越来越难以达到，而MongoDB、Redis、Hbase、Neo4J等新型数据库的便捷化可扩展性强、速度快、可随意增加修改的特性使得非关系型数据库的应用越来越广泛


## MongoDB安装
[安装](https://www.runoob.com/mongodb/mongodb-linux-install.html)

## MongoDB操作
[Robo 3T](https://robomongo.org/)是一个可视化Mongodb GUI管理工具

### 插入单条或多条记录  
```
db.getCollection("example_data_1").insertOne({"name":"陈小二"，"age":"17","address":"上虞"})

db.getCollection("example_data_1").insertMany([{"name":"朱小三"，"age":20,"address":"北京"}
{"name":"刘小斯","age":21,"address":"上海"},
{"name":"马小五","age":22,"address":"山东"},
{"name":"夏侯小七","age":23,"address":"河北"},
{"name":"公孙小八","age":24,"address":"广州"},
{"name":"慕容小九","age":25,"address":"杭州"},
{"name":"欧阳小十","age":26,"address":"深圳"}])

```


### 查找和排序

```
db.getCollection("example_data_1").find({"age":{"$lte":25,"$gte":21},"name":{"$ne":"夏侯小七"}}).sort({"age": -1})  #查找年龄大于等于21小于等于25,并且名字不为“夏侯小七”的记录，按降序排列结果
```
```
db.getCollection("example_data_1").find({"age":{"$lte":25,"$gte":21},"name":{"$ne":"夏侯小七"}}).count() #返回符合条件的记录个数
```

### 修改记录（单或多条）

```
db.getCollection("example_data_1").updateMany({"name":"王小三"},{"$set":{"address":"苏州"，"work":"快递员"}})

```
### 删除数据（先查后删）

```
db.getCollection("example_data_1").find({"hello":"world"})
```
```
db.getCollection("example_data_1").deleteMany({"hello":"world"})
#工程上一般将要删除的文档增加一个”delete“并设为0, 要执行删除时只查询deleted设为1，查询只查deleted为0的数据，防止误操作。
```

### 数据去重

```
db.getCollection("example_data_1").distinct(字段名,查询条件)
```

## python操作MongoDB

| MongoDB命令  |  PyMongo方法    |
| :----:   |  :-----:   |
|	insertOne	|	insert_one	|
|	insertMany	|	insert_many	|
|	find	|	find	|
|	updateOne	|	update_one	|
|	updateMany	|	update_many	|
|	deleteOne	|	delete_one	|	
|	deleteMany	|	delete_many	|

### 对应插入多条记录的Robo 3T操作，python操作如下
```
from pymongo import MongoClient
client = MongoClient()
database = client.chapter_3
collection = database.example_data_1
collection.insert_many([
{"name":"朱小三"，"age":20,"address":"北京"}
{"name":"刘小斯","age":21,"address":"上海"},
{"name":"马小五","age":22,"address":"山东"},
{"name":"夏侯小七","age":23,"address":"河北"},
{"name":"公孙小八","age":24,"address":"广州"},
{"name":"慕容小九","age":25,"address":"杭州"},
{"name":"欧阳小十","age":26,"address":"深圳"}
])
```
### 查询数据
```
rows = collection.find({'age':{'$lt':25,'$gt':21},'name': {'$ne':'公孙小八'}})
for row int rows:
	print(row)
```


### 更新删除数据
```
row = collection.find({'name': {'$eq':'公孙小八'}})
print(row)
collection.update_many({'name':'公孙小八'}，{'$set':{'address':'芝加哥'，'age':80}})
rows = collection.find({'name': {'$eq':'公孙小八'}})
print(row)

```

### 插入新数据
```
collection.update_one({'name':'隐身人'},{'$set':{'name':'隐身人','age':0,'address':'二次元界'}},upsert=True)
```

### MongoDB与python不通用操作
1. 空值：
MongoDB中空值为 null。 python中空值为None。
2. 布尔值：
MongoDB中 “真”为true,“假”为false,首字母小写;python中，“真”为True,“假”为False,首字母大写。
3. 排序参数：
MongoDB中sort(),接受一个字典参数，key为字段名，值为1或者-1。python中sort()方法接收两个参数：第一个为字段名，第二个为-1或1
4. 查询_id：

```
#Robo 3T中：
db.getCollection("example_data_2").find({'_id':ObjectId(ObjectId("65fce218b75e244ac00adfe6"))})

#python :
from bson import ObjectId
rows = collection.find({'_id':ObjectId("65fa41a0b80a8b9ec740edf1")},{'_id':0})
for row in rows:
	print(row)

```

