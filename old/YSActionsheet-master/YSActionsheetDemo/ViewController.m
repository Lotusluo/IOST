//
//  ViewController.m
//  YSActionsheetDemo
//
//  Created by Winson on 2017/7/28.
//  Copyright © 2017年 刘永胜. All rights reserved.
//

#import "ViewController.h"
#import "YSActionSheet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *desLB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)showYSActionSheet:(id)sender {
    YSActionSheet *actionSheet = [[YSActionSheet alloc] initWithButtonTitles:@[@"拍照", @"从相册选取"] cancelButtonTitle:@"取消"];
    actionSheet.selectBlock = ^(NSInteger selectIndex, NSString *selectStr) {
        if (selectIndex == 0) {
            //拍照
            _desLB.text = @"你点击了拍照";
        }
        if (selectIndex == 1) {
            //从相册选取
            _desLB.text = @"你点击了从相册选取";
        }
    };
    [actionSheet show];
}




@end
