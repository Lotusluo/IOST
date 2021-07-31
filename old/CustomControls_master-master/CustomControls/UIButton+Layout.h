//
//  UIButton+Layout.h
//  YLButton
//
//  Created by 周荣水 on 2017/1/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIButton (Layout)

@property (nonatomic,assign) IBInspectable CGRect titleRect;
@property (nonatomic,assign) IBInspectable CGRect imageRect;

@end
