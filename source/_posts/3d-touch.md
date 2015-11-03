---
layout: post
title: "3D Touch使用"
date: 2015-10-27
comments: true
categories: 记录
tags: "3D Touch"
---

3D Touch技术最先应用在Apple Watch上面，但叫`Force Touch`，后在iPhone6s上加入了此技术，并改名3D Touch。值得注意的是目前3D Touch只支持iPhone6S以后的机型，包括6s的模拟器也不支持，不过Github上的[SBShortcutMenuSimulator](https://github.com/DeskConnect/SBShortcutMenuSimulator)项目通过Hack方式已经实现了`Quick Actions`，但不能使用`Peek&Pop`。

<!--more-->
如果你还不知道3D Touch是什么，可以看看官方的[宣传视频](http://images.apple.com/media/us/iphone-6s/2015/dhs3b549_75f9_422a_9470_4a09e709b350/films/feature/iphone6s-feature-cc-us-20150909_r848-9dwc.mov)。

##环境

系统环境: iOS9 or later

开发环境: Swift2.0 & Xcode7.1 

Demo: [3DTouchDemo](https://github.com/mokai/3DTouchDemo)【ps没有6s或者6s plus的就不要下载了，下了你也跑不起来，所以赶快去卖肾吧】

##开始
目前3D Touch目前可以分为三种：

* Quick Actions可以理解PC桌面的快捷方式
* Peek&Pop应用内快速预览内容
* UITouch自定义3D Touch事件

## Quick Actions 快捷方式

<image src='https://raw.githubusercontent.com/mokai/3DTouchDemo/master/1.png' width='200'/>

配置Actions可以通过工程`Info.plist`文件静态配置，也可以在运行时动态添加，两者可以一起使用。

静态配置在添加`Info.plist`中的`UIApplicationShortcutItems`节点中添加相应Actions信息，

```
<key>UIApplicationShortcutItems</key>
<array>
	<dict>
		<key>UIApplicationShortcutItemIconType</key>
		<string>UIApplicationShortcutIconTypeSearch</string>
		<key>UIApplicationShortcutItemTitle</key>
		<string>搜索</string>
		<key>UIApplicationShortcutItemType</key>
		<string>me.mokai.TouchDemo.action.search</string>
	</dict>
	...
</array>
```	

动态配置通过`UIApplication的shortcutItems`添加，shortcutItems是一个`UIApplicationShortcutItem`数组

```
let type = "me.mokai.TouchDemo.action.identify"
let title = "听歌识别"
let shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title,
 localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "quick_filter"), userInfo: nil)
application.shortcutItems = [shortcutItem]
```
####Note

* Actions的图标可以使用系统预定的也可以自定义图片
* 对于每个Actions来说`type`是必须的，它代表着我们从桌面点击Actions进入到应用调用`application(application, performActionForShortcutItem:, completionHandler:)`时的唯一标识，另外userInfo可以附加每个actions的数据，如最近听歌的歌曲id
* 当APP启动时，shortcutItems保存的是上次动态添加的，如果是第一次启动则为空数组。
* Actions最多显示4个，优先显示静态Actions，然后剩余个数显示shortcutItems的前几个。


## Peek&Pop 快速预览
好了，下面介绍本文重头戏，先看看效果

<image src='https://raw.githubusercontent.com/mokai/3DTouchDemo/master/3.png' width='200'/>



## UITouch
高级玩法，绘图、游戏，把3D Touch发挥到极致。不过我也唔知玩也暂时没这方面需求，有需求看[官方绘图demo](https://developer.apple.com/library/prerelease/ios/samplecode/TouchCanvas/)

##参考
[Adopting 3D Touch on iPhone](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/)

[官方Demo](https://developer.apple.com/library/ios/samplecode/ApplicationShortcuts/Introduction/Intro.html#//apple_ref/doc/uid/TP40016545)


