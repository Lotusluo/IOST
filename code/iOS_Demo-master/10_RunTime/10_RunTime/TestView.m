//
//  TestView.m
//  10_RunTime
//
//  Created by luotao on 2021/7/2.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import "TestView.h"
#import "JCGCDTimer.h"
#import "NSString+NMSchemeItemDraw.h"

@interface TestView()

@property(nonatomic)CGFloat angle;

@end

@implementation TestView


-(void)awakeFromNib{
    [super awakeFromNib];
//    [JCGCDTimer timerTask:^{
//        self.angle += 0.1;
//        [self setNeedsDisplay];
//    } start:1 interval:1 repeats:YES async:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    //绘制未开通音乐权限提示
    CGFloat height = self.bounds.size.height;
    CGFloat halfValue = height / 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint (context, 0, halfValue);
    CGContextAddLineToPoint (context, halfValue, height);
    CGContextAddLineToPoint (context, 20, height);
    CGContextAddLineToPoint (context, 0, height - 20);
    CGContextClosePath(context);
    [[UIColor orangeColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
//    //弧度
//    CGFloat radian = angleBetweenPoints(CGPointMake(halfValue, height),CGPointMake(0, halfValue));
//    CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
//    CGAffineTransformRotate(trans, 45);
////    CGAffineTransformTranslate(trans, -pos.x, -pos.y);
//    CGContextConcatCTM(context, trans);
////    CGContextTranslateCTM(context, 0, 10);
    ////    CGSize size = [tip sizeWithAttributes:@{NSFontAttributeName:font}];
    //    [tip drawAtPoint:pos withAttributes:@{NSFontAttributeName:font}];
    
//    CGFloat distance = distanceBetweenPoints(CGPointMake(halfValue, height),CGPointMake(0, halfValue));
//    CGFloat mDistance = distance / 2;
//    UIFont *font = [UIFont systemFontOfSize:12.0];
//    CGPoint tranPoint = CGPointMake(0 + cos(M_PI_4) * mDistance, halfValue + sin(M_PI_4) * mDistance);
//    NSString *tip = @"已开通";
//    CGSize textSize = [tip sizeWithAttributes:@{NSFontAttributeName:font}];
//    CGAffineTransform t = CGAffineTransformMakeTranslation(tranPoint.x, tranPoint.y);
//    CGAffineTransform r = CGAffineTransformMakeRotation(M_PI_4);
//    CGContextConcatCTM(context, t);
//    CGContextConcatCTM(context, r);
//    [tip drawAtPoint:CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2) withAttributes:@{NSFontAttributeName:font}];
//    CGContextConcatCTM(context, CGAffineTransformInvert(r));
//    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
};

//两点的弧度
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return rads;
}

@end
