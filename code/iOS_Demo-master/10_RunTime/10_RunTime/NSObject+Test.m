//
//  NSObject+Test.m
//  10_RunTime
//
//  Created by mac on 2021/4/6.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSObject (Test)

+(instancetype) getInstance:(NSString*) arg1{
    return @"@@";
}

@end
