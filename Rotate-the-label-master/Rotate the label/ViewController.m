//
//  ViewController.m
//  Rotate the label
//
//  Created by hydom on 2017/5/17.
//  Copyright © 2017年 Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *rotate = [UIButton buttonWithType:UIButtonTypeCustom];
//    rotate.frame = CGRectMake(100, 100, 45, 38);
//    [rotate setTitle:@"-" forState:UIControlStateNormal];
//    [rotate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rotate.titleLabel.textAlignment = NSTextAlignmentCenter;
//    rotate.titleLabel.font = [UIFont systemFontOfSize:9];
//    rotate.titleLabel.transform =  CGAffineTransformMakeRotation(M_PI_4);
//    rotate.titleLabel.adjustsFontSizeToFitWidth = YES;
//    rotate.backgroundColor = [UIColor cyanColor];
//    [rotate.titleLabel sizeToFit];
//    //添加button的背景图
//    [rotate setBackgroundImage:[UIImage imageNamed:@"标签"] forState:UIControlStateNormal];
//    rotate.titleEdgeInsets = UIEdgeInsetsMake(-13, 5, -5, -10);
//    [self.view addSubview:rotate];
    
    
//    UIView *rotateView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 45, 45)];
//    rotateView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标签 (1)"]];
//    [self.view addSubview:rotateView];
    UILabel *rotateLab = [[UILabel alloc]init];
    rotateLab.backgroundColor = [UIColor blueColor];
    rotateLab.frame = CGRectMake(0, 0, 45, 38);
    rotateLab.textAlignment = NSTextAlignmentCenter;
    rotateLab.transform = CGAffineTransformMakeRotation(M_PI_4);
    rotateLab.text = @"-";
    rotateLab.font = [UIFont systemFontOfSize:9];
    rotateLab.textColor = [UIColor redColor];
    [self.view addSubview:rotateLab];
//    [rotateView addSubview:rotateLab];
}


@end
