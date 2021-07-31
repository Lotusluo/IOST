//
//  Mall.h
//  10_RunTime
//
//  Created by luotao on 2021/4/14.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mall<__covariant T> : NSObject

- (void)buy:(T)product;
- (T)sell;

@end

NS_ASSUME_NONNULL_END
