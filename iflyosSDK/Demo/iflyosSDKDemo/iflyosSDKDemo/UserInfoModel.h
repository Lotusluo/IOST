//
//  UserInfoModel.h
//  iflyosSDKDemo
//
//  Created by admin on 2018/11/13.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
@property(nonatomic) NSInteger _id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSArray *phones;
@end

NS_ASSUME_NONNULL_END
