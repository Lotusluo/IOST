//
//  AppDelegate.m
//  ThirdLoginDemo
//
//  Created by Jason on 16/8/20.
//  Copyright © 2016年 _littleBoy. All rights reserved.
//

#define kApp_Key @"1936364628"
#define kApp_id @"101040651"

#import "AppDelegate.h"

//新浪微博
#import <WeiboSDK.h>

//QQ
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()
<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kApp_Key];
    
    //QQ
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",kApp_id]]) {
        return [TencentOAuth HandleOpenURL:url];
        
    }else{
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",kApp_id]]) {
        return [TencentOAuth HandleOpenURL:url];
        
    }else{
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
}


/** 新浪微博****************************************************************************/
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    WBAuthorizeResponse *responseT = (WBAuthorizeResponse *)response;
    NSLog(@"%@",responseT.userInfo);
}
/** 新浪微博****************************************************************************/


@end
