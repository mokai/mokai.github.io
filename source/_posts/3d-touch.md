---
layout: post
title: "3D Touch使用"
date: 2015-11-5
comments: true
categories: 记录
tags: "3D Touch"
---

3D Touch最先应用在Apple Watch上面，但叫`Force Touch`，后在iPhone6s上加入了此特性，并改名3D Touch。值得注意的是目前3D Touch只支持iPhone6S以后的机型，包括现有Xcode7中6s的模拟器也不支持，不过Github上的[SBShortcutMenuSimulator](https://github.com/DeskConnect/SBShortcutMenuSimulator)项目通过Hack方式已经实现了`Quick Actions`快捷访问，但不能使用`Peek&Pop`快速预览。

<!--more-->
如果你还不知道3D Touch是什么，可以看看官方宣传视频
<video src="http://images.apple.com/media/us/iphone-6s/2015/dhs3b549_75f9_422a_9470_4a09e709b350/films/feature/iphone6s-feature-cc-us-20150909_r848-9dwc.mov" controls >
</video>


##环境

系统环境: iOS9 or later

开发环境: Swift2.0 & Xcode7.1 

Demo: [3DTouchDemo](https://github.com/mokai/3DTouchDemo)【ps没有6s或者6s plus的就不要下载了，下了你也跑不起来，所以赶快去卖肾吧】

效果：
<video src="http://7xiew0.com1.z0.glb.clouddn.com/3dtouch.mov" controls width=320 >
</video>


##开始
3D Touch可以分为三种：

* Quick Actions【可以理解PC桌面的快捷方式】
* Peek&Pop【应用内快速预览内容】
* UITouch【自定义3D Touch事件】

## Quick Actions 快捷方式

![](http://7xiew0.com1.z0.glb.clouddn.com/3dtouch_homeshorctquickactions.gif)

配置Actions可以通过工程`Info.plist`文件静态配置，也可以在运行时动态添加，两者可以一起使用。

静态配置在`Info.plist`中`UIApplicationShortcutItems`节点数组下添加相应Actions Item信息

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

动态配置通过UIApplication的`shortcutItems`添加，shortcutItems是一个`UIApplicationShortcutItem`数组

```
let type = "me.mokai.TouchDemo.action.identify"
let title = "听歌识别"
let shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title,
 localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "quick_filter"), userInfo: nil)
application.shortcutItems = [shortcutItem]
```

<b>Note</b>

* Actions的图标可以使用系统预定的也可以自定义图片
* 对于每个Actions来说`type`是必须的，它代表着我们从桌面点击Actions进入到应用调用`application(application, performActionForShortcutItem:, completionHandler:)`时的唯一标识，另外userInfo可以附加每个actions的数据，如最近听歌的歌曲id
* 当APP启动时，shortcutItems的值是上次动态添加的，如果是第一次启动则为空数组。
* Actions最多显示4个，优先显示静态Actions，然后剩余个数显示shortcutItems的前几个。



## Peek&POP 快速预览
好了，下面介绍本文重头戏，先上效果

![](http://7xiew0.com1.z0.glb.clouddn.com/3dtouch_peek.gif)


Peek窗口的内容其实是目标VC【ps即将要显示的ViewController】的一个实时快照，但它不可以点击。Peek触发阶段有三种：

* 长按【显示一个焦点视图，触发Peek的源视图高亮，其它视图都处于模糊状态】
* 轻压【显示Peek窗口，此时如果Peek窗口支持Quick Actions，往上滑会显示Quick Actions菜单，此时的Peek窗口是不可以点击的】
* 重压 【进入到真正的ViewController】

Peek由一个`可响应事件的View`触发，默认是关闭的，我们需要通过控制器的`registerForPreviewingWithDelegate: sourceView:`方法注册，第一个参数为`UIViewControllerPreviewingDelegate`的代理，Peek触发轻压时会调用其`previewingContext:viewControllerForLocation`方法，重压时会调用`previewingContext:commitViewController:`方法。第二个参数为触发Peek事件的源视图

 
```
//注册
registerForPreviewingWithDelegate(self, sourceView: userVCBtn)
```

```
//Delegate
//轻压，进入第二阶段，显示Peek窗口
func previewingContext(previewingContext: UIViewControllerPreviewing, var viewControllerForLocation location: CGPoint) -> UIViewController? {
    let userVc = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as! UserViewController
    return userVc;
}
//重压，进入第三阶段，显示真正的ViewController
func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    showViewController(viewControllerToCommit, sender: self)
}
```

如果Peek窗口需要Quick Actions菜单，在目标VC中重写`previewActionItems`方法返回一个`UIPreviewActionItem`或者一个`UIPreviewActionGroup`数组就行了。

```
//目标VC
lazy var previewActions: [UIPreviewActionItem] = {
    func previewActionForTitle(title: String, style: UIPreviewActionStyle = .Default) -> UIPreviewAction {
        return UIPreviewAction(title: title, style: style) { previewAction, viewController in
            print("点击了\(title)") //这里是Actions响应
        }
    }
    let action1 = previewActionForTitle("关注TA",style: .Destructive) //显示红色，代表重要Action
    let action2 = previewActionForTitle("私信TA")
    //子Actioons
    let subAction1 = previewActionForTitle("微博")
    let subAction2 = previewActionForTitle("好友圈")
    let subAction3 = previewActionForTitle("QQ")
    let subAction4 = previewActionForTitle("微信")
    let groupedActions = UIPreviewActionGroup(title: "分享…", style: .Default, actions: [subAction1, subAction2,subAction3,subAction4] )
    return [action1, action2, groupedActions]
}()
override func previewActionItems() -> [UIPreviewActionItem] {
    return previewActions
}
```

####更快速的方法
上面是代码激活Peek的方式，还有更Peek的方式：直接在Storyboard中使用Segue，在Segue属性面板中把Peek & Pop 勾选上就完事了。

![](http://7xiew0.com1.z0.glb.clouddn.com/3dtouch_segue_peek.png)

使用这种方式指定我们在代码中连注册都不用，所以使用SB的项目适配3D Touch那是分分钟搞定的事，尤其在Xcode7出了`Storyboard References`后，我大 `Swift + Storyboard` 组合势必统一iOS界~

![](http://7xiew0.com1.z0.glb.clouddn.com/funny_nonono.gif)

<br/>
好了，有点小激动了，继续回到正文
<br/>

在正常情况下，Peek窗口默认显示目标VC的整个View，但在实际应用中，可能会有更多的需求，比如说二个Button Push的是同一个VC，但是需要分别显示不同的Peek窗口。

其实也很简单，我们只需要自定义一个Peek的生命周期扩展就行了，`previewingContext:viewControllerForLocation:`方法中代表Peek的开始，`previewingContext:commitViewController`代表Peek的结束，然后在目标VC中重写二个方法就行了


```
//UIViewController+PeekCycle.swift
/**
 Peek生命周期
**/
extension UIViewController {
    //开始peek，VC为Peek显示做初始化
    func beginPeek(){}
    //结束peek,VC为真正显示做初始化
    func endPeek(){}
}
```


```
//Delegate
func previewingContext(previewingContext: UIViewControllerPreviewing, var viewControllerForLocation location: CGPoint) -> UIViewController? {
    let detailVc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
    //指定Peek窗口类型
    detailVc.peekType = .Image
    //设置Peek的高度
    detailVc.preferredContentSize = CGSize(width: 0.0, height: 320);
    detailVc.view //先访问一下view，初始化
    detailVc.beginPeek() //peek开始
    return detailVc;
}
func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    viewControllerToCommit.endPeek()  //peek结束
    showViewController(viewControllerToCommit, sender: self)
}
```


```
//目标VC
override func beginPeek() { 
    if(peekType == .Comments){ //如果是评论则只显示评论视图
        imageView.hidden = true
    }else{ //否则显示图片
        commentsView.hidden = true
    }
}
override func endPeek() {
    if(peekType == .Comments){
        imageView.hidden = false
    }else{
        commentsView.hidden = false
    }
}
```

<b>Note</b>

 * 如果要改变Peek窗口的size可以设置目标VC的`preferredContentSize`
 * 对于直接使用`registerForPreviewingWithDelegate`注册VC的self.view，虽然可以自动注册subviews，但是如果说你的VC中不止一种视图要触发Peek，那么它会分分钟教你做人的道理。


## UITouch
高级玩法，绘图、游戏，把3D Touch发挥到极致。不过我也唔知玩也暂时没这方面需求，有需求看[官方绘图demo](https://developer.apple.com/library/prerelease/ios/samplecode/TouchCanvas/)

##参考
[Adopting 3D Touch on iPhone](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/)

[ApplicationShortcuts Demo](https://developer.apple.com/library/ios/samplecode/ApplicationShortcuts/Introduction/Intro.html#//apple_ref/doc/uid/TP40016545)

[ViewControllerPreviews Demo](https://developer.apple.com/library/ios/samplecode/ViewControllerPreviews/Introduction/Intro.html#//apple_ref/doc/uid/TP40016546)

