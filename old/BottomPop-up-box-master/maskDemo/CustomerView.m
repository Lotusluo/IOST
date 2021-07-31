//
//  CustomerView.m
//  maskDemo
//
//  Created by pengpeng yan on 2016/11/3.
//  Copyright © 2016年 pengpeng yan. All rights reserved.
//
#import "Masonry.h"
#import "CustomerView.h"
@interface CustomerView ()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *bottomLabel;
@property (nonatomic ,strong) UIView * maskView;
@end

@implementation CustomerView


- (instancetype) initWithHeight:(CGFloat)height{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
        self.backgroundColor = [UIColor whiteColor];
        [self layoutSubViews];
        [self initContrains];
    }
    return self;
}

- (void)layoutSubViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.bottomLabel];
}

- (void)showViewController:(UIViewController *)viewController{
    //蒙版
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskView.alpha = 0.f;
    [viewController.view.window addSubview:self.maskView];
    
    //点击蒙版，隐藏底部弹出视图 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.maskView addGestureRecognizer:tapGesture];
    
    //初始化视图位置
    CGRect frame = self.frame;
    frame.origin.y = self.maskView.frame.size.height - self.frame.size.height;
    self.frame = frame;
    self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
    [self.maskView addSubview:self];
    [self showAnimating];
}

- (void)showAnimating{
   [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       self.transform = CGAffineTransformIdentity;
       self.maskView.alpha = 1.f;
   } completion:nil];
}

//手势点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self hiddenAnimating];
}

- (void)hiddenAnimating{
  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
      self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
  } completion:^(BOOL finished){
      [self.maskView
       removeFromSuperview];
  }];

}


- (void)initContrains{
  [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.mas_top).offset(10);
      make.left.equalTo(self.mas_left).offset(10);
      make.height.equalTo(@15);
      make.width.equalTo(self.mas_width).multipliedBy(2.0/5);
  }];
  [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(@15);
        make.width.equalTo(self.mas_width).multipliedBy(2.0/5);
  }];
}

#pragma mark
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"11";
    }
    return _titleLabel;
}

- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"12";
    }
    return _bottomLabel;
}

@end
