---
layout: post
title: "使用Swift&Xcode6为iOS应用做国际化(二)"
date: 2015-05-21
comments: true
categories: 记录
tags: "国际化"
---

在上一节中，我们介绍了


###应用内实现语言切换
应用启动时，首先会读取NSUserDefaults中的key为`AppleLanguages`的内容，该key返回一个String数组，存储着APP支持的语言列表，数组的第一项为APP当前默认的语言。

在安装后第一次打开APP时，会自动初始化该key为当前系统的语言编码，如简体中文就是zh-Hans。

```
//获取APP当前语言
(NSUserDefaults.standardUserDefaults().valueForKey("AppleLanguages") as! Array<String>)[0]
```

那么我们要实现语言切换改变`AppleLanguages`的值即可，但是这里有一个坑，因为苹果没提供给我们直接修改APP默认语言的API，我们只能通过NSUserDefaults手动去操作，且`AppleLanguages`的值改变后APP得重新启动后才会生效（才会读取相应语言的lproj中的资源，意义着就算你改了，资源还是加载的APP启动时lproj中的资源），猜测应该是框架层对`AppleLanguages`的值进行了内存缓冲

```
//设置APP当前语言
var def = NSUserDefaults.standardUserDefaults()
def.setValue([“zh-Hans”], forKey:"AppleLanguages")
def.synchronize()
```

那么问题来了，如何做到改变`AppleLanguages`的值就加载相应语言的lproj资源？

其实，APP中的Storyboard的加载，图片与字符串的加载都是在`NSBundle.mainBundle()`上做的，那么我们只要在语言切换后把`NSBundle.mainBundle()`替换成当前语言的bundle就行了，这样系统通过`NSBundle.mainBundle()`去加载资源时实则是加载的当前语言bundle中的资源

> lproj目录可以用一个NSBundle表示

```
import Foundation

/**
*  当调用onLanguage后替换掉mainBundle为当前语言的bundle
*/
private  let _bundle:UnsafePointer<Void> =  unsafeBitCast(0,UnsafePointer<Void>.self)
class BundleEx: NSBundle {
    override func localizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        if let bundle = languageBundle() {
            return bundle.localizedStringForKey(key, value: value, table: tableName)
        }else{
            return super.localizedStringForKey(key, value: value, table: tableName)
        }
    }
}

extension NSBundle{
    private struct Static {
        static var onceToken : dispatch_once_t = 0
    }
    func onLanguage(){
        //替换NSBundle.mainBundle()为自定义的BundleEx
        dispatch_once(&Static.onceToken) {
            object_setClass(NSBundle.mainBundle(), BundleEx.self)
        }
    }
    
    //当前语言的bundle
    func languageBundle()->NSBundle?{
        return Languager.standardLanguager().currentLanguageBundle
    }
}
```

以上`Languager`是 [iOS-i18n](https://github.com/mokai/iOS-i18n) 开源库的一部分，我把项目中国际化部分封装了下，有兴趣的童鞋可以去看看 
