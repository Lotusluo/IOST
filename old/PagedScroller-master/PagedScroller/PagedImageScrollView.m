//
//  PagedImageScrollView.m
//  PagedScroller
//
//  Created by Adusa on 15/9/17.
//  Copyright (c) 2015年 Adusa. All rights reserved.
//

#import "PagedImageScrollView.h"

@implementation PagedImageScrollView
{
    UIView *layoutContentView;
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        self.showsHorizontalScrollIndicator=YES;
        self.showsVerticalScrollIndicator=NO;
        self.pagingEnabled=YES;
        
        layoutContentView=[[UIView alloc]init];
        [self addSubview:layoutContentView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size=self.bounds.size;
    size.width*=self.images.count;
    self.contentSize=size;
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    layoutContentView.frame=CGRectMake(0, 0, contentSize.width, contentSize.height);
}

-(void)setImages:(NSArray *)images
{
    _images=images;
    CGSize size=self.bounds.size;
    size.width*=self.images.count;
    self.contentSize=size;
    
    layoutContentView.frame=CGRectMake(0, 0, size.width, size.height);
    [layoutContentView removeConstraints:layoutContentView.constraints];
    for (UIView *v in layoutContentView.subviews) {
        [v removeFromSuperview];
    }
    
    NSMutableArray *imageViews=[[NSMutableArray alloc]init];
    for (UIImage *image in self.images) {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [layoutContentView addSubview:imageView];
        imageView.translatesAutoresizingMaskIntoConstraints=NO;
        [layoutContentView addConstraint:[NSLayoutConstraint constraintWithItem:layoutContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0]];
        [imageViews addObject:imageView];
    }
    UIView *leftView=nil;
    for (UIView *view in imageViews) {
        if (leftView) {
            [layoutContentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
        }
        else
        {
        [layoutContentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:layoutContentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
        }
        leftView=view;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
