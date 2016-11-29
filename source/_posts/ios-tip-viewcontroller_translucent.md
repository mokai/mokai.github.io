---
layout: post
title: "#技巧1# iOS8以后presendViewController透明效果无效"
date: 2015-10-10
comments: true
categories: iOS那些技巧
sharing: false
---
iOS弹出的视图背景默认是黑色，如果想去掉，以往我们使用 `self.modalPresentationStyle = .CurrentContext` 就可以实现效果，如以下半透明的代码

```
let vc = UIViewController()
vc.view.backgroundColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.5)
self.modalPresentationStyle = .CurrentContext
self.presentViewController(vc, animated: true, completion:  nil)
```

但是你会发现这段代码在iOS8、iOS9上面运行依旧一片黑，因此iOS8以后得这么干

```
let vc = UIViewController()
vc.view.backgroundColor = UIColor(red: 0.000 , green: 0.000 , blue: 0.000, alpha: 0.5)
if let version = Float(UIDevice.currentDevice().systemVersion) where version >= 8 {
    vc.modalPresentationStyle = .OverCurrentContext //注意此处是弹出VC对象，不是self
} else {
    self.modalPresentationStyle = .CurrentContext
}
self.presentViewController(vc, animated: true, completion: nil)
```

iOS8后增加了`OverCurrentContext`取代`CurrentContext`，并且设置的对象是弹出的VC



