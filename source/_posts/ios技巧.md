---
layout: post
title: "iOS技巧"
date: 2015-04-17
comments: true
categories: 记录
sharing: false
---
#常用技巧
1、Xcode技巧

* 当真机升级了iOS，但对应Xcode未升级时，device会出现ineligible device，这时通过xocde菜单->Product->Destination->选择对应的device 即可解决
* 编译相关
	* .a静态库编译
	
		`lipo -info xxx.a` 查看静态库支持的平台，目前有armv7、arm64、armv7s、i386 前三者为真机平台，后者为iphone Simulator
		
		`lipo -create libXXX-armv7s.a libXXX-i138.a -output libXXX.a` 合并生成通用平台的静态库
	* 环境变量
			
		$(SRCROOT) 工程文件（比如Nuno.xcodeproj）的路径
			
		$(PROJECT_DIR) 项目目录		
* Xcode常见编译错误
	* `could not build module 'Foundation'`
	
		原因在于，在pch文件中没有把import放在`#ifdef_OBJC_`

		```
		#ifdef __OBJC__ 
		    #import <UIKit/UIKit.h> 
		    #import <Foundation/Foundation.h> 
		#endif 
		    #import "ddddd.h"  //此处移动上面 __OBJC__ 中就好了
		```

<!--more-->
* IB技巧
	* 可视化坐标距离    选中一个View，然后按住`option`并将鼠标移动到其他View上
	* 多个View层次选择 按住`Cmd`和`Shift`，然后在需要选择的view上方按右键
	* 添加辅助线  在左边的层级列表中双击某个view，然后`Cmd+_`或者`Cmd+|`即可在选中的view上添加一条水平或者垂直中心的辅助线
	

2、Frame枚举类型转换为string通过`NSStringFromCGRect`

3、指定文件不使用arc,`-fno-objc-arc`

4、OC语法简写

* NSNumber
	* [NSNumber numberWithChar:‘X’] 简写为 @‘X’;
	* [NSNumber numberWithInt:12345] 简写为 @12345
	* [NSNumber numberWithUnsignedLong:12345ul] 简写为 @12345ul
	* [NSNumber numberWithLongLong:12345ll] 简写为 @12345ll
	* [NSNumber numberWithFloat:123.45f] 简写为 @123.45f
	* [NSNumber numberWithDouble:123.45] 简写为 @123.45
	* [NSNumber numberWithBool:YES] 简写为 @YES
* NSArray
	* [NSArray array] 简写为 @[]
	* [NSArray arrayWithObject:a] 简写为 @[ a ]
	* [NSArray arrayWithObjects:a, b, c, nil] 简写为 @[ a, b, c ]
* NSDictionary
	* [NSDictionary dictionary] 简写为 @{}
	* [NSDictionary dictionaryWithObject:o1 forKey:k1] 简写为 @{ k1 : o1 }
	* [NSDictionary dictionaryWithObjectsAndKeys:o1, k1, o2, k2, o3, k3, nil] 简写为 @{ k1 : o1, k2 : o2, k3 : o3 }
	
如果想生成Mutable版本，直接调用 [@[] mutableCopy] 就行了
	
* 下标
	* [array objectAtIndex:idx] 简写为 array[idx];
	* [array replaceObjectAtIndex:idx withObject:newObj] 简写为 array[idx] = newObj
	* [dic objectForKey:key] 简写为 dic[key]
	* [dic setObject:object forKey:key] 简写为 dic[key] = newObject

5、Resource底下的plist文件需要clean才可以消除清楚

6、[NSDate date]获取的是GMT时间，和北京时间相差8个小时

7、拨打电话

```
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:466453"]];
	[[[UIWebView alloc] init] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:466453"]]];
```

8、调用照相或者相册

```
-(void)takePicture:(UIButton *)btn{
    _currentCardBtn = btn;
    IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==0) {//相册
        [self takePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex==1){//拍照
        [self takePicker:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)takePicker:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentModalViewController:picker animated:YES];
    }
    else{
        [AlertUtils showAlert:@"当前设备不支持拍摄功能"];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
    //_avatarImageView.image=chosenImage;
    //_currentCardBtn.imageView.image = chosenImage;
    [_currentCardBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [_currentCardBtn setTitle:@"" forState:UIControlStateNormal];
    
    //    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    //    {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    //        [alert show];
    //
    //    }
    [picker dismissModalViewControllerAnimated:YES];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
```
	
9、iphone程序中实现截屏的一种方法

```
	//导入头文件
	#import QuartzCore/QuartzCore.h
	//将整个self.view大小的图层形式创建一张图片image 	UIGraphicsBeginImageContext(self.view.bounds.size)；
	[self.view.layer renderInContext：UIGraphicsGetCurrentContext()]；
	UIImage*image=UIGraphicsGetImageFromCurrentImageContext()；
	UIGraphicsEndImageContext()；
	//然后将该图片保存到图片图
	UIImageWriteToSavedPhotosAlbum(image,self,nil,nil)；
```

10、启动界面的制作

 在Resource里面增加Default.png,然后在XXXAppDelegate.m里面增加 [NSThread sleepForTimeInterval:5.0];
    
11、动画

* 基于位置动画

```
CATransition *animation = [CATransition animation];
animation.duration = 0.3f;//间隔的时间
animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; ;
animation.type = kCATransitionPush;//设置上面4种动画效果
animation.subtype = kCATransitionFromLeft;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
[self.layer addAnimation:animation forKey:@"animationID"];
```

12、以使用如下代码判断开启了那些类型的消息通知：

```
UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
if (enabledTypes & UIRemoteNotificationTypeBadge) {
//开启badge number
}
if (enabledTypes & UIRemoteNotificationTypeSound) {
//开启声音
}
if (enabledTypes & UIRemoteNotificationTypeAlert) {
//开启alert
}
```

13、NSDictionary排序

```
NSMutableDictionary *dict = [@{}mutableCopy];
dict[@(1)] = @"1";
dict[@(2)] = @"2";
dict[@(3)] = @"3";
dict[@(5)] = @"4";
dict[@(4)] = @"5";
NSArray *arr = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
    NSComparisonResult result = [obj1 compare:obj2];
    return result==NSOrderedDescending;
}];
NSLog(@"%@",arr);
```

14、使用OpenURL打开设置页面

* 网路设置项

```
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];  
```

* 定位设置

```
[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
```

* 设置Twitter

```
[NSURL URLWithString:@"prefs:root=TWITTER"];
```

* 蓝牙

```
[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"];
```

* 其他

```
prefs:root=General&path=About
prefs:root=General&path=ACCESSIBILITY
prefs:root=AIRPLANE_MODE
prefs:root=General&path=AUTOLOCK
prefs:root=General&path=USAGE/CELLULAR_USAGE
prefs:root=Brightness
prefs:root=General&path=Bluetooth
prefs:root=General&path=DATE_AND_TIME
prefs:root=FACETIME
prefs:root=General
prefs:root=General&path=Keyboard
prefs:root=CASTLE
prefs:root=CASTLE&path=STORAGE_AND_BACKUP
prefs:root=General&path=INTERNATIONAL
prefs:root=LOCATION_SERVICES
prefs:root=ACCOUNT_SETTINGS
prefs:root=MUSIC
prefs:root=MUSIC&path=EQ
prefs:root=MUSIC&path=VolumeLimit
prefs:root=General&path=Network
prefs:root=NIKE_PLUS_IPOD
prefs:root=NOTES
prefs:root=NOTIFICATIONS_ID
prefs:root=Phone
prefs:root=Photos
prefs:root=General&path=ManagedConfigurationList
prefs:root=General&path=Reset
prefs:root=Sounds&path=Ringtone
prefs:root=Safari
prefs:root=General&path=Assistant
prefs:root=Sounds
prefs:root=General&path=SOFTWARE_UPDATE_LINK
prefs:root=STORE
prefs:root=TWITTER
prefs:root=General&path=USAGE
prefs:root=VIDEO
prefs:root=General&path=Network/VPN
prefs:root=Wallpaper
prefs:root=WIFI
prefs:root=INTERNET_TETHERING
```

15、`No known instance method for selector 'respondsToSelector:'   `
这种情况是声明的协议protocol没有继承NSObject导致 


#常用组件

1、UIView

* 圆角

```
outLable.layer.masksToBounds = YES;
outLable.layer.cornerRadius = 5;//如果要设置为圆，view的width与height一样，然后设置view.width/2
outLable.layer.borderWidth = 1;
outLable.layer.borderColor = TYPE_OUT
```

2、UITableView

* 去掉默认分割线  

```
list.separatorStyle = NO;
```

* UITableViewCell去掉点击效果  
	
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
* 使用UITableViewCellStyleGrouped要注意，ios6与ios7下的效果是不同的
* 显示右按钮 accessoryType
* 去掉UItableview headerview黏性(sticky)

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
```

* UITableViewCell自动滚动到顶部 

```
[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
```

* 取消选中状态 

```
NSIndexPath *selected = [_tView indexPathForSelectedRow];
if(selected) {
	[_tView deselectRowAtIndexPath:selected animated:NO];
}
```

* 选中一行
  
``` 
[self.tView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionTop];
```

* TableView不显示没内容的Cell怎么办

```
self.tView.tableFooterView = [UIView new];
```

3、UILabel

* 换行  内容加\n，然后设置label.numberOfLines = 0; 
* 文本自适应

```
m_titleLabel.font = [UIFont systemFontOfSize:20];
m_titleLabel.adjustsFontSizeToFitWidth = YES;
m_titleLabel.minimumFontSize = 6;
```

就是在空间够的情况下，使用20号字体，如果空间不够，那么就会自动将字体向下调整，但是也不会少于6号字体，
如果6号字体也显示不完，后续显示省略号。。。

* 自动高度

```
[lab setNumberOfLines:0];
lab.lineBreakMode = UILineBreakModeWordWrap;
CGSize maxSize = CGSizeMake(lab.width, SCREEN_HEIGHT - lab.top);
lab.size = [_descLab.text sizeWithFont:_descLab.font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
```

4、UITextField

* 居中 

```
field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
```

* 获得焦点  
 
```
[field becomeFirstResponder];
```

* 键盘样式
		
	* 风格:

	```
	textView.keyboardType = UIKeyboardTypeNumberPad;
	typedef  enum  {  
	    UIKeyboardTypeDefault,                 // 默认键盘：支持所有字符   
	    UIKeyboardTypeASCIICapable,            // 支持ASCII的默认键盘   
	    UIKeyboardTypeNumbersAndPunctuation,   // 标准电话键盘，支持+*#等符号   
	    UIKeyboardTypeURL,                     // URL键盘，有.com按钮；只支持URL字符   
	    UIKeyboardTypeNumberPad,               //数字键盘   
	    UIKeyboardTypePhonePad,                // 电话键盘   
	    UIKeyboardTypeNamePhonePad,            // 电话键盘，也支持输入人名字   
	    UIKeyboardTypeEmailAddress,            // 用于输入电子邮件地址的键盘   
	} UIKeyboardType;  
	```

	* 键盘外观:
	
	```
	textView.keyboardAppearance=UIKeyboardAppearanceDefault;
	typedef  enum  {  
	    UIKeyboardAppearanceDefault,     // 默认外观：浅灰色   
	    UIKeyboardAppearanceAlert,       //深灰/石墨色   
	} UIKeyboardAppearance;  
	```

	* 回车键
	
	```
	textView.returnKeyType=UIReturnKeyGo;
	typedef  enum  {  
	    UIReturnKeyDefault,  //默认：灰色按钮，标有Return
	    UIReturnKeyGo,  //标有Go的蓝色按钮
	    UIReturnKeyGoogle,  //标有Google的蓝色按钮，用于搜索
	    UIReturnKeyJoin,  //标有Join的蓝色按钮
	    UIReturnKeyNext,  //标有Next的蓝色按钮
	    UIReturnKeyRoute,  //标有Route的蓝色按钮
	    UIReturnKeySearch,  //标有Search的蓝色按钮
	    UIReturnKeySend,  //标有Send的蓝色按钮
	    UIReturnKeyYahoo,  //标有Yahoo!的蓝色按钮，用于搜索
	    UIReturnKeyDone,  //标有Done的蓝色按钮
	    UIReturnKeyEmergencyCall,  //紧急呼叫按钮
	} UIReturnKeyType;  
	```

	* 自动大写
	
	```
	textField.autocapitalizationType = UITextAutocapitalizationTypeWords
	typedef  enum  {  
	    UITextAutocapitalizationTypeNone,  //不自动大写   
	    UITextAutocapitalizationTypeWords,  //单词首字母大写   
	    UITextAutocapitalizationTypeSentences,  //句子首字母大写   
	    UITextAutocapitalizationTypeAllCharacters,  //所有字母大写   
	} UITextAutocapitalizationType;  
	```

	* 自动更正
	
	```
	textField.autocorrectionType= UITextAutocorrectionTypeYes;
	typedef  enum  {  
	    UITextAutocorrectionTypeDefault, //默认   
	    UITextAutocorrectionTypeNo, //不自动更正   
	    UITextAutocorrectionTypeYes, //自动更正   
	} UITextAutocorrectionType; 
	```

	* 安全文本输入

	```
	textField.secureTextEntry=YES;
	```
	* 显示消除图标 

	```
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	```

	* 隐藏输入法 
	
	```
	[self.view endEditing:YES];
	```

5、UIScrollView

* 去掉弹簧效果	

```
sView.bounces ＝ no;
```

* 动态改变内容区大小  contentSize 
* 隐藏滑动条

```
scrollView.showsVerticalScrollIndicator = FALSE;
scrollView.showsHorizontalScrollIndicator = FALSE;
```

6、UIApplication 

* 获取当前应用状态   `application.applicationState `

``` 
UIApplicationStateActive  
UIApplicationStateInactive 
UIApplicationStateBackground  后台
```

7、UIDatePicker
	

8、UINavigationController
	
* 设置主题颜色

```	
navCtr.navigationBar.barTintColor = app_theme_color;//背景色
navCtr.navigationBar.tintColor = [UIColor blackColor];//文字
NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
navCtr.navigationBar.titleTextAttributes = dict;
```

* 改变返回标题

```		
//在前一个页面执行
UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
self.navigationItem.backBarButtonItem = backItem;
backItem.title = @"";    

//或者
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)  forBarMetrics:UIBarMetricsDefault]; 
```

#资源
1、Xcode插件
 	
* Alcatraz  管理和发现插件
	
	* 安装 

 	```
 	curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
	```

	* 卸载 

	```
	rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
	```

	* 卸载所有插件 

	```
	rm -rf ~/Library/Application\ Support/Alcatraz
	```

	* 常用插件

		* OMColorSense 可视化设置Color
		* VVDocumenter-Xcode  生成java风格的注释
		* KSImageNamed-Xcode  可视化设置Image
		* XAlign 代码对齐

* Cocospod库管理 
	* 安装 

	```
	sudo gem install cocoapods
	```

	* 更改源

	```
	gem sources --remove https://rubygems.org/
	gem sources -a http://ruby.taobao.org/
	```

	* 基本模板
	
	```
	platform :ios, "7.0"
	inhibit_all_warnings!//pod的工程不显示任何警告
	```

	* 常用Lib
	
	```
	pod "MBProgressHUD"
	pod "SIAlertView"
	pod "FMDB"
	pod "AFNetworking"
	```

