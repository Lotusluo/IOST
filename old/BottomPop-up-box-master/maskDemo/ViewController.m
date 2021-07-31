//
//  ViewController.m
//  maskDemo
//
//  Created by pengpeng yan on 2016/11/3.
//  Copyright © 2016年 pengpeng yan. All rights reserved.
//
#import "CustomerView.h"
#import "ViewController.h"

@interface ViewController ()
/** 自定义 */
@property (nonatomic ,strong) UIButton *btn;
/** 自定义view */
@property (nonatomic ,strong) CustomerView *custView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loutSubViews];
    
}

- (void)btnAction:(UIButton *)btn{
    self.custView = [[CustomerView alloc] initWithHeight:200];
    [self.custView showViewController:self];
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        _btn.frame = CGRectMake(0, 64, 50, 20);
        [_btn setTitle:@"an" forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor grayColor]];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
          }
    return _btn;
}

- (void)loutSubViews{
    [self.view addSubview:self.btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
