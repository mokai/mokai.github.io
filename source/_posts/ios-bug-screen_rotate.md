---
layout: post
title: "#坑2# 强制旋转应用当前屏幕"
date: 2015-10-10
comments: true
categories: iOS那些坑
sharing: false
---
经常有这种需求，在调用`MPMoviePlayerController`播放视频时需要开启横屏，但APP却只需要竖屏，那么问题了，我们在进入`MPMoviePlayerController`时开启横屏时设备此时应该也是横屏方向的，



```
let vc = UIViewController();
self.presentViewController(vc, animated: false, completion: nil)
vc.dismissViewControllerAnimated(false, completion: nil)
```