//
//  ViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/8/30.
//  Copyright © 2018年 test. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "LoginViewController.h"
#import "NewPageViewController.h"
#import "VoiceTrainViewController.h"

#define MAIN_PAGE @"mainPage"
@interface ViewController ()<IFLYOSsdkLoginDelegate>
@property(strong,nonatomic) WKWebView *webView;
@property(strong,nonatomic) WebViewJavascriptBridge *bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"创建webView :%@",NSStringFromClass([self class]));
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    [self.view addSubview:self.webView];
    [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:MAIN_PAGE];
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:MAIN_PAGE];
    NSLog(@"注册webView");
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"web" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:bundleStr]];
    [self.webView loadRequest:request];
}

-(void) openLoginPage{
    LoginViewController *loginPageVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginPageVc animated:YES];
}

-(void) openNewPage:(id) tag noBack:(NSNumber *)noBack{
    NSLog(@"从【%@】打开新页面:",tag);
    NewPageViewController *newPage = [NewPageViewController createNewPage:tag];
    [self.navigationController pushViewController:newPage animated:YES];
}

-(void) reloadOldPage{
    [self.webView reload];
}

-(void) closePage{
    NSLog(@"关闭页面");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loginFailed:(id) data{
    NSLog(@"取消登录:%@",data);
}

-(void) dealloc{
    [[IFLYOSSDK shareInstance] unregisterWebView:MAIN_PAGE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
