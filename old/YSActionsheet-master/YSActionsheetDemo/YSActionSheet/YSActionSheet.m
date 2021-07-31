//
//  LYSActionSheet.m
//  TestCustomUIActionSheet
//
//  Created by Winson on 16/5/19.
//  Copyright © 2016年 microlink. All rights reserved.
//

#import "YSActionSheet.h"

#define LYS_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define LYS_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define LYS_RGB_COLOR(r, g, b) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: 1]
#define LYS_LINE_COLOR LYS_RGB_COLOR(231,231,231)
#define LYS_BACKGROUND_COLOR LYS_RGB_COLOR(255,255,255)
#define LYS_BUTTON_HEIGHT 49
#define LYS_CANCEL_BUTTON_GAP 8

#define kCancelButtonTag 1001
#define kNormalButtonTag 2002


@implementation YSActionSheet
{
    UIView *actionSheetView;
    UIView *actionSheetTopView;
    UIView *actionSheetBottomView;
    NSMutableArray *titlesArray;
    NSString *cancelButtonTitle;
}

- (instancetype)initWithButtonTitles:(NSArray *)buttons cancelButtonTitle:(NSString *)cancelTitle {
    self = [super init];
    if (self) {
        
        cancelButtonTitle = cancelTitle;
        
        //动画方式显示主图层
        CATransition *fadeAnimation = [CATransition animation];
        fadeAnimation.duration = 0.3;
        fadeAnimation.type = kCATransitionReveal;
        [self.layer addAnimation:fadeAnimation forKey:nil];
        
        //背景半透明
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        //添加手势让自己消失
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        //添加弹出框
        actionSheetView = [[UIView alloc] init];
        actionSheetView.backgroundColor = LYS_BACKGROUND_COLOR;
        actionSheetView.userInteractionEnabled = YES;
        
        //弹出框非交互区域添加事件，防止触发self的tap事件
        UITapGestureRecognizer *actionSheetTap = [[UITapGestureRecognizer alloc] init];
        [actionSheetView addGestureRecognizer:actionSheetTap];
        
        //添加动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [actionSheetView.layer addAnimation:animation forKey:nil];
        [self addSubview:actionSheetView];
        
        //title数组
        titlesArray = [NSMutableArray array];
        
        
        actionSheetTopView = [[UIView alloc] init];
        CGFloat topViewHeight = buttons.count * LYS_BUTTON_HEIGHT;
        actionSheetTopView.frame = CGRectMake(0, 0, LYS_SCREEN_WIDTH, topViewHeight);
        [actionSheetView addSubview:actionSheetTopView];
        
        actionSheetBottomView = [[UIView alloc] init];
        CGFloat bottomViewHeight = cancelTitle ? LYS_BUTTON_HEIGHT + 8: 0;
        if (buttons == nil || buttons.count == 0) {
            bottomViewHeight = cancelTitle ? LYS_BUTTON_HEIGHT : 0;
        }
        actionSheetBottomView.frame = CGRectMake(0, topViewHeight, LYS_SCREEN_WIDTH, bottomViewHeight);
        actionSheetBottomView.backgroundColor = LYS_LINE_COLOR;
        [actionSheetView addSubview:actionSheetBottomView];
        
    
        //如果其他按钮不为空，就把这些按钮添加到视图上面
        if (buttons != nil && buttons.count > 0) {
            [titlesArray addObjectsFromArray:buttons];
            for (int i = 0; i < buttons.count; i ++) {
                UIButton *normalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                normalBtn.frame = CGRectMake(0, LYS_BUTTON_HEIGHT * i, LYS_SCREEN_WIDTH, LYS_BUTTON_HEIGHT);
                [normalBtn setTitle:buttons[i] forState:UIControlStateNormal];
                [normalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [normalBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_nor"] forState:UIControlStateNormal];
                [normalBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_pre"] forState:UIControlStateHighlighted];
                normalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [normalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                normalBtn.tag = kNormalButtonTag + i;
                [actionSheetTopView addSubview:normalBtn];
                
                // 添加上下分割线
                UIImageView *line = [[UIImageView alloc] init];
                line.backgroundColor = LYS_LINE_COLOR;
                line.frame = CGRectMake(0, LYS_BUTTON_HEIGHT * i, LYS_SCREEN_WIDTH, 0.5);
                [actionSheetTopView addSubview: line];
            }
        }

        //如果有取消按钮，把取消按钮添加到视图上面
        if (cancelTitle) {
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(0, buttons.count == 0 ? 0 : 8, LYS_SCREEN_WIDTH, LYS_BUTTON_HEIGHT);
            [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_nor"] forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"button_bg_pre"] forState:UIControlStateHighlighted];
            [cancelBtn setBackgroundColor:[UIColor whiteColor]];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.tag = kCancelButtonTag;
            [actionSheetBottomView addSubview:cancelBtn];
        }
        _cancelButtonIndex = -1;
    }
    return self;
}

- (void)show
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, LYS_SCREEN_WIDTH, LYS_SCREEN_HEIGHT);
    CGFloat actionSheetHeight = actionSheetTopView.frame.size.height + actionSheetBottomView.frame.size.height;
    actionSheetView.frame = CGRectMake(0, self.frame.size.height - actionSheetHeight, self.frame.size.width, actionSheetHeight);
    [window addSubview: self];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = actionSheetView.frame;
        rect.origin.y += rect.size.height;
        actionSheetView.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)buttonAction:(UIButton *)btn {
    // 点击按钮，提示框消失
    [self hide];
    
    if(btn.tag == kCancelButtonTag) {
        if([_delegate respondsToSelector: @selector(ysActionSheet:clickedButtonAtIndex:)]) {
            [_delegate ysActionSheet:self clickedButtonAtIndex:_cancelButtonIndex];
        }
    } else if(btn.tag >= kNormalButtonTag) {
        if([_delegate respondsToSelector: @selector(ysActionSheet:clickedButtonAtIndex:)]) {
            [_delegate ysActionSheet:self clickedButtonAtIndex:btn.tag - kNormalButtonTag];
        }
        
        if (self.selectBlock) {
            self.selectBlock(btn.tag - kNormalButtonTag, [self buttonTitleAtIndex:btn.tag - kNormalButtonTag]);
        }
    }
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index
{
    if(index == _cancelButtonIndex) {
        if(cancelButtonTitle == nil || [cancelButtonTitle isEqual: @""]) {
            return nil;
        }
        return cancelButtonTitle;
    } else {
        if(index > titlesArray.count) {
            return nil;
        }
        return titlesArray[index];
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
