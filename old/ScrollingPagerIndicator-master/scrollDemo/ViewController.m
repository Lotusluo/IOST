//
//  ViewController.m
//  scrollDemo
//
//  Created by light_bo on 2018/11/19.
//  Copyright © 2018年 light_bo. All rights reserved.
//

#import "ViewController.h"
#import "PdDotCell.h"
#import "PdIndicatorView.h"
static int kDotCount = 9;
@interface ViewController ()
{
    NSInteger _selectIndex;
    
}
@property(nonatomic,strong)PdIndicatorView *indicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initIndicatorView];

    [self initButton];

}


- (void)initIndicatorView {
    PdIndicatorView *indicatorView = [[PdIndicatorView alloc] initWithFrame:CGRectMake(50, 50, 20, 100)];
    [self.view addSubview:indicatorView];
    self.indicatorView= indicatorView;
    [self.indicatorView initDataWithCount:kDotCount];
}


- (void)initButton {
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [selectButton setTitle:@"往左滚动" forState:UIControlStateNormal];
    selectButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:selectButton];
    [selectButton addTarget:self action:@selector(buttonLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 200, 200)];
    [rightButton setTitle:@"往右滚动" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(buttonRightAction) forControlEvents:UIControlEventTouchUpInside];
}



- (void)buttonLeftAction {
    _selectIndex++ ;
    if (_selectIndex>=(kDotCount-1)) {
        _selectIndex=kDotCount - 1;
    }
    [self.indicatorView scrollAction:_selectIndex isLeft:YES];
}

- (void)buttonRightAction {
    _selectIndex--;
    if (_selectIndex>=(kDotCount-1)) {
        _selectIndex=kDotCount - 1;
    }
    if (_selectIndex <= 0) {
        _selectIndex = 0;
    }
    [self.indicatorView scrollAction:_selectIndex isLeft:NO];
}









@end
