---
layout: post
title: "#技巧5# UIWebView BaseURL无效"
date: 2016-11-12
comments: true
categories: iOS那些技巧
sharing: false
---

一年没更新博客了，这一年经历了很多，行业的寒冷对个人的职业规划还是蛮大。所以最后我选择了自由职业者这条路，虽说前期有点艰难，但现在这条路应该已经慢慢上道了。

好了，以下是本文内容

UIWebView中的HTML有时需要使用相对路径，如果你是使用loadRequest方法加载是没有问题的。

```
<img src='./xxx/xxx.jpg' />
```

但如果HTML是你自己提供的，也就是使用loadHTMLString: baseURL:方法


