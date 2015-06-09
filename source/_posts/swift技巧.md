---
layout: post
title: "Swift技巧"
date: 2015-04-17
comments: true
categories: 记录
sharing: false
---
1、[UIView class]在swift中怎么写  `UIView.self`

2、String类型无count、length检测长度方法，使用`countElements`来使用，我们可以为String扩展一个属性

```
extension String{
    //字符长度
    var count:Int{
        return countElements(self)
    }
}
```

<!--more-->

3、@synchronized 在swift中怎么写

```	
objc_sync_enter(lock)
//code
objc_sync_exit(lock)
```

但是 [stackoverflow](http://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized)上说这种方式有bug，用dispatch_sync代替

```
let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
dispatch_sync(lockQueue) {
    // code
}
```

或者使用[Synchronized开源库](https://github.com/ide/Synchronized)也可以

```
import Synchronized
let x = synchronized(NSObject()) { 0 }
```	



#资源
1、`XcodeSwiftSnippets` swift代码片段