//
//  ZRSCustomDottedLine.h
//  Camp
//
//  Created by 周荣水 on 2017/1/13.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZRSCustomDottedLine : UIView

@property (nonatomic, strong) IBInspectable UIColor *lineColor;


@property (nonatomic, assign) IBInspectable BOOL topLine;
@property (nonatomic, assign) IBInspectable BOOL bottomLine;
@property (nonatomic, assign) IBInspectable BOOL leftLine;
@property (nonatomic, assign) IBInspectable BOOL rightLine;
@property (nonatomic, assign) IBInspectable BOOL isMove;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@end
