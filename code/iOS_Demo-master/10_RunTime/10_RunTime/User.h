//
//  UserModel.h
//  10_RunTime
//
//  Created by Tengfei on 2017/5/13.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface User : NSObject

@property (nonatomic) int uid;

@property (nonatomic) NSString* name;

@property (nonatomic) NSString* created;

@property NSSet *userModels; //Set<UserModel>

@end
