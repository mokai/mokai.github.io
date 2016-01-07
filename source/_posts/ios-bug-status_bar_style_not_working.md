---
layout: post
title: "#坑4# 设置statusBarStyle无效"
date: 2015-11-18
comments: true
categories: iOS那些坑
sharing: false
---

新的一个APP，需要设置状态栏为白色，无论通过代码设置`UIApplication.sharedApplication().statusBarStyle = .LightContent` 
还是直接在 `TARGETS` 中设置，发现都无效。

![](http://i.stack.imgur.com/NoSiZ.png)

我们只需要把`Info.plist`中的`View controller-based status bar appearance`改为NO就行了，默认为YES

####参考:

[(iOS8) set the status bar to light content](http://stackoverflow.com/questions/26372684/ios8-set-the-status-bar-to-light-content)

