//
//  ViewController.m
//  ThirdLoginDemo
//
//  Created by Jason on 16/8/20.
//  Copyright © 2016年 _littleBoy. All rights reserved.
//
#define kApp_CallBackUrl @"http://www.sina.com"
#define kApp_id @"101040651"

#import "ViewController.h"

/** 新浪微博*/
#import <WeiboSDK.h>

/** QQ*/
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

/**  指纹登录*/
#import <LocalAuthentication/LocalAuthentication.h>


@interface ViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    /** QQ 授权*/
//    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:kApp_id andDelegate:self];
    
    
    /** iOS 8 指纹登录*/
    [self fingerPrintLogin];
}

- (void)fingerPrintLogin
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {return;}
    
    LAContext *textContext = [LAContext new];
    NSError *authError = nil;
    if ([textContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [textContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"请输入指纹"
                              reply:^(BOOL success, NSError *error) {
                                  if (success) {
                                      NSLog(@"成功");
                                  } else {
                                      NSLog(@"失败");
                                  }
                                  
                              }];
    } else {
        NSLog(@"不支持");
    }
}


/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    [_tencentOAuth getUserInfo];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /** 新浪微博*/
    
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kApp_CallBackUrl;
//    request.scope = @"all";
//    [WeiboSDK sendRequest:request];
    
    /** QQ*/
//    [_tencentOAuth authorize:@[kOPEN_PERMISSION_GET_USER_INFO] inSafari:NO];
    
}

@end
