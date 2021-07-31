//
//  WifiInfo.m
//  blesdkdemo
//
//  Created by tao luo on 2021/6/8.
//  Copyright © 2021 shen. All rights reserved.
//

#import "WifiInfo.h"

@implementation WifiInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  
}

-(Byte) getEncryption{
    NSString *lowrcaseFlag = [self.flags lowercaseString];
    if([lowrcaseFlag containsString:@"wpa"]){
        return 0x01;
    }
    if([lowrcaseFlag containsString:@"wep"]){
        return 0x02;
    }
    return 0x00;
}

@end
