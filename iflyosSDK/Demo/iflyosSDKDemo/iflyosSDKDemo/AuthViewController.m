//
//  AuthViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "AuthViewController.h"
#import <WebKit/WebKit.h>
#import "NewPageViewController.h"
#define AUTH_PAGE @"authPage"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface AuthViewController ()<IFLYOSsdkAuthDelegate>
@property(strong,nonatomic) WKWebView *webView;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    NSLog(@"创建webView");
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
    [self.view addSubview:self.webView];
    [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:AUTH_PAGE];
    
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:AUTH_PAGE];
    // Do any additional setup after loading the view from its nib.
}

-(void) onAuthSuccess{
    NSLog(@"授权成功");
   
}

-(void) onAuthFailed{
    NSLog(@"授权失败");
    
}

-(void) closePage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) openNewPage:(id) tag noBack:(NSNumber *)noBack{
    NSLog(@"从【%@】打开新页面:",tag);
    NewPageViewController *newPage = [NewPageViewController createNewPage:tag];
    [self.navigationController pushViewController:newPage animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.authUrl){
        [[IFLYOSSDK shareInstance] openAuthorizePage:AUTH_PAGE url:self.authUrl];
    }else{
        [[IFLYOSSDK shareInstance] openAuthorizePage:AUTH_PAGE url:@"https://auth.iflyos.cn/oauth/device"];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
