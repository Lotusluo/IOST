//
//  HWHeadRefresh.m
//  refresh
//
//  Created by Howe on 16/2/23.
//  Copyright © 2016年 Howe. All rights reserved.
//

//----------------------------------------------------------
/*
 *                        下拉刷新头部
 */
//----------------------------------------------------------

#import "HWHeadRefresh.h"
#import "HWRefreshKeyValue.h"


@interface HWHeadRefresh()

@property(nonatomic, weak) UIScrollView *scrollView;

@property(nonatomic, weak) UIView *refreshView;

@property(nonatomic, strong) UILabel *refLabel;

@property(nonatomic, strong) UIActivityIndicatorView *actView;

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, copy) HWRefreshBlock hwHeadRefreshBlock;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isCanRefresh;
@end

@implementation HWHeadRefresh

- (void)hw_addFooterRefreshWithView:(__kindof UIScrollView * _Nonnull)scrollView hw_footerRefreshBlock:(HWRefreshBlock _Nonnull)block
{
    if (![scrollView isKindOfClass:[UIScrollView class]]){
        NSLog(@"请检查添加了刷新控件的视图是否是一个滑动视图 View :%@",scrollView);
        self.isCanRefresh = NO;
        return;
    }
    self.isCanRefresh = YES;
    self.hwHeadRefreshBlock = block;
    self.scrollView = scrollView;
    [self _checkSuperView];
}

- (instancetype)init{
    self = [super init];
    if (self){
        
    }
    return self;
}

//----------------------------------------------------------
//|                                                        |
//|                                                        |
//|                         懒加载                          |
//|                                                        |
//|                                                        |
//----------------------------------------------------------

- (UIImageView *)imageView{
    if (_imageView == nil)
    {
        UIImage *image = [UIImage imageNamed:@"HWSource.bundle/down"];
        self.imageView  = [[UIImageView alloc]initWithImage:image];
        [self.refreshView addSubview:_imageView];
    }
    return _imageView;
}


- (UILabel *)refLabel{
    if (_refLabel== nil){
        self.refLabel = [[UILabel alloc]init];
        self.refLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.refreshView addSubview:_refLabel];
    }
    return _refLabel;
}

- (UIActivityIndicatorView *)actView{
    if (_actView == nil){
        self.actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.refreshView addSubview:_actView];
    }
    return _actView;

}

- (UIView *)refreshView{
    if (_refreshView == nil){
        UIView *refreshView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -HWRefreshViewH, CGRectGetWidth(_scrollView.bounds), HWRefreshViewH)];
        refreshView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:refreshView];
        self.refreshView = refreshView;
    }
    return _refreshView;
}

//----------------------------------------------------------
//|                                                        |
//|                                                        |
//|                         私有方法                        |
//|                                                        |
//|                                                        |
//----------------------------------------------------------

- (void)_viewRefreshNone{
    self.imageView.hidden = NO;
    if (_actView != nil){
        self.actView.hidden = YES;
        [self.actView stopAnimating];
    }
    self.imageView.frame = CGRectMake(HWRefreshRefImageViewX, HWRefreshRefImageViewY, self.imageView.image.size.width, self.imageView.image.size.height);
    [self.refreshView addSubview:self.imageView];
    
    self.refLabel.frame = CGRectMake(HWRefreshRefLabelX, HWRefreshRefLabelY, HWRefreshRefLabelW, HWRefreshRefLabelH);
    self.refLabel.text = HWHeadRefreshViewNoneText;
    [self.refreshView addSubview:self.refLabel];
    
}

- (void)_viewRefreshing{
    if (!_actView){
        [self.refreshView addSubview:self.actView];
    }
    self.imageView.hidden = YES;
    self.actView.frame = CGRectMake(HWRefreshRefActViewX, HWRefreshRefActViewY, HWRefreshRefActViewW, HWRefreshRefActViewH);
    self.refLabel.text = HWHeadRefreshViewRefreshingText;
    [self.actView startAnimating];
}

- (void)_viewWillRefresh
{
    self.refLabel.text = HWHeadRefreshViewWillRefreshText;
}


- (void)_checkSuperView
{
    if ([self.scrollView isKindOfClass:[UIScrollView class]])
    {
        [self _setup];
    }
}

- (void)_setup{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [self _viewRefreshNone];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"])
        return;
    
    if (self.isRefreshing){
        return;
    }
    
    NSValue *offsetValue =  [change objectForKey:NSKeyValueChangeNewKey];
    CGPoint movePoint = [offsetValue CGPointValue];
    double moveH = movePoint.y;
    NSLog(@"moveH:%f",moveH);
    
    if (moveH <= - HWToRefreshView){
        [self _toRefreshState];
    }else{
        [self _toNoneState];
    }
}

/**
 *  到正在刷新状态
 */
- (void)_toRefreshState{
    if (self.isRefreshing){
        return;
    }
    [self _viewWillRefresh];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    if (!self.scrollView.dragging){
        self.scrollView.contentInset = UIEdgeInsetsMake(HWRefreshViewH, 0.0f, 0.0f, 0.0f);
         [self _viewRefreshing];
        self.isRefreshing = YES;
        if (self.hwHeadRefreshBlock){
            self.hwHeadRefreshBlock();
        }
    }

}


/**
 *  没有刷新状态
 */
- (void)_toNoneState{
    if (self.isRefreshing){
        return;
    }
    [self _viewRefreshNone];
    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];

}

/**
 *  结束刷新
 */
- (void)hw_endRefreshState{
    if (!self.isCanRefresh) return;
    self.isRefreshing = NO;
    [self _viewRefreshNone];
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        self.scrollView.contentOffset = CGPointMake(0.0f, 0.0f);
        self.imageView.transform = CGAffineTransformIdentity;
    }];
    
}

/**
 *  正在刷新
 */
- (void)hw_toRfreshState{
    if (!self.isCanRefresh) return;
    [UIView animateWithDuration:0.3f animations:^{
    self.scrollView.contentOffset = CGPointMake(0.0f, -HWRefreshViewH);
    }];
    [self _viewRefreshing];
    if (self.hwHeadRefreshBlock){
        self.hwHeadRefreshBlock();
    }
    self.isRefreshing = YES;
}


@end
