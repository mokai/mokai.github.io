---
layout: post
title: "蓝牙编程"
date: 2015-09-08
comments: true
categories: 记录
tags: "蓝牙"
---

蓝牙技术，很早以前就被有了，如今已更新4.0版本。很多热门技术都是基于它工作的，如Android平台的NFC，iOS的iBeancon，Apple Watch的WatchConnectivity框架等，现在的智能家居基本也是基于蓝牙4.0与APP进行通信，可见蓝牙在实践工作中的重要性。在iOS中，蓝牙是基于4.0标准的，设备间低功耗通信。

<!--more-->

###核心成员

在开始前我们回忆下传统的Socket编程，里面有Server服务端与Client端的区别。那么在蓝牙编程也是如此，其中`Peripheral`外设相当于Socket编程中的Server服务端，`Central`中心相当于Client客户端(ps吐槽下，Central中心，作为服务端，不更适合吗！)

<img src = "https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBDevices1_2x.png" width=600 height=400 />

你可以理解外设是一个广播数据的设备，它开始告诉外面的世界说它这儿有一些数据，并且能提供一些服务。另一边中心开始扫描周边有没有合适的设备，如果发现后，会和外设做连接请求，一旦连接确定后，两个设备就可以传输数据了。

在iOS6之后，iOS 设备可以是外设，也可以是中心，就像Socket编程中一样，你可以是服务端也可以是客户端。

####服务(service)和特征(characteristic)   

每个蓝牙4.0的设备都是通过服务和特征来展示自己的，一个设备必然包含一个或多个服务，每个服务下面又包含若干个特征。特征是与外界交互的最小单位。比如说，智能音响设备，用服务A标识播放模块，特征A1来表示播放上一首，特征A2来表示播放下一首；服务B标识设置模块，特征B1设置彩灯颜色。这样做的目的主要为了`模块化`。

> 外设，服务，特征都有一个`UUID`来标识

上面说了设备可以是外设，也可以是中心，也就是会有二种模式  

* 本地中心 -> 远程外设   
* 本地外设 -> 远程中心 

不过在智能家居开发中，大部分硬件蓝牙都是担任外设的角色，也就是说我们应用只要扮演中心即可了。


###开始
本篇只讲述第一种模式的本地中心，远程外设端可借助 ~~[蓝牙调试神器LightBlue For Mac](https://itunes.apple.com/cn/app/lightblue/id639944780?mt=12)~~。需要了解第二种模式可以移步[创建外设](https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW1) 

> 更新：LightBlue For Mac只可以做为Central，不可以做为Peripheral，如需模拟请下载[iOS版本](https://itunes.apple.com/cn/app/lightblue-explorer-bluetooth/id557428110?mt=8)

蓝牙交互的流程大致为

> 建立中心角色 —> 扫描外设（discover）—> 发现外设后连接外设(connect) —> 扫描外设中的服务和特征(discover) —> 与外设做数据交互(explore and interact) —> 断开连接(disconnect)。

下面我们一一讲到

###建立中心角色
在本地中心角色中，使用CBCentralManager类管理，我们创建一个CBCentralManager类

```
let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
let centralMgr = CBCentralManager(delegate: self, queue: queue)
```

上面的delegate为CBCentralManagerDelegate，后续蓝牙相关的回调都会在此。Queue代表蓝牙在哪个队列里面操作，如果传入nil默认为主队列，值得注意的是后续的回调也是在传入的队列中调用的，所以如果传入的是非主线程的队列，在delegate中需要操作UI时需要手动切换到主线程

CBCentralManager对象创建后会回调到`centralManagerDidUpdateState`方法来检测蓝牙可用状态，这时我们可以提醒用户设备是否支持蓝牙，是否打开了蓝牙


###扫描外设

```
let serviceUUIDS: Array<CBUUID> = [CBUUID(string: "FFDD")]
self.centralMgr.scanForPeripheralsWithServices(serviceUUIDS, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])

//停止扫描
self.centralMgr.stopScan()
```
如果serviceUUIDS为nil则会扫描周围所有的设外设，否则只会扫描UUID匹配的外设。CBCentralManagerScanOptionAllowDuplicatesKey默认为false，表示扫描中发现过设备则跳过不回调，我们这里传入true，因为下面做外设掉线的处理时需要用到

> 传入的serviceUUIDS数组元素为CBUUID类型，千万不要传入String，后面的操作也是如此，不然会碰到很多奇葩问题

发现外设后会回调到`centralManager(central:didDiscoverPeripheral:advertisementData:RSSI:)` ，perpheral则代表着外设，我们需要保存起来，后续的对外设的操作都是基于perpheral对象的

```
func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
   for i in 0..<discoveredPeripheralers.count {
       var peripheraler = discoveredPeripheralers[i]
       if(!peripheral.identifier.isEqual(peripheraler.peripheral.identifier)){ //未发现过才保存
          discoveredPeripheralers.append(peripheraler)
       }
   }
}
```

###连接外设
```
self.centralMgr.connectPeripheral(peripheral, options: nil)
```

传入上面保存的外设对象，如果连接失败后会回调到 `centralManager(central:didFailToConnectPeripheral:error:)`，连接成功后会回调到 `centralManager(central:didConnectPeripheral:)`，这个时候我们只是连接上外设而已，还需要发现外设中的服务与特征

###发现服务与特征
外设连接成功后我们把peripheral保存好，并设置好peripheral的delegate(CBPeripheralDelegate)，然后调用discoverServices来发现服务，同扫描外设时一样，discoverServices也可以传入一个serviceUUIDs参数来只获取需要的服务

> 注意，注意，注意，重要的话说三遍。以下的回调都是CBPeripheralDelegate的了，不再是CBCentralManagerDelegate的回调

```
func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
    self.peripheral = peripheral
    self.peripheral.delegate = self
    let serviceUUIDS: Array<CBUUID> = [CBUUID(string: "FF12")]
    self.peripheral.discoverServices(serviceUUIDS)
}
```

发现服务后回调到`peripheral(peripheral:didDiscoverServices:)`，这时我们就可以访问所有发现的服务一一去发现服务下的特征

```
func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
	if(error != nil) {
	    log(error)
	    return
	}
	for item in peripheral.services {
		let service = item as! CBService
		let characteristicUUIDs: Array<CBUUID> = [CBUUID(string: "FF02"), CBUUID(string: "FF04")]
		peripheral.discoverCharacteristics(characteristicUUIDs, forService: service)  //发现特征
	}
}
```
同样特征也可以传入characteristicUUIDs数组来过滤，发现特征后回调

```
func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
    if(error != nil){
        log(error)
        return
    }
    for item in service.characteristics {
        let characteristic = item as! CBCharacteristic
        if(characteristic.properties == .Notify) { //如果特征为订阅属性则开启订阅
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
    }
}
```
每进入一次回调代表发现一个服务中的特征而不是外设所有的特征，外设、服务、特征从左至右都是上下级一对多的关系。
每个特征都有个属性，代表着它是可写、可读等，一个特征可同时拥有读写权限，如上面的订阅其实是一种订阅者模式的读取数据


###发送数据
拿到可写的特征后，通过writeValue发送数据包

```
let data = "hello".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//自动判断写特征的类型
var type: CBCharacteristicWriteType = .WithoutResponse
if(writeCharacteristic.properties == CBCharacteristicProperties.Write) {
    type = .WithResponse
}
self.peripheral!.writeValue(data, forCharacteristic: writeCharacteristic, type: type)

```

把要发送的文本转换为二进制，发送到相应的特征即可。值得注意的是第三个参数type写类型需要与特征的属性一致，其中WithoutResponse与WithResponse区别在于前者发送数据后是没有回调的，后者会回调到  `peripheral(peripheral:didWriteValueForCharacteristic:error:)` 来检测是否发送成功，如果发送数据传入的类型与特征不同时总是会失败

> 由于蓝牙的缓冲大小只有20bytes，那么如果我们发送的数据包大小不能大于20bytes，所以得分多次发送

```
func writeValue(data: NSData, withCharacteristic characteristic: CBCharacteristic) -> Bool {
    if(self.peripheral == nil) {
        return false
    }
    var didSend = false
    var sendDataIndex = 0
    let  NOTIFY_MTU = 20
    while (data.length - sendDataIndex != 0) {
   		//剩下的数据大小
        var amountToSend = data.length - sendDataIndex
        // 不能大于20bytes
        if (amountToSend > NOTIFY_MTU) {
            amountToSend = NOTIFY_MTU
        }
        let chunk = NSData(bytes: data.bytes + sendDataIndex, length: amountToSend)
        var type: CBCharacteristicWriteType = .WithoutResponse
        if(characteristic.properties == CBCharacteristicProperties.Write) {
            type = .WithResponse
        }
        self.peripheral!.writeValue(chunk, forCharacteristic: characteristic, type: type)
        sendDataIndex += amountToSend
    }
    return true
}
```

###读取数据
分为二种，直接读、订阅，顾名思义，直接读就是手动调用API读取，订阅则只要开启后，外设有消息都可以收到

直接读

```
self.peripheral!.readValueForCharacteristic(characteristic)
```
订阅

```
self.peripheral!.setNotifyValue(true, forCharacteristic: characteristic)
```

两种回调都会回调到 `peripheral(peripheral:didUpdateValueForCharacteristic:error:)`，上面也提到因为蓝牙的缓冲大小，需要发送多次，那么在读取时也需要接收多次，才能保证数据的一体性，所以通常都会在数据包的开始用 `EOM` 来标识一段数据的开始，数据结束后再次用 `EOM` 来标识，所以我们接收数据时会这样


```
let updatingEOMFlag = "EOM"
func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
    if(error != nil) {
        log(error)
        return
    }
    if(characteristic.value != nil) {
        var data = characteristic.value!
        var string = NSString(data: data, encoding: NSUTF8StringEncoding)
        log(string)
        
        //接收多段数据
        if(self.updatingEOMFlag != nil) {
            if(self.updatingEOMFlag == string) {
                var EOMEndFlag = false
                for i in 0..<self.updatingDatas.count { //数据结束
                    var updatingData = self.updatingDatas[i]
                    if(updatingData.characteristic.UUID.isEqual(characteristic.UUID)) {
                        data = updatingData.data
                        string = NSString(data: data, encoding: NSUTF8StringEncoding)
                        self.updatingDatas.removeAtIndex(i) //删除缓存数据
                        EOMEndFlag = true
                        break
                    }
                }
                if(!EOMEndFlag) {//数据开始
                    let updatingData = UpdatingDataer(characteristic: characteristic, data: NSMutableData())
                    self.updatingDatas!.append(updatingData)
                    return
                }
            } else {
                if var updatingData = (self.updatingDatas?.filter{ $0.characteristic.UUID.isEqual(characteristic.UUID) }) where updatingData.count == 1 && updatingData[0].data != nil { //数据中间
                    updatingData[0].data.appendData(data)
                    return
                }
            }
        }
        //在此最终得到完整数据
        let stringData = StringData(string: string as? String, data: data)

        //触发delegate与通知回调
        ...
    }
}
```

###断开连接

```
self.centralMgr.cancelPeripheralConnection(self.peripheral!)
```

至此，整个流程就完了


###高级需求~

####外设掉线检测
所谓掉线就是外设发现了后，过了一段时间失去信号了。喵了下系统框架，没有找到相关外设掉线的检测，唯一有点像的就是发现外设里面的RSSI,代表设备信号强度，值越小信息越好。

###总结
* 在蓝牙交互的二种角色中，通常APP端扮演`中央Central`的角色，设备扮演`外设Peripheral`的角色
* 创建CBCentralManager对象时传入的Queue决定了后续CBCentralManagerDelegate、CBPeripheralDelegate等回调的所在线程
* 一个外设设备可包含一个或多个服务，一个服务可包含一个或多个特征，读写操作最终是针对特征。
* 蓝牙的缓冲大小只有20bytes，在发送数据时最多只能发送20bytes，所以得分多次发送，数据的一体性可以用 EOM 标识符表标识

>  更新: 提供了一个读写的[Central端Demo](https://github.com/mokai/BluetoothDemos)，Peripheral端请用上述iOS版LightBlue模拟

###参考

[Core Bluetooth Programming Guide](https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)

[译-iOS蓝牙编程指南](http://www.jianshu.com/p/760f042a1d81)


###小小广告
本人目前是一名自由职业者，接受移动两端的项目开发，如果你有需求或者有资源请速与我联系吧，QQ865425695

