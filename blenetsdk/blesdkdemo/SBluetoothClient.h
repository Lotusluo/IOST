//
//  BluetoothClient.h
//  blesdkdemo
//
//  Created by tao luo on 2021/6/7.
//  Copyright © 2021 shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LeDevice.h"
#import "WifiInfo.h"

NS_ASSUME_NONNULL_BEGIN

//搜索设备回调
typedef void(^onScanResult)(LeDevice *  _Nullable);
//连接设备回调
typedef void(^onConnectResult)(NSInteger);
//获取WIFI列表回调
typedef void(^onWifiResult)(NSArray<WifiInfo *> *);
//配网状态回调
typedef void(^onLinkResult)(NSInteger);


@interface SBluetoothClient : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

//蓝牙单例模式
+ (SBluetoothClient*)sharedInstance;

//初始化SDK
- (void)initSDK;

//开始扫描
- (void) startScan:(onScanResult) callback;

//停止扫描
- (void) stopScan;

//开始连接
-(void) connect:(LeDevice *) device connectResult:(onConnectResult) callback;

//获取可用的WIFI列表
-(void) getWifiList:(onWifiResult) callback;

//开始配网
-(void) link:(WifiInfo *) wifiInfo password:(NSString*)pwd linkResult:(onLinkResult) callback;

//关闭连接
-(void) close;

-(NSString*) ssid;


@end

NS_ASSUME_NONNULL_END
