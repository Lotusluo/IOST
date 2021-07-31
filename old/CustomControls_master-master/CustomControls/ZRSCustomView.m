//
//  ZRSCustomView.m
//  Camp
//
//  Created by 周荣水 on 2017/1/10.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ZRSCustomView.h"


#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@interface ZRSCustomView()

@end

@implementation ZRSCustomView

- (void)setLineColor:(UIColor *)lineColor{
    if(_lineColor != lineColor){
        _lineColor = lineColor;
    }
    [self setNeedsDisplay];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    if (borderWidth <0 ) return;
    self.layer.borderWidth = borderWidth;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        
        [self.lineColor setStroke];
        if (self.topLine) {
            CGContextMoveToPoint(context, 0, SINGLE_LINE_ADJUST_OFFSET);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), SINGLE_LINE_ADJUST_OFFSET);
        }
        if (self.bottomLine) {
            CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-SINGLE_LINE_ADJUST_OFFSET);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-SINGLE_LINE_ADJUST_OFFSET);
        }
        if (self.leftLine) {
            CGContextMoveToPoint(context, SINGLE_LINE_ADJUST_OFFSET, 0);
            CGContextAddLineToPoint(context, SINGLE_LINE_ADJUST_OFFSET,CGRectGetHeight(rect));
        }
        if (self.rightLine) {
            CGContextMoveToPoint(context, CGRectGetWidth(rect)-SINGLE_LINE_ADJUST_OFFSET, 0);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect)-SINGLE_LINE_ADJUST_OFFSET,CGRectGetHeight(rect));
        }
        
        
        CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
        CGContextStrokePath(context);
    
    
    [self setNeedsDisplay];
}






@end
