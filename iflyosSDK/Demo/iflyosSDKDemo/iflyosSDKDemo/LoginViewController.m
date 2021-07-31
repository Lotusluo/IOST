//
//  LoginViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 test. All rights reserved.
//

#import "LoginViewController.h"
#import "NewPageViewController.h"
#import <WebKit/WebKit.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import <iflyosSDKForiOS/IFLYOSUIColor+IFLYOSColorUtil.h>
#define LOGIN_PAGE @"loginPage"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface LoginViewController ()<IFLYOSsdkLoginDelegate>
@property(strong,nonatomic) WKWebView *webView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"创建webView :%@",NSStringFromClass([self class]));
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
    [self.view addSubview:self.webView];
//    NSLog(@"web view 大小：%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    NSLog(@"注册webView");
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.contextTag) {
        [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:LOGIN_PAGE contextTag:self.contextTag];
    }else{
        [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:LOGIN_PAGE];
    }
    
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:LOGIN_PAGE];
    NSLog(@"打开登录页");
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:bundleStr]];
    [self.webView loadCustomRequest:request];
    [[IFLYOSSDK shareInstance] openLogin:LOGIN_PAGE];
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IFLYOSSDK shareInstance] unregisterWebView:LOGIN_PAGE];
}

/**
 *  新页面打开
 *  tag : 标识符
 *  noBack : 禁止手势返回（1:禁止 ， 0:不禁止）
 */
-(void) openNewPage:(id) tag noBack:(NSNumber *)noBack{
    NSLog(@"打开新网页：%@ noBack:%li",tag,noBack);
    NewPageViewController *newPage = [NewPageViewController createNewPage:tag];
    newPage.noBack = noBack;
    [self.navigationController pushViewController:newPage animated:YES];
}

/**
 *  登录成功
 */
-(void) onLoginSuccess{
    NSLog(@"登录成功");
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  登录失败
 */
-(void) onLoginFailed:(NSInteger) type error:(NSError *) error{
    NSLog(@"登录失败:%li,%@",type,error.localizedDescription);
}

/**
 *  注销成功
 */
-(void) onLogoutSuccess{
    NSLog(@"注销成功");
}

/**
 *  注销失败
 */
-(void) onLogoutFailed:(NSInteger) type error:(id) error{
    
}

/**
 *  关闭页面打开
 */
-(void) closePage{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 网页加载完成时，如果读取到页面内带有形如
 * <meta name="head-color">#FFFFFF</meta>
 * 的标签时，将回调颜色
 */
-(void) updateHeaderColor:(NSString *) color{
    self.webView.backgroundColor = [UIColor colorWithHexString:color];
    self.view.backgroundColor = [UIColor colorWithHexString:color];
}

/**
 * 网页加载完成时，将回调标题
 */
-(void) updateTitle:(NSString *) title{
    self.navigationItem.title = @"";
}

-(void) dealloc{
    NSLog(@"离开");
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
