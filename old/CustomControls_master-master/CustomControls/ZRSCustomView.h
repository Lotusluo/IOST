//
//  ZRSCustomView.h
//  Camp
//
//  Created by 周荣水 on 2017/1/10.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZRSCustomView : UIView

@property (nonatomic, strong) IBInspectable UIColor *lineColor;

@property (nonatomic, assign) IBInspectable BOOL topLine;
@property (nonatomic, assign) IBInspectable BOOL bottomLine;
@property (nonatomic, assign) IBInspectable BOOL leftLine;
@property (nonatomic, assign) IBInspectable BOOL rightLine;

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end
