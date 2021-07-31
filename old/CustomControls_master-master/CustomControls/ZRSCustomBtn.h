//
//  ZRSCustomBtn.h
//  Camp
//
//  Created by 周荣水 on 2017/1/11.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface ZRSCustomBtn : UIButton

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end
