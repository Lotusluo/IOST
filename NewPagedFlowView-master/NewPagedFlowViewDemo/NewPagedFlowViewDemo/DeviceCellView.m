//
//  DeviceCellView.m
//  NewPagedFlowViewDemo
//
//  Created by luotao on 2021/5/18.
//  Copyright © 2021 robertcell.net. All rights reserved.
//

#import "DeviceCellView.h"
#import "UIView+Inspectable.h"


@implementation DeviceCellView

- (instancetype) init{
    self = [super init];
    if(self){
        //画外边框
        self.borderColor =  [UIColor lightGrayColor];
        self.cornerRadius = 15;
        self.borderWidth = 1;
    }
    
//    //设置Vip标志
//        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
//        //设置目标图片
//        imageAttachment.image = [UIImage imageNamed:imageName];
//        //设置大小和位置
//        imageAttachment.bounds = CGRectMake(-5, -3, imageAttachment.image.size.width, imageAttachment.image.size.height);
//        //初始化富文本字符串 并携带NSTextAttachment
//        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
//        //初始化一个空的可变富文本字符串
//        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@""];
//        //拼接之前的attachmentString字符串
//        [completeText appendAttributedString:attachmentString];
//        //初始化目标富文本字符串
//        NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:title];
//        //拼接目标富文本内容
//        [completeText appendAttributedString:textAfterIcon];
//        /*备注：上边这样的顺序执行下来是先小图标在文本内容如上图一样，如果你图标想放在后面，就无需多拼接一次，直接用目标文本去拼接图标就可以，[completeText appendAttributedString:attachmentString];*/
//        [_myLabel setAttributedText:completeText];
    return self;
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow{
    //画虚线内边框
    CAShapeLayer *dash = [CAShapeLayer layer];
    dash.strokeColor = [UIColor lightGrayColor].CGColor;
    dash.fillColor = nil;
    dash.lineDashPattern = @[@4, @2];
    dash.path = [UIBezierPath bezierPathWithRoundedRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(20, 20, 20, 20)) cornerRadius:10].CGPath;
    dash.frame = self.bounds;
    [self.layer addSublayer:dash];
}

@end
