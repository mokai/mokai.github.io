---
layout: post
title: "IB中Runtime Attributes个别属性无效"
date: 2015-04-07 13:38:57 +0800
comments: true
categories: 
---

在使用Xcode IB方式编码中，经常会使用到属性列表中没有的属性，这时则需要通过`Runtime Attributes`来动态注入(实则为`KVO`实现)

<!--more-->

![](http://ios-blog.co.uk/wp-content/uploads/2014/04/user-defined-runtime-attributes-300x282.png)


但有个别属性设置你会发现怎样都无效

如：`layer.borderColor`


原因在于`borderColor`接受的参数是CGColor类型，而此处的Color为UIColor，所以导致注入时参数类型不一致

###解决方案：利用扩展自定义一个`中间属性器`来转换一下就O了

1、自定义代码

	import Foundation
	extension CALayer{
	    //解决IB中runtime attribute中layer.borderColor不能转换UIColor为CGColor
	    var borderColorFromUIColor:UIColor{
	        set(color){
	            self.borderColor = color.CGColor;
	        }
	        get{
	            return UIColor(CGColor: self.borderColor)
	        }
	    }
	}
	
> 注意,swift与OC的属性设置器不同，OC中是setXXX，而swift是有内部setter

2、IB中设置，把原先的`layer.borderColor`改为`layer.borderColorFromUIColor`


![](http://ios-blog.co.uk/wp-content/uploads/2014/04/calayer-border-color-300x105.png)



参考:
[User Defined Runtime Attributes](http://ios-blog.co.uk/tutorials/user-defined-runtime-attributes/)

