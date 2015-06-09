---
layout: post
title: "使用Swift&Xcode6为iOS应用做国际化"
date: 2015-05-20
comments: true
share: true
categories: 记录
tags: "国际化"
---

在真正将国际化实践前，只知道通过`NSLocalizedString`将相应语言的字符串加载进来即可。但最近公司项目的新需求增加英文版本，并支持应用内无死角切换~，这才跳过各种坑实现了应用内切换语言，并记录至此。

<!--more-->

###环境
系统环境: iOS7 - iOS8.3

开发环境: Swift1.2 & Xcode6.3.2

DEMO: [LocalDemo](https://github.com/mokai/LocalDemo)

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_0.gif)

这个Demo的功能主要是切换语言后相应的界面文字&图片以及搜索引擎都会随语言变化。我们会围绕这个DEMO进行讲解，读者可以先下载这个Demo运行看下效果再往下

<br/>


###iOS国际化原理分析	

国际化其实都大同小异，其核心思想就是`为每种语言单独定义一份资源`。

iOS就是通过`xxx.lproj`目录来定义每个语言的资源，这里的资源可以是图片，文本，storyboard，xib等。我们可以看看LocalDemo源代码的物理目录结构

Base，暂时无需理会

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_1.png)

English

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_1_1.png)

中文

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_1_2.png)

每种语言都有自己的 [语言代码](http://www.lingoes.cn/zh/translator/langcode.htm).lproj文件夹，加载资源时只需要加载相应语言文件夹下的资源就OK，这步可以系统为我们完成，也可以手动去做。
> 项目源代码中如果有多个不同目录的国际化资源，则会有产生多个xxx.lproj，但在编译打包后，会集中放在app的根目录中的xxx.lproj中，不信你看~

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_1_3.png)

###开始国际化

首先点击项目->PROJECT->Info->Localizations中添加要支持的语言

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_2.png)
> 此处Use Base Internationalization开启状态下，每个国际化资源文件会有个Base选项，主要针对string，storyboard，xib作为一个基础的模板，像后述[storyboard国际化中方案二](#storyboard_2)就是基于Base StoryBoard进行改动。

在点击`+` 添加相应语言时会弹出以下对话框，意思是为现有的资源添加语言文件，我们点击`Finish`就行了

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_2_1.png)


###文本的国际化
主要针对代码中的字符串进行国际化，比如说一些消息，UI标题等。

我们通过一个`Localizable.strings`文件来存储每个语言的文本，它是iOS默认加载的文件，如果想用自定义名称命名，在使用`NSLocalizedString`时指定tableName为自定义名称就好了，但你的应用规模不是很大就不要分模块搞特殊了。

每个资源文件如果想为一种语言添加支持，通过其属性面板中的`Localization`添加相应语言就行了，此时`Localizable.strings`处于可展开状态，子级有着相应语言的副本。我们把相应语言的文本放在副本里面就行了

![](http://7xiew0.com1.z0.glb.clouddn.com/locale_3.png)
>此处Base与前面提过到的`开启Use Base Internationalization`是有关联的，只有开启了全局`Use Base Internationalization`此处才会显示。那为什么这里没有勾选Base？Base做为一个基础模板，作用于strings文件是没有太大意义的，另外去掉Base意义着在Base.lproj中少了一个strings文件，APP大小也所有下降，这点对于图片的base更是如此

在上图可以看到其实就是为每一套语言新建一份strings，其内容采用`"key" = "value";`的格式，注意有`;`号

我们在代码中这样写就行了
```
NSLocalizedString("首页",comment: "")
NSLocalizedString("好友",comment: "")
NSLocalizedString("我",comment: "")
```

>另外中文strings【Localizable.strings(Simplified)】可以不要的，因为key就是value，当找不到相应的语言strings或value时会直接返回key。nice！这样一来我们做文本的国际化就只要维护一个英文副本strings就O了


###图片的国际化
二种方案，通过原生支持与自定义命名

>注意，新版Xcode中Images.xcassets不支持国际化（属性页面中没有`Localization`），Xcode5以前是支持的（应该是5以前）

* 方案一：自定义文本命名

	![](http://7xiew0.com1.z0.glb.clouddn.com/locale_4.png)

	利用文本国际化的方式，在代码中调用

  ```		
  UIImage(named: NSLocalizedString("search_logo",comment: ""))
  ```

	>不推荐，一是因为做法太low了，工作量明显加大。二是不能在Storyboard或XIB中使用

* ###### 方案二：原生支持
![](http://7xiew0.com1.z0.glb.clouddn.com/locale_4_1.png)
>同上，Base副本去掉。另外需要注意的是，使用这种方式，在XIB或Storyboard中引用图片时如果只使用名称是实时显示不了的，一定要加上后缀名。如avater.png

	使用方式不变，iOS会自动找相应语言(xxx.lproj)下的图片

```
UIImage(named: "avater")
```

对于图片的放置，正确姿态应该是`需要国际化的图片放在自定义Group里面，不需要国际化的图片放在Images.xcassets`

###Storyboard&XIB的国际化

前面的两种资源国际化比较简单，但Storyboard国际化就稍微麻烦了点。同样它也有二种方案
 
 * 方案一：每种语言定制一套Storyboard
 
 	![](http://7xiew0.com1.z0.glb.clouddn.com/locale_5.png)
 	
 	在上图我们可以看到，每种语言都可以切换为strings或Storyboard（默认为strings）。如果选用`Interface Builder Storyboard`方案，那么每种语言都有一套相应的Storyboard，各个语言Storyboard间的界面改动不关联。
 	 	
 * 方案二：基于基础的`Base StoryBoard`以及每种语言一套strings <a id='storyboard_2'></a>
 
 	![](http://7xiew0.com1.z0.glb.clouddn.com/locale_5_1.png)
	
   基于一个基础的Storyboard，可以看作是一个基础的模板，Storyboard里面所有的文本类资源(如UILabel的text)都会被放在相应语言的strings里面。此时我们为Storyboard里的字符类资源作国际化只需要编辑相应语言的strings就行了
   
  
  首选方案二。因为采用方案一，意义着你每改动一个界面元素就得去相应语言Storyboard一一改动，那跟为每个语言新起一个项目是一样的道理。但是采用方案二，我们只需改动Base Storyboard就行了
   
  > 注意，方案二中相应语言的strings一旦生成后，Base Storyboard有任何编辑都不会影响到strings，这就意味着如果我们删除或添加了一个UILabel的text，strings也不能同步改动
    
  还好，xcode为我们提供了`ibtool`工具来生成Storyboard的strings文件。

```  
ibtool Main.storyboard --generate-strings-file ./NewTemp.string
```

  但是ibtool生成的strings文件是BaseStory的strings(默认语言的strings)，且会把我们原来的strings替换掉。所以我们要做的就是把新生成的strings与旧的strings进行冲突处理(新的附加上，删除掉的注释掉)，这一切可以用这个pythoy脚本来实现，见[AutoGenStrings.py](https://github.com/mokai/LocalDemo/blob/master/LocalDemo/i18n/RunScript/AutoGenStrings.py)。然后我们将借助`xcode 中 Run Script`来运行这段脚本。这样每次Build时都会保证语言strings与Base Storyboard保持一致


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


###其他
* 设置运行语言环境

  有时我们第一次安装APP时不想默认跟随系统，那么可以通过xcode的scheme来指定特定语言
  
  ![](http://7xiew0.com1.z0.glb.clouddn.com/locale_6.png)
  
* Storyboard实时预览

  直接上图~
  
  ![](http://7xiew0.com1.z0.glb.clouddn.com/locale_6_1.png)

* IB中UIImageView国际化无效
 
  解决办法就是为`UIImageView`扩展一个方法，然后通过IB中的`User Defined Runtime Attributes`把imageName传进去

  ```
  extension UIImageView{
      var locale:String{
          get{
              return ""
          }
          set(newlocale){
              self.image = localizedImage(newlocale)
          }
      }
  }
  ```

	![](http://7xiew0.com1.z0.glb.clouddn.com/locale_6_2.png)

* IB中UITextView国际化无效

	解决办法和UIImageView类似，扩展一个方法，然后把self.text做为key去strings文件中拿相应语言的value

  ```
  extension UITextView{
      var locale:Bool{
          get{
              return true
          }
          set(newlocale){
              self.text = localized(self.text)
          }
      }
  }
  ```

	![](http://7xiew0.com1.z0.glb.clouddn.com/locale_6_3.png)
	

* LaunchScreen.xib的国际化

	很遗憾，到目前为止，还不支持LaunchScreen.xib的国际化，我们只能通过自定义一个LaunchViewController来完成此需求，但也有些不足，就是应用启动时会黑屏一段时间



参考:

* [iOS国际化——通过脚本使storyboard翻译自增](http://www.cnblogs.com/levilinxi/p/4296712.html)
* [Working with Localization](https://medium.com/ios-apprentice/working-with-localization-905e4052b9de)
* [How to force NSLocalizedString to use a specific language](http://stackoverflow.com/questions/1669645/how-to-force-nslocalizedstring-to-use-a-specific-language)