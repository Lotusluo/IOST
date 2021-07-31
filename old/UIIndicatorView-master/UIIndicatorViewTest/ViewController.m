//
//  ViewController.m
//  UIIndicatorViewTest
//
//  Created by 柯建芳 on 2018/5/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ViewController.h"
#import "UIIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIIndicatorView *indicator = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 40, 100) style:UIIndicatorViewDefaultStyle arrays:@[@"标题一", @"标题一", @"标题一", @"标题一", @"SUCCESS"]];
//    [self.view addSubview:indicator];
    
    
    UIIndicatorView *indicator2 = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 100) style:UIIndicatorViewLineStyle arrays:@[@"标题一", @"标题一", @"标题一", @"标题一"]];

    [self.view addSubview:indicator2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
