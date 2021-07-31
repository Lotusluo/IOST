//
//  LogTextViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "LogTextViewController.h"

@interface LogTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LogTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日志";
    self.textView.text = self.text;
    // Do any additional setup after loading the view from its nib.
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
