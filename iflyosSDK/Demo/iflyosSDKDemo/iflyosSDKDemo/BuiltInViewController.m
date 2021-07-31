//
//  BuiltInViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "BuiltInViewController.h"
#import <WebKit/WebKit.h>
#import "NewPageViewController.h"
#define BUILTIN_PAGE @"BuiltInPage"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface BuiltInViewController ()
@property(strong,nonatomic) WKWebView *webView;
@property(nonatomic) BOOL isNextPage;
@end

@implementation BuiltInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"创建webView");
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:configuration];
    [self.view addSubview:self.webView];
    [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:BUILTIN_PAGE];
    
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:BUILTIN_PAGE];
    
    NSInteger code = -1 ;
    if (self.type) {
        code = [[IFLYOSSDK shareInstance] openWebPage:BUILTIN_PAGE type:self.type];
    }else{
        code = [[IFLYOSSDK shareInstance] openWebPage:BUILTIN_PAGE pageIndex:self.pageIndex deviceId:self.deviceId];
    }
    if (code == -3) {
        NSLog(@"未登录，请先登录");
    }
    // Do any additional setup after loading the view from its nib.
}

-(void) openNewPage:(id) tag noBack:(NSNumber *)noBack{
    NSLog(@"从【%@】%li,打开新页面:",tag,[noBack integerValue]);
    NewPageViewController *newPage = [NewPageViewController createNewPage:tag];
    [self.navigationController pushViewController:newPage animated:YES];
}

-(void) closePage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) openNewBrower:(NSString *) url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.isNextPage = false;
    [super viewWillAppear:animated];
    [[IFLYOSSDK shareInstance] webViewAppear:BUILTIN_PAGE];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IFLYOSSDK shareInstance] webViewDisappear:BUILTIN_PAGE];
}

-(void) dealloc{
    NSLog(@"移除");
    [[IFLYOSSDK shareInstance] unregisterWebView:BUILTIN_PAGE];
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
