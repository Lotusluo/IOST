//
//  AlertView.h
//  AIUIPlayerRemoteSDKDemo
//
//  Created by 周经伟 on 2019/5/7.
//  Copyright © 2019 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertView : UIView

//创建通用对话框
+(UIAlertController *) createAlert:(NSArray *) textFieldNames;
@end

NS_ASSUME_NONNULL_END
