//
//  NSData+hex.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (hex)
/**
 * Data转字符串
 */
- (NSString *) dataToHexString;

//10进制转16进制
+(NSString *)ToHex:(long long int)tmpid;

//将16进制的字符串转换成NSData
+ (NSMutableData *)convertHexStrToData:(NSString *)str;

/**
 * NSData转十六进制字符串
 */
-(NSString *) byteToHex;

/**
 * byte转十六进制字符串
 */
+(NSString *) byteToHexWith:(Byte *)bytes len:(int) len;
@end

NS_ASSUME_NONNULL_END
