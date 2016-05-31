---
layout: post
title: "#技巧3# postNotificationName触发后的监听代码是同步还是异步执行的？"
date: 2015-11-17
comments: true
categories: iOS那些技巧
sharing: false
---
昨天去酷狗面试，被问到`postNotificationName触发后的监听代码是同步还是异步执行的？`，我当时知道`触发后的监听代码和触发的代码是在同一线程上执行的`，但却回答了是异步，哎，我这逻辑又下降了。。。。

举个栗子，比如说HTTP异步请求返回代码中我们触发一个通知，这个时候在监听的代码中直接去设置视图就会报错，因为当前线程不是主线程，正确的姿态应该是

```
dispatch_async(dispatch_get_main_queue(), { () -> Void in
    NSNotificationCenter.defaultCenter().postNotificationName(kNotificationName, object: nil)
})             
```

当然你也可以选择另一种方式，`NSNotificationQueue`通知队列，我们可以通过它做很多基于Runloop的需求，最重要的是它是异步执行的。

```
let queue = NSNotificationQueue.defaultQueue()
queue.enqueueNotification(NSNotification(name: kNotificationName, object: nil), postingStyle: NSPostingStyle.PostNow)
```


####参考:

[cocoa的NSNotification通知](http://www.cnblogs.com/xiaouisme/archive/2012/04/06/2434753.html)

