//
//  NewsViewController.m
//  滚动条
//
//  Created by Tengfei on 2017/5/14.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel* label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.title;
    label.frame = CGRectMake(0, 0, 100, 80);
    [label setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
