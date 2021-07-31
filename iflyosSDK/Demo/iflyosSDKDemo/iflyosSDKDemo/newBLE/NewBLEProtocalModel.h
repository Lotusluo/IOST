//
//  NewBLEProtocalModel.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//  App->设备协议组装model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewBLEProtocalModel : NSObject
/**
 *  响应
 *  ack : 指令
 *  0x01 : 收到 link 状态帧
 *  0x02 : 收到 clientId, deviceId
 */
-(NSData *) payAck:(Byte *) ack;

/**
 *  ssid组装字节序
 *  ssid : wifi ssid
 *  psk :wifk psk
 */
-(NSData *) paySsidAndPsk:(NSString *) ssid psk:(NSString *) psk;

/**
 * 发送deviceCode
 * deviceCode: 设备deviceCode
 */
-(NSData *) payDeviceCode:(NSString *) deviceCode;
@end

NS_ASSUME_NONNULL_END
