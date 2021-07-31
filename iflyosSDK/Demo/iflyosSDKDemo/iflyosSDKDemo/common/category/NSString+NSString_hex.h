//
//  NSString+NSString_hex.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NSString_hex)
/**
 *    @brief    字符串转换成16进制
 *
 */
+ (NSString *)hexStringFromString:(NSString *)string;
/**
 *    @brief    16进制的字符转换成字符串
 *    @param     hexString 要转换的字符串
 *    @return    返回得到的字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/*
 *  十六进制数字转字符串
 */
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;

//二进制转16进制字符串
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;
/**
 *  字符串转二进制
 */
- (NSData *) stringToHexData;

/**
 *    @brief    将二进制数据转化为用字符表示的16进制数
 *
 *    @param     data 二进制数据
 *
 *    @return    字符表示的16进制数
 */
+(NSString *)HexStringWithData:(NSData *)data;

/**
 * 字节序
 */
+(Byte)toByte:(char)c ;
@end

NS_ASSUME_NONNULL_END
