//
//  NSObject+Model.h
//  10_RunTime
//
//  Created by Tengfei on 2017/5/13.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model1)

+(NSString*) getText;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict1:(NSDictionary *)dict;

@end
