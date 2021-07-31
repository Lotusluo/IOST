//
//  NSTimer+Addition.h
//  10_RunTime
//
//  Created by luotao on 2021/4/13.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}
@end
