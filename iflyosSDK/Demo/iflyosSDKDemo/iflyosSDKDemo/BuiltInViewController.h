//
//  BuiltInViewController.h
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "UIView+UIView_alertView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BuiltInViewController : UIViewController
@property(nonatomic) URL_PATH_ENUM pageIndex;
@property(nonatomic,copy) NSString *deviceId;
@property(nonatomic,copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
