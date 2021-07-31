//
//  ZRSCustomDottedLine.m
//  Camp
//
//  Created by 周荣水 on 2017/1/13.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ZRSCustomDottedLine.h"


#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


@interface ZRSCustomDottedLine()
{
    CAShapeLayer *m_shapeLayer;
}

@end

@implementation ZRSCustomDottedLine


- (void)setLineColor:(UIColor *)lineColor{
    if(_lineColor != lineColor){
        _lineColor = lineColor;
    }
    [self setNeedsDisplay];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
    }
    [self setNeedsDisplay];
}



-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{

    
    m_shapeLayer = [CAShapeLayer layer];
    
    [m_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [m_shapeLayer setStrokeColor:[self.lineColor CGColor]];
    //设置虚线的宽度
    [m_shapeLayer setLineWidth:self.lineWidth];
    [m_shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [m_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:self.lineWidth],[NSNumber numberWithInt:5],[NSNumber numberWithInt:4],[NSNumber numberWithInt:4],nil]];
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    

    if (self.topLine) {
        CGPathMoveToPoint(path,NULL ,0, SINGLE_LINE_ADJUST_OFFSET);
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect), SINGLE_LINE_ADJUST_OFFSET);
    }
    if (self.bottomLine) {
        CGPathMoveToPoint(path,NULL ,0, CGRectGetHeight(rect)-SINGLE_LINE_ADJUST_OFFSET);
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect), CGRectGetHeight(rect)-SINGLE_LINE_ADJUST_OFFSET);
    }
    if (self.leftLine) {
        CGPathMoveToPoint(path,NULL ,SINGLE_LINE_ADJUST_OFFSET, 0);
        CGPathAddLineToPoint(path, NULL,SINGLE_LINE_ADJUST_OFFSET, CGRectGetHeight(rect));
    }
    if (self.rightLine) {
        CGPathMoveToPoint(path,NULL ,CGRectGetWidth(rect)-SINGLE_LINE_ADJUST_OFFSET, 0);
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect)-SINGLE_LINE_ADJUST_OFFSET, CGRectGetHeight(rect));
    }
    
    [m_shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:m_shapeLayer];
    
    
//    //实现动画
    [m_shapeLayer setLineDashPhase:1];
    
    [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(movePhase) userInfo:nil repeats:self.isMove] fire];
    
    [self setNeedsDisplay];
}

-(void)movePhase
{
    m_shapeLayer.lineDashPhase--;
}


@end
