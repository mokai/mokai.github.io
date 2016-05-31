---
layout: post
title: "#坑5# 设置view.frame.size时如何更改动画方向"
date: 2016-3-17
comments: true
categories: iOS那些坑
sharing: false
---

![direction](http://7xq95r.com1.z0.glb.clouddn.com/2016-03-17-direction.png?imageView2/2/w/600/h/400/q/100)

<!--more-->

当我们在一个动画块内修改一个view.frame.size时，默认的动画方向是左上角，也就是上图的top-left

```
UIView.animateWithDuration(0.8) { () -> Void in
	view.frame.size = CGSizeMake(100, 100)
}
```

效果是这样的。
![resize_nodirection](http://7xiew0.com1.z0.glb.clouddn.com/2016-03-17-resize_nodirection.gif)

可以看到View的缩放效果是沿着左上角的，然而我们如果想往其他方向缩放，如图1中的top-right右上角，正确的姿势应该是这样：

```
//1
let frame = view.frame
let oldAnchorPoint = self.anchorPoint
let anchorPoint = CGPointMake(1, 0) //此处设置动画方向
let position = CGPointMake(frame.origin.x + anchorPoint.x * frame.size.width, frame.origin.y + anchorPoint.y * frame.size.height)
view.layer.anchorPoint = anchorPoint
view.layer.position = position

//2
UIView.animateWithDuration(0.8, animations: { () -> Void in
    view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1) //只有使用scale才能实现View大小改变并且不平移
    }) { (isFinshed) -> Void in
        //3、还原
        frame = view.frame
        view.layer.transform = CATransform3DIdentity
        let position = CGPointMake(frame.origin.x + oldAnchorPoint.x * frame.size.width, frame.origin.y + oldAnchorPoint.y * frame.size.height)
        view.layer.anchorPoint = oldAnchorPoint
        view.layer.position = position
        view.frame = frame
}
```

1、在图1中的top-righ上，我们可以看到一个红点，该点称之为anchorePoint锚点，设置该点为右上角`(1, 0)`，这样一来相当于给我们的动画指定了一个方向。如果对`anchorPoint`与Point不是很了解的同学可以戳这里 [彻底理解position与anchorPoint](http://wonderffee.github.io/blog/2013/10/13/understand-anchorpoint-and-position/)
2、使用`CATransform3DMakeScale`缩放，因为它基于`anchorPoint`缩放，如默认缩放就是在正中间，因为anchorPoint默认值就是`(0.5, 0.5)`。
3、还原成原来的anchorPoint与position，以及清理transform

![resize_direction](http://7xiew0.com1.z0.glb.clouddn.com/2016-03-17-resize_direction.gif)


更详情的Demo请戳以下图片

[![](http://7xiew0.com1.z0.glb.clouddn.com/github_TestResizeAnimationDirectionScreenshots.gif)](https://github.com/mokai/TestResizeAnimationDirection)






