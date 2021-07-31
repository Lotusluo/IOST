//
//  NSTimer+Addition.h
//  10_RunTime
//
//  Created by luotao on 2021/4/13.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Addition)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

+ (void)blockInvoke:(NSTimer *)timer;

@end

NS_ASSUME_NONNULL_END
