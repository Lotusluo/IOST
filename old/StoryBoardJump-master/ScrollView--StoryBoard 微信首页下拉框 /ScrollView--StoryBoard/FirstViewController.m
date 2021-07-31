//
//  FirstViewController.m
//  ScrollView--StoryBoard
//
//  Created by 宋学谦 on 16/5/24.
//  Copyright © 2016年 宋学谦. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "XTPopView.h"
#import "ThirdViewController.h"

@interface FirstViewController ()<selectIndexPathDelegate>

@property (nonatomic, strong) UIButton *customBtn;
@property (nonatomic, strong) XTPopView *view1;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.frame = CGRectMake(self.view.bounds.size.width - 60, 20, 40, 40);
    [_customBtn setTitle:@"➕" forState:UIControlStateNormal];
    [_customBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_customBtn];
}

- (void)go{
    
    UIStoryboard *secondStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *view = [secondStroyBoard instantiateViewControllerWithIdentifier:@"zero"];
    [self presentViewController:view animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnClick:(UIButton *)btn
{
    
    /**
     XTTypeOfUpLeft,     // 上左
     XTTypeOfUpCenter,   // 上中
     XTTypeOfUpRight,    // 上右
     
     XTTypeOfDownLeft,   // 下左
     XTTypeOfDownCenter, // 下中
     XTTypeOfDownRight,  // 下右
     
     XTTypeOfLeftUp,     // 左上
     XTTypeOfLeftCenter, // 左中
     XTTypeOfLeftDown,   // 左下
     
     XTTypeOfRightUp,    // 右上
     XTTypeOfRightCenter,// 右中
     XTTypeOfRightDown,  // 右下
     */
    CGPoint point = CGPointMake(_customBtn.center.x + 3,_customBtn.frame.origin.y + 64);
    self.view1 = [[XTPopView alloc] initWithOrigin:point Width:130 Height:40 * 4 Type:XTTypeOfUpRight Color:[UIColor colorWithRed:0.2737 green:0.2737 blue:0.2737 alpha:1.0]];
    self.view1.dataArray = @[@"发起群聊",@"添加朋友", @"扫一扫", @"收付款"];
    self.view1.images = @[@"发起群聊",@"添加朋友", @"扫一扫", @"付款"];
    self.view1.fontSize = 13;
    self.view1.row_height = 40;
    self.view1.titleTextColor = [UIColor whiteColor];
    self.view1.delegate = self;
    [self.view1 popView];
}
- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Click 0 ......");
        }
            break;
        case 1:
        {
            NSLog(@"Clikc 1 ......");
            [self.view1 dismiss];
            ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
            [self presentViewController:thirdVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            NSLog(@"Clikc 2 ......");
        }
            break;
        case 3:
        {
            NSLog(@"Clikc 3 ......");
        }
            break;
        default:
            break;
    }
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
