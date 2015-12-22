#Swift技术分享

#前言

此Swift非彼Swift(Taylor Swift)，而是苹果官方`力推`的一种全新编程语言，翻译成中文`雨燕`，象征着`轻盈迅捷`

于2014年WWDC公诸于世，目前版本2.x，在短短的一年里已经占据`编程排行榜No.18` `GitHub第三方库数量2k+` `全民Swift热潮`

目前它可以用来编写iOS、OS X、watchOS、tvOS应用

####听TA们说段子

	 “Swift集合主流语言的特性!” - Rust之父说【简单来说就是五仁编程】
	 “Swift语言比OC顺眼多了!” -知乎网友说
	 “简单容易上手,我这个前端狗都能懂!” -知乎网友又说
	 “Swift的推出最大的受益者可 能是各种培训厂商吧...大家懂的” -知乎网友还说
	 “Scala的作者 — 看java不爽; Go的作者 — 看c不爽; Swift的作者 —看OC不爽” -知乎网友最后说

#优势
1、Swift执行速度更快，不信跑分~

![](http://leolinn.com/wp-content/uploads/2014/06/swift1.jpg)
![](http://leolinn.com/wp-content/uploads/2014/06/swift2.jpg)

2、Swift比OC更简洁易用
![在OC上](http://leolinn.com/wp-content/uploads/2014/06/swift3.jpg)
![Swift一行就搞定](http://leolinn.com/wp-content/uploads/2014/06/swift4.jpg)

3、Swift比OC更安全

4、Swift具有OC所没有的强大互动性

#特性&语法糖

1、静态语言，强大的类型推断机制

2、Playground

3、强大的语法糖带来的效率提升

*  强大的类型推断机制
*  Generic、元组、闭包、可选
*  加强版的Swift、if以及模式匹配
*  高阶函数: map, filter, reduce
*  自定义操作符、面向对象化、泛型、注释支持Markdown

4、脚本支持

#现有瑕疵
1、安装包体积的增大(大约10MB左右)，因为现阶段Swift还处于持续改善中，Swift相关核心库未集成至iOS。不过相信在Swift3.0时代这一方案会得到彻底改善

2、语言本身的持续升级，会造成升级新的Xcode时现有项目需要Convert至最新语法，不过这过程是Xcode帮我们自动进行的，并无太大成本

3、Xcode 的支持有时不完善(代码补全过慢,语法高亮失效,增量编译)，当然只是极少出现，并不影响正常Coding

4、Swift 第三方库以 framework 形式存在,最低支持 iOS 8。解决方案：可以直接拖入项目工程中




#哪些APP在使用Swift？
####国内：

网易新闻、百度输入法、美丽说、Teambition、QQ影音、搜狗浏览器、小米运动、猫眼电影、美团团购

Enjoy【出自饭本同一厂商】、开眼【来自豌豆夹的 App】、奇点、即刻



####国外： 

iOS自带输入法、WWDC、LinkedIn领英、Firefox for iOS【已开源】、雅虎天气、Duolingo多邻国


####And Have We？

#未来展望
1、开源

对于iOSer意味着了解原生库以及其实现源码，更好地去扩展原生的东西

对于其他平台粉丝
全平台编程 Window for Swift、Liunx for Swift

实现我大Swift统一编程界的远大抱负
Web for Swift、Android for Swift、Hadoop for Swift


2、OC 还是 Swift？

对于这个问题，我觉得应该抱着一个中肯的态度来看待，Swift作为苹果官方力推的编程语言，未来几年肯定是会成为iOS主流编程语言，从现在的Swift圈活跃度就可以看得出来。但是对于网上流传的Swift会把OC干掉，这种说法太极端，打个栗子，`OC的MAC与ARC就好比OC与Swift`，总有一些思想保守的或者坚持的人在默默的使用着OC。
