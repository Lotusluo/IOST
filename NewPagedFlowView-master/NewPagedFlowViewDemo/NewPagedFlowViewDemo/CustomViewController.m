//
//  TestViewController.m
//  NewPagedFlowViewDemo
//
//  Created by sskh on 16/8/11.
//  Copyright © 2016年 robertcell.net. All rights reserved.
//

#import "CustomViewController.h"
#import "NewPagedFlowView.h"
#import "DeviceCellView.h"


#define Width [UIScreen mainScreen].bounds.size.width

@interface CustomViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"CustomNewPagedFlowView";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scroll" style:UIBarButtonItemStyleDone target:self action:@selector(gotoPage)];
    
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
    }
    
    [self setupUI];
}

#pragma mark --滚动到指定的页数
- (void)gotoPage {
    
    //产生跳转的随机数
    int value = arc4random() % self.imageArray.count;
    NSLog(@"value~~%d",value);
    
    [self.pageFlowView scrollToPage:value];
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 120, Width, Width * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
//    pageFlowView.minimumPageAlpha = 0.4;
    
#warning 假设产品需求左右卡片间距30,底部对齐
//    pageFlowView.leftRightMargin = 30;
//    pageFlowView.topBottomMargin = 0;
    
    pageFlowView.orginPageCount = 2;
    pageFlowView.isOpenAutoScroll = YES;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    [self.view addSubview:pageFlowView];
    
    
    self.pageFlowView = pageFlowView;
    //添加到主view上
    [self.view addSubview:self.indicateLabel];
    
}

#pragma mark --NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"CustomViewController 滚动到了第%ld页",pageNumber);
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    float width = Width - 60;
    float height  = width * 1  / 3;
    return CGSizeMake(width, height);
}

#pragma mark --NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return 2;
}


- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIView *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[DeviceCellView alloc] init];
    }
    return bannerView;
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, Width, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}

#pragma mark --旋转屏幕改变newPageFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [coordinator animateAlongsideTransition:^(id context) {
            [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

@end
