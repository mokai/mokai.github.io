---
layout: post
title: "使用Swift&Xcode6为iOS应用做国际化"
date: 2015-05-20 09:43:14 +0800
comments: true
sharing: false
categories: 记录
---

在真正将国际化实践前，只知道通过`NSLocalizedString`将相应语言的字符串加载进来即可。但最近公司项目的新需求增加英文版本，并支持应用内无死角切换~，这才跳过各种坑实现了应用内切换语言，并记录至此。

<!--more-->

###环境
系统环境: iOS7 - iOS8.3

开发环境: Swift & Xcode6.3.2

<br/>
整遍文章会围绕 [LocalDemo](https://github.com/mokai/LocalDemo) 进行讲解，读者可以先下载Demo运行看效果再往下

###iOS国际化原理分析	

各种国际化其实都大同小异，其核心思想就是`为每种语言单独定义一份资源`。

iOS就是通过`xxx.lproj`来定义每个语言的资源，我们可以看看iOS项目源代码的物理目录结构

Base，暂无需理会

![](http://7xiew0.com1.z0.glb.clouddn.com/local_0_1.png)

English

![](http://7xiew0.com1.z0.glb.clouddn.com/local_0_2.png)

Chinese

![](http://7xiew0.com1.z0.glb.clouddn.com/local_0_3.png)

每种语言都有自己的`语言编码`文件夹，在加载资源时只需要加载相应语言文件夹下的资源就OK，这步可以系统为我们完成，也可以手动去做。
> 项目源代码中如果有多个资源，则会有多个xxx.lproj，但在编译打包后，会集中放在app的根目录中的xxx.lproj中，不信你看~

![](http://7xiew0.com1.z0.glb.clouddn.com/local_0_4.png)

###开始

首先添加要支持的语言

![](http://7xiew0.com1.z0.glb.clouddn.com/local_1.png)
> 此处Use Base Internationalization针对字符串，storyboard，xib作为一个基础的源头，一般来说操作base

点击`+` 添加相应语言会弹出以下对话框，意思是为现有的资源文件添加语言文件。

![](http://7xiew0.com1.z0.glb.clouddn.com/local_2.png)

这里我们就按默认来，点击`finish`后添加成功

![](http://7xiew0.com1.z0.glb.clouddn.com/local_3.png)


###文本的国际化
主要针对代码中的字符串进行国际化，比如说一些消息，UI标题等

首先我们得先新建一个`Localizable.strings`，它是iOS默认加载的文件，如果想用自定义名称命名，在使用`NSLocalizedString`时指定tableName为自定义名称就好了，但你的应用规模不是很大就不要分模块搞特殊了

![](http://7xiew0.com1.z0.glb.clouddn.com/local_4.png)

在`Localizable.strings` -> 属性面板 -> Localization 点击Localize增加相应语言

![](http://7xiew0.com1.z0.glb.clouddn.com/local_5.png)

>其实此处的中文strings【Localizable.strings(Simplified)】可以不要的，因为key就是value，当找不到相应的语言strings或value时会直接返回key

可以看到其实就是为每一套语言新建一份strings，采用key->value的方式

然后我们在代码中这样写就行了

	NSLocalizedString("首页",comment: "")
    NSLocalizedString("好友",comment: "")
    NSLocalizedString("我",comment: "")


###图片的国际化
有二种做法，通过原生支持与自定义命名

>注意，新版Xcode中Images.xcassets不支持国际化

* ###### 原生支持
![](http://7xiew0.com1.z0.glb.clouddn.com/local_6.png)

	使用方式不变，iOS会自动找相应语言下的图片
	>此处的Base可以去掉，因为图片不存在编辑。
	
* 自定义文本命名

	![](http://7xiew0.com1.z0.glb.clouddn.com/local_7.png)

	代码中

		UIImage(named: NSLocalizedString("ic_home",comment: ""))
	>此种方法不推荐，一是因为工作量明显加大，二是不能在storyboard或XIB中使用


###storyboard的国际化

storyboard的国际化跟文本图片也差不多，通过`属性面板Localization`操作，但不同于二者的是，storyboard有二种方案
 
 * 基于默认的`Base StoryBoard`以及每种语言一套strings
 * 每种语言一套storyboard


###应用内实现语言切换

###现有项目集成


参考:

* [iOS国际化——通过脚本使storyboard翻译自增](http://www.cnblogs.com/levilinxi/p/4296712.html)
* [Working with Localization](https://medium.com/ios-apprentice/working-with-localization-905e4052b9de)
* [How to force NSLocalizedString to use a specific language](http://stackoverflow.com/questions/1669645/how-to-force-nslocalizedstring-to-use-a-specific-language)