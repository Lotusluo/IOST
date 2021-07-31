//
//  MyView.m
//  BezierCurve
//
//  Created by tony on 2017/3/23.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  作者微信：tony关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

#import "MyView.h"

@implementation MyView

- (void)drawRect:(CGRect)rect {
    
    //填充白色背景
//    [[UIColor blackColor] setFill];
//    UIRectFill(rect);
//
//    //自定义图形上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint (context, 75, 10);
//    CGContextAddLineToPoint (context, 10, 150);
//    CGContextAddLineToPoint (context, 160, 150);
//    CGContextClosePath(context);
//    // 设置黑色描边参数
//    [[UIColor blackColor] setStroke];
//    // 设置红色条填充参数
//    [[UIColor redColor] setFill];
//    //绘制路径
//    CGContextDrawPath(context, kCGPathFillStroke);

    //填充白色背景
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddCurveToPoint(context, 0, 0, 0, 50, 50, 0);
//    CGContextAddCurveToPoint(context, 330, 26, 299, 20, 299, 17);
//    CGContextAddLineToPoint(context, 296, 17);
//    CGContextAddCurveToPoint(context, 296, 17, 296, 19, 291, 19);
//    CGContextAddLineToPoint(context, 250, 19);
//    CGContextAddCurveToPoint(context, 250, 19, 241, 24, 238, 19);
//    CGContextAddCurveToPoint(context, 236, 20, 234, 24, 227, 24);
//    CGContextAddCurveToPoint(context, 220, 24, 217, 19, 216, 19);
//    CGContextAddCurveToPoint(context, 214, 20, 211, 22, 207, 20);
//    CGContextAddCurveToPoint(context, 207, 20, 187, 20, 182, 21);
//    CGContextAddLineToPoint(context, 100, 45);
//    CGContextAddLineToPoint(context, 97, 46);
//    CGContextAddCurveToPoint(context, 97, 46, 86, 71, 64, 72);
//    CGContextAddCurveToPoint(context, 42, 74, 26, 56, 23, 48);
//    CGContextAddLineToPoint(context, 9, 47);
//    CGContextAddCurveToPoint(context, 9, 47, 0, 31, 0, 0);
    [[UIColor redColor] setStroke];
    CGContextStrokePath(context);

}

@end
