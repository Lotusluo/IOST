//
//  AlertView.m
//  AIUIPlayerRemoteSDKDemo
//
//  Created by 周经伟 on 2019/5/7.
//  Copyright © 2019 iflytek. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

//创建通用对话框
+(UIAlertController *) createAlert:(NSArray *) textFieldNames{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"参数" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //定义输入框；
    int i = 0;
    for (NSString *placeHolder in textFieldNames) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder;
            textField.tag = i;
        }];
        i++;
    }
    return alertController;
}
@end
