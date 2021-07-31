//
//  MyView.m
//  ImageStringSample
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
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
//
//    UIImage* image = [UIImage imageNamed:@"dog"];
//
//    //设置一个rect矩形区域
//    CGRect imageRect = CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width);
//    //绘制图片
////    [image drawInRect:CGRectMake(0, 0, 50, 20)];
//    //[image drawAtPoint:CGPointMake(0, 40)];
//    [image drawAsPatternInRect:CGRectMake(0, 0, 100, 200)];
    
//    //绘制未开通音乐权限提示
//    CGFloat height = self.bounds.size.height;
//    CGFloat halfValue = height / 2;
    CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSaveGState(context);


        // Create text
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        NSString *string = @"some test string";
        UIFont *font = [UIFont systemFontOfSize:16.0];

        
        //4.根据text的font和字符串自动算出size（重点）
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    NSLog(@"size:%@",NSStringFromCGSize(size));

        // Rotate the context 90 degrees (convert to radians)
        CGAffineTransform transform1 = CGAffineTransformMakeRotation(0.1);
        CGContextConcatCTM(context, transform1);

        // Move the context back into the view
//        CGContextTranslateCTM(context, -rect.size.height, 0);

        // Draw the string
        [string drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];

        // Clean up

        CGContextRestoreGState(context);
  

    //CGRect stringRect = CGRectMake(xpos, 60, 100, 40);
    //[title drawInRect:stringRect withAttributes:attr];
}

@end
