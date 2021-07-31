//
//  NewBLEProtocalParser.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/3.
//  Copyright © 2020 test. All rights reserved.
//  BLE->App协议解析

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (Byte,NEW_BLE_CMD){
    CMD_RESPONSE = 0x10,//响应回复  0x01: 收到 SSID,PSK ｜ 0x02: 收到 device code
    CMD_DEVICE_INFO = 0x11, // 发送 clientid,deviceid
    CMD_LINK_STATUS = 0x12 // 发送联网状态 0x01: 连接路由器失败｜0x02: 连上路由器，没连接到互联网｜0x03: 连接到互联网
};

@interface NewBLEProtocalParserDeviceInfoModel : NSObject
@property(copy,nonatomic) NSString *clientId;
@property(copy,nonatomic) NSString *deviceId;
@property(copy,nonatomic) NSString *hexString; //打印十六进制字符串

@property(assign,nonatomic) NSInteger len; //总长度

@property(assign,nonatomic) Byte cmd; //命令
@property(assign,nonatomic) Byte cmdValue; //命令值(0x10和0x12才可用)

@property(assign,nonatomic) Byte check;
@end

@interface NewBLEProtocalParser : NSObject
/**
 * 解析Ack回复
 */
-(NewBLEProtocalParserDeviceInfoModel *) parserResponseAck:(NSData *) data;
@end

NS_ASSUME_NONNULL_END
