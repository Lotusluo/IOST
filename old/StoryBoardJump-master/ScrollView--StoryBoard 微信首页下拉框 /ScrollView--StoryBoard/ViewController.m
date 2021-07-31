//
//  ViewController.m
//  ScrollView--StoryBoard
//
//  Created by 宋学谦 on 16/5/23.
//  Copyright © 2016年 宋学谦. All rights reserved.
//


/*
1.stroyBoard页面跳转
2.两个stroyBoard之间跳转
3.仿微信首页下拉框
4.scrollView stroyBoard适配
*/





#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xia)];
    self.downLabel.userInteractionEnabled = YES;
    [self.downLabel addGestureRecognizer:tap];
 
}


- (void)xia{

    UIStoryboard *secondStroyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    SecondViewController *second = [secondStroyBoard instantiateViewControllerWithIdentifier:@"secondID"];
    [self presentViewController:second animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
