//
//  NewPageViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 test. All rights reserved.
//

#import "NewPageViewController.h"
#import <WebKit/WebKit.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface NewPageViewController ()
@property(strong,nonatomic) WKWebView *webView;
@property(copy,nonatomic) NSString *Tag;
@end

@implementation NewPageViewController

-(int) randomInt{
    int value = (arc4random() % 10000) + 1;
    return value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Tag = [NSString stringWithFormat:@"newPage-%i",[self randomInt]];
    NSLog(@"创建webView :%@",NSStringFromClass([self class]));
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = userContentController;
    self.webView.configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
    [self.view addSubview:self.webView];
    if (self.contextTag) {
        [[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:self.Tag contextTag:self.contextTag];
    }
    
    
    [[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:self.Tag];
    [[IFLYOSSDK shareInstance] openNewPage:self.Tag];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] && self.noBack == 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [[IFLYOSSDK shareInstance] webViewAppear:self.Tag];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[IFLYOSSDK shareInstance] webViewDisappear:self.Tag];
}

-(void) closePage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) openNewPage:(id) tag noBack:(NSNumber *)noBack{
    NSLog(@"从【%@】打开新页面:",tag,noBack);
    NewPageViewController *newPage = [NewPageViewController createNewPage:tag];
    [self.navigationController pushViewController:newPage animated:YES];
}

+(NewPageViewController *) createNewPage:(NSString *) tag{
    NewPageViewController *vc = [[NewPageViewController alloc] initWithNibName:@"NewPageViewController" bundle:nil];
    vc.contextTag = tag;
    return vc;
}

-(void) openNewBrower:(NSString *) url{
    NSURL *tmpURL = [NSURL URLWithString:url];
    NSString *tmpStr = tmpURL.absoluteString;
    NSArray * array1 = [tmpStr componentsSeparatedByString:@"kugouurl://userId="];
    if (array1.count > 0 && [url rangeOfString:@"kugouurl://userId="].location !=NSNotFound) {
        NSString *userId = array1[1];
        if (userId) {
            [[IFLYOSSDK shareInstance] jumpKugouVIPPage:userId];
        }
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:tmpURL]){
            [[UIApplication sharedApplication] openURL:tmpURL options:nil completionHandler:^(BOOL success) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    NSLog(@"newPage释放");
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
