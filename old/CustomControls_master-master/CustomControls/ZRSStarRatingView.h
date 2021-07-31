//
//  ZRSStrRatingView.h
//  Camp
//
//  Created by 周荣水 on 2017/1/12.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, StarRatingViewState){
    StarRatingViewStateAccurate = 0,//默认跟随滑动距离
    StarRatingViewStateHalf = 1,//半星
    StarRatingViewStateWhole = 2//整星
};

typedef NS_ENUM(NSInteger, StarRatingViewRadiusType){
    StarRatingViewRadiusTypeDefault = 0,//默认星星中间半径
    StarRatingViewRadiusTypeMidium = 1,//中
    StarRatingViewRadiusTypeLarge = 2//大
};


IB_DESIGNABLE
@interface ZRSStarRatingView : UIControl

@property (nonatomic, assign) IBInspectable BOOL isUsing;//是否开启触摸事件
//星星颜色
@property (nonatomic, strong) IBInspectable UIColor *starTintColor;
//默认5.0， 如果超出新的最大值，当前值可能会改变
@property (nonatomic, assign) IBInspectable CGFloat maximumValue;
//默认0.0, 如果超出新的最小值，当前值可能会改变
@property (nonatomic, assign) IBInspectable CGFloat minimumValue;
//默认0.0, 该值将固定为最小/最大值
@property (nonatomic, assign) IBInspectable CGFloat value;
//默认0.0
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing;
//默认（5.0,0.0）
@property (nonatomic, assign) IBInspectable UIOffset offset;
//星星的边框宽度，在0.5和5.0之间，默认为1.0
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, assign) IBInspectable StarRatingViewState starState;

@property (nonatomic, assign) IBInspectable StarRatingViewRadiusType radiusType;

@end
