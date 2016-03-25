---
layout: post
title: "#坑2# 强制旋转应用当前屏幕"
date: 2015-10-31
comments: true
categories: iOS那些坑
sharing: false
---

经常有这样的需求，APP只需要竖屏，但是一些特殊的场景下需要横屏。

比如说调用系统的`MPMovieViewController`播放视频时，我们会在AppDelegate中或者UIViewController中更新允许横屏的配置，当播放器旋转到横屏（此时设备应该也是处于横屏），APP现有`ViewController`也会跟着旋转，那么问题来了，当再次回到APP时，此时现有`ViewController`是处于横屏的，我们再去代理中更新为竖屏会发现代理根本不会被调用，这时我们就需要用到下面这段代码，去手动触发屏幕旋转事件 

```
let vc = UIViewController();
self.presentViewController(vc, animated: false, completion: nil)
vc.dismissViewControllerAnimated(false, completion: nil)
```

####参考:参考：

[iOS屏幕旋转学习笔记](http://foggry.com/blog/2014/08/08/ping-mu-xuan-zhuan-xue-xi-bi-ji/)

