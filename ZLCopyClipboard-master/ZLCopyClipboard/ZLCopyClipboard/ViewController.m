//
//  ViewController.m
//  ZLCopyClipboard
//
//  Created by ZL on 2017/7/24.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ViewController.h"

// 设置尺寸
#define UI_View_Width   [UIScreen mainScreen].bounds.size.width // 屏幕宽度

// RGB颜色
#define ZLColor(r, g, b)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface ViewController ()

// 邀请链接值
@property (nonatomic, weak) UITextView *link;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
   [self setupUI];
}

- (void)setupUI {
    
    CGFloat marginX = 15;
    CGFloat cellH = 50;
    CGFloat btnW = 70;
    CGFloat btnH = 30;
    
    // 邀请链接
    UIView *linkView2 = [[UIView alloc] init];
    linkView2.backgroundColor = [UIColor whiteColor];
    linkView2.frame = CGRectMake(0, 100, UI_View_Width, cellH);
    [self.view addSubview:linkView2];
    // 邀请链接label
    UILabel *linkLabel2 = [[UILabel alloc] init];
    linkLabel2.backgroundColor = [UIColor clearColor];
    linkLabel2.frame = CGRectMake(marginX, -1, 60, cellH);
    linkLabel2.text = @"邀请链接";
    linkLabel2.font = [UIFont systemFontOfSize:14];
    linkLabel2.textColor = ZLColor(102, 102, 102);
    [linkView2 addSubview:linkLabel2];
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(UI_View_Width - marginX - btnW, (cellH - btnH) * 0.5, btnW, btnH);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [copyBtn addTarget:self action :@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:ZLColor(108, 187, 82) forState:UIControlStateNormal];
    copyBtn.layer.borderColor = ZLColor(108, 187, 82).CGColor;
    copyBtn.layer.cornerRadius = 3.0;
    copyBtn.layer.borderWidth = 1.0f;
    [linkView2 addSubview:copyBtn];
    
    // 滑动邀请链接
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(linkLabel2.frame), 0, UI_View_Width - 60 - btnW - marginX * 2, cellH)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [linkView2 addSubview:scrollView];
    
    UITextView *link = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width - 60 - btnW - marginX * 2, 50)];
    link.text = @"wwww.ujfwegertkyluiopafsdfghnlrjkliop[sdfghjklertyui测试测试滚动测试测试滚动测试测试滚动测试测试滚动测试测试滚动";
    link.textColor = [UIColor grayColor];
    link.textContainer.maximumNumberOfLines = 1;
    link.scrollEnabled = YES;//是否可以拖动
    link.editable = NO;//禁止编辑
    [scrollView addSubview:link];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(link.bounds), 50);
    self.link = link;
}

#pragma mark - 按钮点击事件操作

/**
 * 复制链接
 */
- (void)copylinkBtnClick {
    
    NSLog(@"复制内容: %@", self.link.text);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.link.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
