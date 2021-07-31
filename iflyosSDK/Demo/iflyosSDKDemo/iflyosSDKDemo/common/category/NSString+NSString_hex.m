//
//  NSString+NSString_hex.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//

#import "NSString+NSString_hex.h"

@implementation NSString (NSString_hex)
/**
 *    @brief    字符串转换成16进制
 *
 */
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];//16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

/**
 *    @brief    16进制的字符转换成字符串
 *
 *    @param     string     要转换的字符串
 *
 *    @return    返回得到的字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for(int i = 0; i < [hexString length] - 1; i += 2){
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

/*
 *  十六进制数字转字符串
 */
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    
    return hexString;
}

/**
 *  字符串转二进制
 */
- (NSData *) stringToHexData
{
    int len = [self length] / 2;    // Target length
    unsigned char *buf = (unsigned char *)malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};

    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }

    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

/**
 *    @brief    将二进制数据转化为用字符表示的16进制数
 *
 *    @param     data 二进制数据
 *
 *    @return    字符表示的16进制数
 */
+(NSString *)HexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}

//二进制转16进制字符串
+(NSString *) parseByteArray2HexString:(Byte[]) bytes{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        
        while (bytes[i] != '\0')
            
        {
            
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            
            if([hexByte length]==1)
                
                [hexStr appendFormat:@"0%@", hexByte];
            
            else
                
                [hexStr appendFormat:@"%@", hexByte];
            
            
            
            i++;
            
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}

+(Byte)toByte:(char)c {
    Byte b = (Byte)[@"0123456789ABCDEF" rangeOfString:[NSString stringWithFormat:@"%c", c]].location;
    return b;
}
@end
