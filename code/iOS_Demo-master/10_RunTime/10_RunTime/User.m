//
//  UserModel.m
//  10_RunTime
//
//  Created by Tengfei on 2017/5/13.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"created" : @"created1",@"userModels" : @"attachments"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attachments" : @"UserModel" };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    id timestamp = dic[@"timestamp"];
    if([timestamp isKindOfClass:NSNumber.class]){
        NSLog(@"haha");
    }
    
    return NO;
}

@end
