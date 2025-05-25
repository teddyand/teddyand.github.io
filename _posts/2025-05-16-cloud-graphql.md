---
layout: post
title:  "云中漫步"
author: "David"
header-style: text
tags: 
    - 软件  
    - 部署
---

>关键词：古人有云：学规矩，老不逮新;知应用，新不如老。也许弯路对于一个人的作用就是，让我们知道我们是何时、何地开始走在正确的道路上的。十年'动乱'让我们学会了勉力而行，不要放弃。cloudflare、aliyun、serverless、hono、graphql、restfull、nest.js

# 云平台前端框架（快速）部署
随着云技术的应用，国内外越来越多的云平台推出了自己的结合多种框架快速部署模板，这里笔者曾经使用过vercel的next.js框架快速部署了一个自己的多用户简历发布网站（结合json server技术）[大卫三城记](https://www.triplecity.site/)。
而今随着[serverless](https://baike.baidu.com/item/Serverless/60009381) 技术的使用，用户可以更加快速的部署发布自己的产品，因为其弹性收缩、按量收费、降本增效的原则，用户可以更加专注于自己的产品设计而无需过多思考平台环境配置、数据集成、后期维护升级迭代、安全容灾等问题。
![传统主机架构与serverless架构弹性模式负载示意](https://tse4-mm.cn.bing.net/th/id/OIP-C.87tF_ZElIV7Y92M9BSxMuwHaCT?rs=1&pid=ImgDetMain  "传统主机架构与serverless架构弹性模式负载示意")

笔者最近的项目都是围绕着：vercel、netlify、aliyun、cloudflare平台及next.js、nest.js、react、vue、开展，并了解了最新的RESTFULL、JSON-server、graphql等技术。

## 框架[hono](https://hono.dev/docs/)
hono是一个小型、简单、快速的基于serverless功能的web框架,它可以部署于多个javascript runtime平台： Cloudflare Workers, Fastly Compute, Deno, Bun, Vercel, Netlify, AWS Lambda, Lambda@Edge, 和 Node.js。再结合起功能丰富的中间件，能快速实现我们的功能要求的产品原型设计。
这里笔者按照网站指导快速部署了一个自己的[graphql-server后端服务](https://my-app5.pages.dev/graphql)通过查询
```graphql
query {
    hello
}
```
返回一个json列表
```json
{
  "data": {
    "hello": "Hello Hono!"
  }
}
```

## 平台[serverless devs](https://www.serverless-devs.com/docs/getting-started)
Serverless Devs 是一个开源开放的 Serverless 开发者平台，致力于为开发者提供强大的工具链体系。通过该平台，开发者不仅可以一键体验多云 Serverless 产品，极速部署 Serverless 项目，还可以在 Serverless 应用全生命周期进行项目的管理，并且非常简单快速的将 Serverless Devs 与其他工具/平台进行结合，进一步提升研发、运维效能。
根据指导快速在阿里云平台部署nest.js框架结合graphql-server功能参考[阿里云部署函数服务部署nest.js](https://www.cnblogs.com/jasongrass/p/17615357.html "阿里云函数部署nest.js")

### 部署
1. 初始化Nest.js项目：
```
s init start-nest-v3 -d start-nest-v3
```
2. 进入项目目录，安装依赖和项目启动：
```
cd start-nest-v3 && npm i && npm start
```
3. 部署项目：
```
s config add #添加自己的accessKeyID、accessSecret及 部署地区
s deploy
```

### 查询添加
我的[graphql](https://triplecity.fun)：

```graphql
# Get all books
query {
  books {
    id
    title
    author
    publishedYear
  }
}

# Get a single book
query {
  book(id: 1) {
    id
    title
    author
    publishedYear
  }
}
# Create a new book
mutation {
  createBook(
    title: "New Book"
    author: "John Doe"
    publishedYear: 2024
  ) {
    id
    title
    author
    publishedYear
  }
}

# Update a book
mutation {
  updateBook(
    id: 1
    title: "Updated Title"
  ) {
    id
    title
    author
    publishedYear
  }
}

# Remove a book
mutation {
  removeBook(id: 1)
}
```
得到的响应
```json
[
  {
    "id": 1,
    "title": "The Great Gatsby",
    "author": "F. Scott Fitzgerald",
    "publishedYear": 1925
  },
  {
    "id": 2,
    "title": "姚二嘎之死",
    "author": "david",
    "publishedYear": 2012
  }
]
```

