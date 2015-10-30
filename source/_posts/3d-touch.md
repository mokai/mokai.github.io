---
layout: post
title: "3D Touch使用"
date: 2015-10-27
comments: true
categories: 记录
tags: "3D Touch"
---

3D Touch技术最先应用在Apple Watch上面，但叫`Force Touch`，后在iPhone6s上加入了此技术，并改名3D Touch。值得注意的是目前3D Touch只支持iPhone6S以后的机型，包括6s的模拟器也不支持，不过Github上的xxx项目已经实现了`Quick Actions`，但不能使用`Peek&Pop`。

<!--more-->

如果你还不知道3D Touch是什么，可以看看官方的[宣传视频](http://images.apple.com/media/us/iphone-6s/2015/dhs3b549_75f9_422a_9470_4a09e709b350/films/feature/iphone6s-feature-cc-us-20150909_r848-9dwc.mov)。


目前3D Touch目前可以分为三种：

* Quick Actions可以理解PC桌面的快捷方式
* Peek&Pop应用内快速预览内容
* UITouch自定义3D Touch事件

## Quick Actions
配置Actions可以通过工程info文件静态配置，也可以在运行时动态添加，两者可以一起使用。

静态配置我们可以通过

核心类是UIApplicationShortItem，代表一个

动态配置

## Peek&Pop
使用场合

## UITouch





