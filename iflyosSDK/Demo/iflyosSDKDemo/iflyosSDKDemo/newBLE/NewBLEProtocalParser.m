//
//  NewBLEProtocalParser.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/3.
//  Copyright © 2020 test. All rights reserved.
//

#import "NewBLEProtocalParser.h"
#import "NSData+hex.h"
#import "NSString+NSString_hex.h"
@implementation NewBLEProtocalParserDeviceInfoModel

@end

@implementation NewBLEProtocalParser
/**
 * 解析Ack回复
 */
-(NewBLEProtocalParserDeviceInfoModel *) parserResponseAck:(NSData *) data{
    NewBLEProtocalParserDeviceInfoModel *model = [[NewBLEProtocalParserDeviceInfoModel alloc] init];
    
    NSMutableString *hexStr = [[NSMutableString alloc] init];
    
    NSInteger clientIdLen = 0;
    NSInteger totalLen = 0;
    Byte cmd = 0;
    Byte cmdValue = 0;
    
    NSMutableData *clientIdData = [[NSMutableData alloc] init];
    NSMutableData *deviceIdData = [[NSMutableData alloc] init];
    
    Byte* dataBytes = data.bytes;
    for (int i = 0 ; i<data.length ;i++) {
        Byte byte = dataBytes[i];
        [hexStr appendFormat:@" %02X", byte];
        
        
        if (i == 0 || i == 1) {
            //header
            if (i == 0) {
                if (byte != 0x55){
                    return nil;
                }
            }else if(i == 1){
                if (byte != 0x44){
                    return nil;
                }
            }
        }else if (i == 2){
            //len
            NSString *lenHexStr = [NSData byteToHexWith:&byte len:1];
            NSString *lenStr = [NSString stringWithFormat:@"%lu",strtoul([lenHexStr UTF8String],0,16)];
            totalLen = [lenStr integerValue];
            model.len = totalLen;
        }else if (i == 3){
            // cmd
            cmd = byte;
            
        }else if (i == 4 && cmd == CMD_DEVICE_INFO){
            // clientId 长度
            NSString *clientIdLenHexStr = [NSData byteToHexWith:&byte len:1];
            NSString *clientIdLenStr = [NSString stringWithFormat:@"%lu",strtoul([clientIdLenHexStr UTF8String],0,16)];
            clientIdLen = [clientIdLenStr integerValue];
        }else if (i == data.length-1){
            // check
            model.check = byte;
        }else{
            // content
            if (cmd == CMD_RESPONSE) {
                //响应回复  0x01: 收到 SSID,PSK ｜ 0x02: 收到 device code
                if (i == 4) {
                    cmdValue = byte;
                }
            }else if (cmd == CMD_DEVICE_INFO) {
                // 发送 clientid,deviceid
                //clientId
                NSInteger clientIdTo = 4+clientIdLen;
                //deviceId
                NSInteger deviceIdTo = data.length-2;
                
                if (i <= clientIdTo) {
                    [clientIdData appendBytes:&byte length:1];
                }else if (i <= deviceIdTo) {
                    [deviceIdData appendBytes:&byte length:1];
                }
                
            }else if (cmd == CMD_LINK_STATUS) {
                // 发送联网状态 0x01: 连接路由器失败｜0x02: 连上路由器，没连接到互联网｜0x03: 连接到互联网
                if (i == 4) {
                    cmdValue = byte;
                }
            }
        }
    }
    model.cmd = cmd;
    model.cmdValue = cmdValue;
    model.clientId = [[NSString alloc] initWithData:clientIdData encoding:NSUTF8StringEncoding];
    model.deviceId = [[NSString alloc] initWithData:deviceIdData encoding:NSUTF8StringEncoding];
    model.hexString = [hexStr copy];
    return model;
}
@end
