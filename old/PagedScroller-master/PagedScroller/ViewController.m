//
//  ViewController.m
//  PagedScroller
//
//  Created by Adusa on 15/9/17.
//  Copyright (c) 2015年 Adusa. All rights reserved.
//

#import "ViewController.h"
#import "PagedImageScrollView.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController
{
    PagedImageScrollView *_scrollView;
    UIPageControl *pageControl;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView=[[PagedImageScrollView alloc]init];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    _scrollView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
    //_scrollView.images=@[[UIImage imageNamed:@"92cdc35dc284fbdda66bef6757e03baf.jpg"],[UIImage imageNamed:@"94cad1c8a786c9177582c830cb3d70cf3bc75731.jpg"],[UIImage imageNamed:@"501f448b145f788877acc7ca715aad52.jpg"],[UIImage imageNamed:@"163928gp3911uzcpjc9zh1.jpg"]];
    [_scrollView setImages: [NSArray arrayWithObjects:[UIImage imageNamed:@"92cdc35dc284fbdda66bef6757e03baf.jpg"],[UIImage imageNamed:@"94cad1c8a786c9177582c830cb3d70cf3bc75731.jpg"],[UIImage imageNamed:@"501f448b145f788877acc7ca715aad52.jpg"],[UIImage imageNamed:@"163928gp3911uzcpjc9zh1.jpg"], nil]];
    pageControl=[[UIPageControl alloc]init];
    pageControl.numberOfPages=_scrollView.images.count;
    pageControl.currentPage=0;
    pageControl.pageIndicatorTintColor=[UIColor grayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    [pageControl addTarget:self action:@selector(handlePageControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    pageControl.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:pageControl attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:pageControl attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.0f]];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)handlePageControlChange:(UIPageControl *)sender
{
    CGFloat offset=_scrollView.frame.size.width*pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat distance=_scrollView.contentOffset.x/_scrollView.contentSize.width;
    NSInteger page=distance*pageControl.numberOfPages;
    pageControl.currentPage=page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
