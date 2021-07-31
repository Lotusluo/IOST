//
//  VoiceTrainViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "VoiceTrainViewController.h"
#import <WebKit/WebKit.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#define VOICE_TRAIN_PAGE @"VoiceTrainPage"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface VoiceTrainViewController ()
@property(strong,nonatomic) WKWebView *webView;
@end

@implementation VoiceTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"创建webView");
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
    [self.view addSubview:self.webView];
    [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:VOICE_TRAIN_PAGE];
    
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:VOICE_TRAIN_PAGE];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger code = [[IFLYOSSDK shareInstance] openWebPage:VOICE_TRAIN_PAGE pageIndex:PERSONAL_VOICE];
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
