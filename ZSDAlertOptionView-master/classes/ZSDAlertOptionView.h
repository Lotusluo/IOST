//
//  ZSDAlertOptionView.h
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDAlertOptionView;
@protocol ZSDAlertOptionViewDelegate <NSObject>

-(void)optionView:(ZSDAlertOptionView *)optionView didSelectIndex:(NSInteger)selIndex;

@end

@interface ZSDAlertOptionView : UIView

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSArray *optionList;

@property (nonatomic,assign) id<ZSDAlertOptionViewDelegate> delegate;

-(void)show;

@end
