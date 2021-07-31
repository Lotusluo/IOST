//
//  LeDevice.m
//  blesdkdemo
//
//  Created by tao luo on 2021/6/7.
//  Copyright © 2021 shen. All rights reserved.
//

#import "LeDevice.h"

@implementation LeDevice

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    LeDevice *otherInfo = (LeDevice*) other;
    return [self.identifier isEqualToString:otherInfo.identifier];
}

@end
