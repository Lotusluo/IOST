//
//  ZRSCustomBtn.m
//  Camp
//
//  Created by 周荣水 on 2017/1/11.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ZRSCustomBtn.h"

@implementation ZRSCustomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setBorderWidth:(CGFloat)borderWidth{
    if (borderWidth <0 ) return;
    self.layer.borderWidth = borderWidth;
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

@end
