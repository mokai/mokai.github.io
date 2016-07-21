---
title: "我的简历"
layout: page
noDate: "true"
comments: false
share: false
footer: false
---

##龚凯
94年开发者，入坑3年，目前在广州联系电话：18565593042邮箱：865425695@qq.com

## #个人简介
学习能力强，效率高，偏处女座，对代码比较有洁癖，对产品开发细腻
向往新事物，擅长`Swift + Storyboard`敏捷开发，以及金融、音频、运动方向的产品开发

## #技能
* 精通iOS平台开发，熟练持续定位、蓝牙、音频等相关技术
* 精通Swift开发，开发过多款线上APP
* 熟练Android SDK开发，有完整的 Android 项目开发经验
* 熟悉服务端开发，如，Java、PHP
* 熟悉标准SQL语句，使用过MySQL、Oracle、SQLite
* 熟悉一些前端技术 HTML、CSS、JavaScript 等，以及VueJs相关框架
* 熟练使用 Git 等版本控制工具

## #理想团队
在乎代码质量，热爱发现新技术
最好是移动互联网团队，有`大牛`

## #项目

###个人作品
[简单理财](https://itunes.apple.com/cn/app/jian-dan-li-cai-li-cai-ji/id1092941459?l=en&mt=8)
简单理财，实时关注热门可靠的理财产品。
简洁实用的收益计算器，收益与投资时长早知道。

客户端采用Swift开发，服务端基于LeanCloud云平台开发，因为有爬虫相关需求，所以用了Python语言。
项目中负责移动iOS端开发，以及产品的Idea与界面设计。

###公司项目
[美骑](https://itunes.apple.com/cn/app/id852965719)
美骑app是一款互联网自行车服务平台，提供从资讯、网上购物到线下活动等一站式全面服务。

项目中多处地方使用Hybrid开发模式，如资讯详情、车辆详情等页面，配合`WebViewJavascriptBridge`库来实现Native与Web的交互。另外论坛采用原生写的，所以有使用到Core Text相关技术。
在该项目中负责找车、路线库、广告系统等模块以及资讯与论坛的一些性能优化工作。

[美骑租车商家版](https://itunes.apple.com/cn/app/mei-qi-zu-che-shang-jia-ban/id1096502499?mt=8)
美骑租车，山地车租赁服务平台。

项目使用Swift + 模块化Storyboard敏捷开发，基于Alamofire网络库使用AOP的方式实现自动会话操作，使用FDStackView兼容UIStackView在iOS9以下使用。
因为项目规模不大，所以独立开发这个项目。

[兔子骑行](https://itunes.apple.com/cn/app/tu-zi-qi-xing-qi-xing-ji-lu/id1062196764?mt=8)
实时记录骑行途中的速度、里程、海拔骑行轨迹，致力于打造专业的骑行工具应用。

基于实时GPS坐标和气压计传感器工作，利用各种算法来保证数据的准确性。采用缓存文件与压缩文件优化方式来保存轨迹以保证数据与后台的同步。以及基于JBChartView定制的图表显示统计数据
负责历史轨迹模块，轨迹数据的缓存与下载、以及整个车队模块。

[落网](https://itunes.apple.com/cn/app/luo-wang/id788474943)
一个做了十余年个性化独立音乐推荐的平台。

由于是一款音乐APP，所以对音频处理上要求比较高，使用了AudioQueue。另外牵涉有国际化与支付相关的技术。
负责v3到v4版本迭代，其中包括把底层音频处理从AVPlayer迁移到AudioQueue上面、国际化支持、新一代iPhone设备的适配、增加社区版块、感谢支付等功能。

[emo](https://itunes.apple.com/cn/app/emo-ke-yi-shi-bie-qing-xu/id962633348?mt=8)
可以识别情绪的音乐APP。

独立负责整个项目，牵涉技术有面部表情以及面部登录识别技术、音频开发、多语言国际化等。

[泰麟资本-P2P理财平台](http://fir.im/tp2p)
泰麟资本是一款P2P网贷理财的平台。

使用Autolayout自动布局Masonry库构建界面、https协议以及二层token验证保证资金操作的安全、移动支付。在项目中主要担任iOS端主程开发，项目基础代码的封装，以及负责账户、资金计划功能开发，后期APP的发布上架。

[吉车宝](https://itunes.apple.com/cn/app/ji-che-bao-wo-zhi-neng-che/id967166557?mt=8&ign-mpt=uo%3D4)
帮助车主实现车辆定位，车况智能检测提醒，记录行程，驾况检测提醒。给车主营造一个安全、舒心的用车环境。

Swift+Storyboard开发，通过TCP/IP协议与后台数据交互，国际化等技术等。

难点分享：项目中用到了国际化，由于采用纯Storyboard构建界面，在切换语言时必须要重启app才可加载相应语言的资源，因为iOS未提供应用内切换语言的接口，最后是在NSBundle上的mainBundle通过AOP方式动态更改资源加载的Bundle才得以解决。

前期主要负责进行项目的重构包括UI细节调整、网络层设计模式优化、模块化解耦。后续进行版本迭代，以及支持国际化。

###外包项目
[南街村-轨迹定位](http://fir.im/hjst) 
员工管理、定位等功能

[乐满点-手机点餐](http://fir.im/diancanapp) 
定位于餐厅点菜功能，以便帮助客户快速就餐

[火线](http://fir.im/linefire) 
鞋包资讯平台

[移动外勤宝](http://www.csto.com/case/show/id:21380)
外勤宝是一款基于手机应用的外勤人员管理软件，通过手机端一方面实现对外勤人员的考勤打卡、实时定位等的全面掌控


