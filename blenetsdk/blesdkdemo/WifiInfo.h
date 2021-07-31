//
//  WifiInfo.h
//  blesdkdemo
//
//  Created by tao luo on 2021/6/8.
//  Copyright © 2021 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiInfo : NSObject

@property(nonatomic,copy) NSString *ssid;
@property(nonatomic,copy) NSString *bssid;
@property(nonatomic,copy) NSString *flags;

-(Byte) getEncryption;

@end

NS_ASSUME_NONNULL_END
