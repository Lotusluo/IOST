//
//  TestViewController.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TitleViewController.h"
#import "JXCategoryTitleView.h"

@interface TitleViewController ()
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation TitleViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titles = @[@"标题一", @"标题一", @"标题一", @"标题一标题一", @"标题"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myCategoryView.titles = self.titles;
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

@end
