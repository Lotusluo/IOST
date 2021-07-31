//
//  LeDevice.h
//  blesdkdemo
//
//  Created by tao luo on 2021/6/7.
//  Copyright © 2021 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeDevice : NSObject

@property(nonatomic,strong) NSString *leName;
@property(nonatomic,strong) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
