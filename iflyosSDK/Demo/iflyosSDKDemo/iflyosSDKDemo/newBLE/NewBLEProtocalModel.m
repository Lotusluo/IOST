//
//  NewBLEProtocalModel.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//

#import "NewBLEProtocalModel.h"
#import "NSData+hex.h"
#import "NSString+NSString_hex.h"
@interface NewBLEProtocalModel()
@end

@implementation NewBLEProtocalModel

/**
 *  响应
 *  ack : 指令
 *  0x01 : 收到 link 状态帧
 *  0x02 : 收到 clientId, deviceId
 */
-(NSData *) payAck:(Byte *) ack{
    NSMutableData *outData = [[NSMutableData alloc] init];
    //头
    Byte header[] = {0x55,0x44};
    [outData appendBytes:header length:2];
    
    //长度
    
    //字段总长度
    NSInteger totalLen = 2+1+1+1+1;
    NSString *totalLenStr = [NSData ToHex:totalLen];
    unsigned long totalLenHex = strtoul([totalLenStr UTF8String],0,16);
    
    Byte len[] = {totalLenHex};
    [outData appendBytes:len length:1];
    
    //cmd
    Byte cmd[] = {0x00};
    [outData appendBytes:cmd length:1]; // ssid长度
    
    //content
    
    [outData appendBytes:ack length:1];
    
    //check
    Byte sume = 0;
    Byte* dataBytes = outData.bytes;
    for (int i = 0 ; i<outData.length ;i++) {
        Byte byte = dataBytes[i];
        sume = sume+byte;
    }
    sume = sume & 0xFF;
    Byte check[] = {sume};
    [outData appendBytes:check length:1];
    return outData;
}

-(NSData *) paySsidAndPsk:(NSString *) ssid psk:(NSString *) psk{
    NSMutableData *outData = [[NSMutableData alloc] init];
    //头
    Byte header[] = {0x55,0x44};
    [outData appendBytes:header length:2];
    
    NSData *ssidData =[ssid dataUsingEncoding:NSUTF8StringEncoding];
    NSData *pskData =[psk dataUsingEncoding:NSUTF8StringEncoding];
    //长度
    NSInteger ssidLen = ssidData.length;
    NSString *ssidLenStr = [NSData ToHex:ssidLen];
    //十六进制SSID长度
    unsigned long ssidLenHex = strtoul([ssidLenStr UTF8String],0,16);
    //字段总长度
    NSInteger totalLen = 2+1+1+1+1+ssidData.length+psk.length;
    NSString *totalLenStr = [NSData ToHex:totalLen];
    unsigned long totalLenHex = strtoul([totalLenStr UTF8String],0,16);
    
    Byte len[] = {totalLenHex};
    [outData appendBytes:len length:1];
    
    //cmd
    Byte cmd[] = {0x01};
    [outData appendBytes:cmd length:1]; // ssid长度
    
    //content
    //SSID长度
    Byte contentSsidLen[] = {ssidLenHex};
    [outData appendBytes:contentSsidLen length:1];
    //SSID数据
    [outData appendBytes:ssidData.bytes length:ssidData.length];
    //psk数据
    [outData appendBytes:pskData.bytes length:pskData.length];
    
    
    //check
    Byte sume = 0;
    Byte* dataBytes = outData.bytes;
    for (int i = 0 ; i<outData.length ;i++) {
        Byte byte = dataBytes[i];
        sume = sume+byte;
    }
    sume = sume & 0xFF;
    Byte check[] = {sume};
    [outData appendBytes:check length:1];
    
//    if (outData) {
//        printf("字节序: [");
//        for (int j = 0; j < outData.length; ++j)
//        {
//            printf(" %02X", ((UInt8 *) outData.bytes)[j]);
//        }
//        printf(" ]\n");
//    }
    return outData;
}

/**
 * 发送deviceCode
 */
-(NSData *) payDeviceCode:(NSString *) deviceCode{
    NSMutableData *outData = [[NSMutableData alloc] init];
    //头
    Byte header[] = {0x55,0x44};
    [outData appendBytes:header length:2];
    
    //长度
    NSInteger deviceCodeLen = deviceCode.length;
    NSString *deviceCodeLenStr = [NSData ToHex:deviceCodeLen];
    //十六进制SSID长度
    unsigned long deviceCodeLenHex = strtoul([deviceCodeLenStr UTF8String],0,16);
    NSData *deviceCodeData =[deviceCode dataUsingEncoding:NSUTF8StringEncoding];
    
    //字段总长度
    NSInteger totalLen = 2+1+1+1+deviceCodeLen;
    NSString *totalLenStr = [NSData ToHex:totalLen];
    unsigned long totalLenHex = strtoul([totalLenStr UTF8String],0,16);
    
    Byte len[] = {totalLenHex};
    [outData appendBytes:len length:1];
    
    //cmd
    Byte cmd[] = {0x02};
    [outData appendBytes:cmd length:1]; // ssid长度
    
    //content
    [outData appendBytes:deviceCodeData.bytes length:deviceCodeData.length];
    
    //check
    Byte sume = 0;
    Byte* dataBytes = outData.bytes;
    for (int i = 0 ; i<outData.length ;i++) {
        Byte byte = dataBytes[i];
        sume = sume+byte;
    }
    sume = sume & 0xFF;
    Byte check[] = {sume};
    [outData appendBytes:check length:1];
    return outData;
}
@end
