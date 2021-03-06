//
//  BttenUtils.m
//  freeuse
//
//  Created by whbt_mac on 16/4/23.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTUtils.h"
#import<CommonCrypto/CommonDigest.h>


@implementation BTUtils



+(BOOL)isEmpty:(NSString*)str{
    
    if (![str isKindOfClass:NSString.class]) {
        return YES;
    }
    
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
    
}



+(UIImage*)circleImage:(UIImage*)image {
    
    
    CGRect rectClip;
    
    if (image.size.width>image.size.height) {
        rectClip=CGRectMake(image.size.width/2-image.size.height/2, 0, image.size.height,image.size.height);
    }else{
        rectClip=CGRectMake(0, image.size.height/2-image.size.width/2, image.size.width, image.size.width);
    }
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rectClip);
    UIImage * clipImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    
    
    
    UIGraphicsBeginImageContext(clipImage.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:0.1871 blue:0.3886 alpha:0].CGColor);
    
    CGRect rect=CGRectMake(0, 0, clipImage.size.width, clipImage.size.width);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [clipImage drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}

+(void)setAppIconNotifiNum:(NSString*)num{
    // 应用程序右上角数字
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber =num.intValue;
}



+(CGFloat)calculateStrHeight:(NSString*)str width:(CGFloat)width font:(UIFont*)font{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize labelSize =[str boundingRectWithSize:CGSizeMake(width, 1500) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    return labelSize.height;
}

+(CGFloat)calculateLabelHeight:(UILabel*)label{
    return [self calculateStrHeight:label.text width:label.frame.size.width font:label.font];
}

+(CGFloat)calculateStrWidth:(NSString*)str height:(CGFloat)height font:(UIFont*)font{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize labelSize =[str boundingRectWithSize:CGSizeMake(1500, height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    return labelSize.width;
}
+(CGFloat)calculateLabelWidth:(UILabel*)label{
    return [self calculateStrWidth:label.text height:label.frame.size.height font:label.font];
}

+(NSString *)translationArabicNum:(NSInteger)arabicNum{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+(NSString *)getVersion{
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
}


+(NSDate*)getCurrentDateWithSystemTimeZone{
    NSDate * currentDate=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate dateByAddingTimeInterval: interval];
    return localeDate;
}

+(NSDate*)getDateFromStr:(NSString*)dateStr formatter:(NSString*)formatterStr{
    
    NSDate * result;
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=formatterStr;
    result=[formatter dateFromString:dateStr];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    
    result=[result dateByAddingTimeInterval:interval];
    
    return result;
}

+(BOOL)isFutureTime:(NSDate*)date{
    
    NSDate * localeDate=[self getCurrentDateWithSystemTimeZone];
    
    NSDate * resultDate=[localeDate laterDate:date];
    
    if ([resultDate isEqualToDate:localeDate]) {
        return NO;
    }
    
    return YES;
}

+(NSString*)getTimeFromNowStr:(NSString*)dateString{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:dateString];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    int second=cha;
    int minute=second/60;
    int hour=minute/60;
    int day=hour/24;
    if (day!=0) {
        if (day>30) {
            return [NSString stringWithFormat:@"%d月前",day/30];
        }
        
        if (day>365) {
            return [NSString stringWithFormat:@"%d年前",day/365];
        }
        
        return [NSString stringWithFormat:@"%d天前",day];
    }
    if (hour!=0) {
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    if (minute!=0) {
        return [NSString stringWithFormat:@"%d分钟前",minute];
    }
    return @"刚刚";
}


+(NSString*)getCurrentTime:(NSString*)formatter{
    NSDate *senddate=[NSDate date];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: senddate];
    //    NSDate *localDate = [senddate dateByAddingTimeInterval: interval];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:formatter];
    //    [dateformatter setTimeZone:zone];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

+(NSString*)getCurrentTime{
    return [self getCurrentTime:@"YYYY-MM-dd HH:mm:ss"];
}

+(NSString*)convertSecToTime:(int)second{
    int h=0;
    int m=0;
    int s=0;
    
    if (second%3600==0) {
        h=second/3600;
        return [self convertSecToTimeStr:h minute:m second:s];
    }
    h=second/3600;
    int secondMinute=second%3600;
    
    if (secondMinute%60==0) {
        m=secondMinute/60;
        return [self convertSecToTimeStr:h minute:m second:s];
    }
    
    m=secondMinute/60;
    s=secondMinute%60;
    
    return [self convertSecToTimeStr:h minute:m second:s];
}

+(NSString*)convertSecToTimeStr:(int)h minute:(int)minute second:(int)second{
    NSString * hstr=h<10?[NSString stringWithFormat:@"0%d",h]:[NSString stringWithFormat:@"%d",h];
    
    NSString * mstr=minute<10?[NSString stringWithFormat:@"0%d",minute]:[NSString stringWithFormat:@"%d",minute];
    
    NSString * sstr=second<10?[NSString stringWithFormat:@"0%d",second]:[NSString stringWithFormat:@"%d",second];
    if (h==0) {
        return [NSString stringWithFormat:@"%@:%@",mstr,sstr];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",hstr,mstr,sstr];
    
}

+(NSString*)getString:(NSDictionary*)dict withKey:(NSString*)key{
    //不存在该KEY就返回nil
    if (![dict.allKeys containsObject:key]) {
        NSLog(@"该字典没有对应的key:%@",key);
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
}

+ (NSDictionary *)convertJsonToDict:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)convertDictToStr:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}


+(NSString*)getHomePath{
    return NSHomeDirectory();
}



+(NSString*)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


+(NSString*)getCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


+(NSString*)getLibraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


+(NSString*)getTmpPath{
    NSString *path = NSTemporaryDirectory();
    return path;
}


+(BOOL)isFileExit:(NSString*)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


+(void)deleteFile:(NSString*)path{
    if ([self isFileExit:path]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"删除%@出错:%@",path,error.domain);
        }
    }
}


+(void)copyFile:(NSString*)filePath toPath:(NSString*)path isOverride:(BOOL)overrid{
    NSFileManager * mananger=[NSFileManager defaultManager];
    if (overrid) {
        [self deleteFile:filePath];
    }else{
        if ([self isFileExit:path]) {
            return;
        }
    }
    [self deleteFile:path];
    
    NSString * parentPath=[path stringByDeletingLastPathComponent];
    if (![self isFileExit:parentPath]) {
        [self createPath:parentPath];
    }
    
    NSError * error;
    [mananger copyItemAtPath:filePath toPath:path error:&error];
    if (error) {
        NSLog(@"复制%@出错:%@",path,error.domain);
    }
}


+(void)createPath:(NSString*)path{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager=[NSFileManager defaultManager];
        NSString * parentPath=[path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
        
    }
}

+(void)createDocumentPath:(NSString*)path{
    NSString *pathRestul=[NSString stringWithFormat:@"%@/%@",[self getDocumentPath],path];
    [self createPath:pathRestul];
}


+(NSString*)saveFile:(NSString*)path withFileName:(NSString*)name withData:(NSData*)data{
    return [self saveFile:path withFileName:name withData:data isCover:NO];
}

+(NSString*)saveFile:(NSString*)path withFileName:(NSString*)name withData:(NSData*)data isCover:(BOOL)cover{
    [self createPath:path];
    NSData * resultData=nil;
    NSString * resultPath=[NSString stringWithFormat:@"%@/%@",path,name];
    if ([self isFileExit:resultPath]&&cover) {
        NSMutableData * dataOri=[NSMutableData dataWithContentsOfFile:resultPath];
        [dataOri appendData:data];
        resultData=dataOri;
    }else{
        resultData=data;
    }
    
    [[NSFileManager defaultManager] createFileAtPath:resultPath contents:resultData attributes:nil];
    
    return [NSString stringWithFormat:@"%@/%@",path,name];
}

+(NSString*)getCachePic{
    NSString * pic=[NSString stringWithFormat:@"%@/pic",[self getCachePath]];
    if (![self isFileExit:pic]) {
        [self createPath:pic];
    }
    
    return pic;
}
+(NSString*)getCacheVideo{
    
    NSString * video =[NSString stringWithFormat:@"%@/video",[self getCachePath]];
    if (![self isFileExit:video]) {
        [self createPath:video];
    }
    
    return video;
}

+(NSString*)getCacheVoice{
    NSString * voice=[NSString stringWithFormat:@"%@/voice",[self getCachePath]];
    if (![self isFileExit:voice]) {
        [self createPath:voice];
    }
    return voice;
}




+(NSString*)createJsStr:(NSString*)name,...{
    NSString*result=name;
    NSString*ns;
    va_list arg_list;
    va_start(arg_list, name);
    result=[result stringByAppendingString:@"("];
    
    while ((ns = va_arg(arg_list, NSString*))) {
        result=[result stringByAppendingString:@"'"];
        result=[result stringByAppendingString:ns];
        result=[result stringByAppendingString:@"'"];
        result=[result stringByAppendingString:@","];
    }
    NSString*fir=[result substringFromIndex:result.length-1];
    if (![fir isEqualToString:@"("]) {
        result=[result substringToIndex:result.length-1];
    }
    result=[result stringByAppendingString:@");"];
    va_end(arg_list);
    NSLog(@"%@",[NSString stringWithFormat:@"调用的JS方法:%@",result]);
    return result;
}





+(NSString*)base64Decode:(NSString*)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
+(NSString*)base64Encode:(NSString*)str{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
+(NSString*)MD5:(NSString*)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    
    
    
    return  output;
}



@end
