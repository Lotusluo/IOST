//
//  MyView.m
//  StrokedFilledTriangle
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 0.2);
    //填充白色背景
    [[UIColor blueColor] setFill];
    UIRectFill(rect);
    
    //自定义图形上下文

    CGContextMoveToPoint (context, 75, 10);
    CGContextAddLineToPoint (context, 10, 150);
    CGContextAddLineToPoint (context, 160, 150);
    CGContextSetAlpha(context, 0.2);
    CGContextClosePath(context);
    // 设置黑色描边参数
    [[UIColor blackColor] setStroke];
    // 设置红色条填充参数
    [[UIColor redColor] setFill];
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

//需要调用setNeedsDisplay 或者 setNeedsDisplayInRect:方法去实现调用。
//
//1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。
//
//2、该方法在调用sizeThatFits后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
//
//3、通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
//
//4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0. 以上1,2推荐；而3,4不提倡


@end
