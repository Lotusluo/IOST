//
//  ViewController.m
//  demo
//
//  Created by zhaoxiao on 15/3/12.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ViewController.h"
#import "ZSDOptionItem.h"
#import "ZSDAlertOptionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(80, 100, 100, 50)];
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)show:(id)sender
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        ZSDOptionItem *item = [[ZSDOptionItem alloc]init];
        item.optionImage = [UIImage imageNamed:@"member_info_icon_zhangganbao"];
        item.optionSelectedImage = [UIImage imageNamed:@"bank_card_icon_nyyh"];
        item.optionText = [NSString stringWithFormat:@"小黄蜂智能音箱——%d",i];
        
        [list addObject:item];
    }
    
    ZSDAlertOptionView *optionView = [[ZSDAlertOptionView alloc]init];
    optionView.selectIndex = 0;
    optionView.optionList = list;
    
    [optionView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
