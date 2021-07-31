//
//  GKToutiaoMineViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by QuintGao on 2017/7/9.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "GKToutiaoMineViewController.h"
#import "GKToutiaoDetailViewController.h"

@interface GKToutiaoMineViewController ()

@end

@implementation GKToutiaoMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    
    self.gk_navBackgroundColor = [UIColor darkGrayColor];
    
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:@"关闭" target:self action:@selector(closeAction)];
    
    UIImageView *pageImage = [UIImageView new];
    pageImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - GK_TABBAR_HEIGHT);
    pageImage.image = [UIImage imageNamed:@"mine_page"];
    [self.view addSubview:pageImage];
    
    pageImage.userInteractionEnabled = YES;
    [pageImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageAction)]];
}

- (void)pageAction {
    GKToutiaoDetailViewController *detailVC = [GKToutiaoDetailViewController new];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
