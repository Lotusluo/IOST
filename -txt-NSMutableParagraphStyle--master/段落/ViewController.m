//
//  ViewController.m
//  段落
//
//  Created by CC on 16/9/19.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ViewController.h"

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CAAnimationDelegate>
{
    UITextView *_textView;
    UIView *_bgView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bgView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, KScreenWidth - 100, KScreenHeight -100)];
    [self.view addSubview:_bgView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, _bgView.frame.size.width, _bgView.frame.size.height)];
    [_bgView addSubview:_textView];
    _textView.editable = NO;
    
    [self loadData:[self filename]];
}


#pragma makr 关闭事件
- (void)closeView {
    [self closeAniamtion:_bgView];
}

#pragma mark -- 代理监听动画停止
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    if ([_bgView.layer animationForKey:@"closeAnimation"] == anim) {
        [_bgView removeFromSuperview];
    }
}

#pragma mark -- 拼接字符
- (void)loadData:(NSString *)filename {
    
    //第一个段落
    NSMutableParagraphStyle *first = [[NSMutableParagraphStyle alloc]init];
    first.alignment = NSTextAlignmentLeft;
    first.lineSpacing = 10;
    
    //第二个段落
    NSMutableParagraphStyle *second = [[NSMutableParagraphStyle alloc]init];
    //从左开始写
    second.alignment = NSTextAlignmentLeft;
    //首行缩进
    second.firstLineHeadIndent = 100;
    //间距
    second.lineSpacing = 60;
    
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    UIFont *contextFont = [UIFont systemFontOfSize:13];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"title" attributes:@{NSParagraphStyleAttributeName:first,NSFontAttributeName:titleFont}];
    
    //标题拼接正文，正文前加换行符
    NSString *str = [NSString stringWithFormat:@"\n%@",filename];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSParagraphStyleAttributeName:second,NSFontAttributeName:contextFont}];
    
    [str1 appendAttributedString:str2];
    _textView.attributedText = str1;
}

#pragma mark -- 关闭动画
- (void)closeAniamtion:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.toValue = @0.9;
    animation.duration = 0.4;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"closeAnimation"];
}

#pragma mark -- 本地 txt 文件内容
- (NSString *)filename {
    //本地 txt 文件
    NSString *path = [[NSBundle mainBundle]pathForResource:@"浅遇时光，静好无恙.txt" ofType:nil];
    //取出内容
    NSString *filename = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return filename;
}

@end
