//
//  RegularExpressionTool.m
//  ApartmentRenting
//
//  Created by BeiYing on 2017/3/9.
//  Copyright © 2017年 BeiYing. All rights reserved.
//

#import "RegularExpressionTool.h"

@implementation RegularExpressionTool

#pragma mark -- g非空判断
+ (BOOL)validateStringNilOrEmpty:(NSString *)str{
    
    if (str == nil || [str isEqualToString:@""] || [str isEqual:[NSNull null]]) {
        return NO;
    }
    return YES;
}

+ (BOOL) validateStringHaveEmptySpace:(NSString *)string{
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return NO;
    }
    return YES;
}

+ (BOOL)validateParaStringLength:(NSString *)str MaxLength:(NSInteger)maxLength MinLength:(NSInteger)minLength{
    if (str.length < minLength || str.length > maxLength) {
        return NO;
    }
    return YES;
}

#pragma mark -- 身份证正则表达
+ (BOOL) validateIdentityCard:(NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark -- 字符串开头是字母正则表达式
+(BOOL)validateMatchLetter:(NSString *)str{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

#pragma mark -- 邮箱地址正则表达式
+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark -- 手机号码正则表达式
// 判断电话号码格式
+ (BOOL)validateMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|8[56]|7[0-9])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -- 网址链接正则表达式
+ (BOOL)validateHttpRequestUrl:(NSString *)url{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:url];
}

#pragma mark -- 护照正则表达
+ (BOOL)validatePassportNumber:(NSString *)number{
    
    
    /** 第一位是字母，后面都是数字
     
     P:P开头的是因公普通护照
     D:外交护照是D开头
     E: 有电子芯片的普通护照为“E”字开头，
     S: 后接8位阿拉伯数字公务护照
     G:因私护照G开头
     14：
     15：
     
     H:香港特区护照和香港公民所持回乡卡H开头,后接10位数字
     M:澳门特区护照和澳门公民所持回乡卡M开头,后接10位数字
     */
    NSString *regex = @"^1[45][0-9]{7}|([P|p|S|s]\\d{7})|([S|s|G|g]\\d{8})|([Gg|Tt|Ss|Ll|Qq|Dd|Aa|Ff]\\d{8})|([H|h|M|m]\\d{8，10})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:number];
}

#pragma mark -- 车牌号验证
+ (BOOL)validateCarNumber:(NSString *)number{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:number];
}

#pragma mark -- 验证码
+ (BOOL)validateVerifyCode:(NSString *)verifyCode{
    NSString *regex = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

#pragma mark -- 用户名
+ (BOOL)validateUserName:(NSString *)userName{
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:userName];
}
#pragma mark -- 密码
+ (BOOL)validatePassword:(NSString *)password{
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}
#pragma mark -- 密码强度
+ (BOOL)validatePasswordStrength:(NSString *)password{
    NSString *regex = @"^(?=.*\\d.*)(?=.*[a-zA-Z].*).{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:password];
}
#pragma mark -- 昵称
+ (BOOL)validateNickName:(NSString *)nickName{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [predicate evaluateWithObject:nickName];
}
#pragma mark -- 银行卡号
+ (BOOL) validateBankCardNumber:(NSString *)bankCardNumber{
    NSString *regex = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
#pragma mark -- 银行卡后四位
+ (BOOL)validateBankCardLastNumber:(NSString *)bankCardNumber{
    NSString *regex = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
#pragma mark -- CVN
+ (BOOL)validateCVNCode:(NSString *)cvnCode{
    NSString *regex = @"^(\\d{3})";
    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [cvnCodePredicate evaluateWithObject:cvnCode];
}

#pragma mark -- 全英文验证
+ (BOOL) validateEnglishLetter:(NSString *) target{
    NSString *reges = @"^[A-Za-z]+$";
    return [[self class] regexPatternResultWithRegex:reges TargetString:target];
}
#pragma mark -- 全大写英文验证
+ (BOOL) validateCapitalEnglishLetter:(NSString *)target{
    NSString *regex = @"^[A-Z]+$";
    return [[self class] regexPatternResultWithRegex:regex TargetString:target];
}

#pragma mark -- 全小写英文
+ (BOOL) validateLowercaseEnglishLetter:(NSString *)target{
    NSString *regex = @"^[a-z]+$";
    return [[self class] regexPatternResultWithRegex:regex TargetString:target];
}

+ (BOOL) validateNumberAndEnglishLetter:(NSString *)target{
    NSString *regex = @"^[A-Za-z0-9]+$";
    return [[self class] regexPatternResultWithRegex:regex TargetString:target];
}
#pragma mark -- 英文数字组成
//最终正则匹配结果
+ (BOOL)regexPatternResultWithRegex:(NSString *)regex TargetString:(NSString *)targetString{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:targetString];
}


@end
