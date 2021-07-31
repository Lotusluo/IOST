//
//  NSObject+Model.m
//  10_RunTime
//
//  Created by Tengfei on 2017/5/13.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model1)

+(NSString*) getText{
    return @"test";
}

+ (instancetype)modelWithDict1:(NSDictionary *)dict{
    // 1.创建对应类的对象
    id objc = [[self alloc] init];
    // count:成员属性总数
    unsigned int count = 0;
   // 获得成员属性列表和成员属性数量
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        // 获取成员名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        // 获取字典的value key:属性名 value:字典的值
        id value = dict[key];
        // 获取成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 二级转换
        // value值是字典并且成员属性的类型不是字典,才需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {
            // 进行二级转换
            // 获取二级模型类型进行字符串截取，转换为类名
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            // 获取需要转换类的类对象
           Class modelClass =  NSClassFromString(propertyType);
           // 如果类名不为空则进行二级转换
            if (modelClass) {
                // 返回二级模型赋值给value
                value =  [modelClass modelWithDict1:value];
            }
        }
        if (value) {
            // KVC赋值:不能传空
            [objc setValue:value forKey:key];
        }
    }
    free(ivarList);
    // 返回模型
    return objc;
}

@end
