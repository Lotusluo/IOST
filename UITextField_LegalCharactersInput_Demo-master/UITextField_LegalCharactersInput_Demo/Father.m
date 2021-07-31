//
//  Father.m
//  UITextField_LegalCharactersInput_Demo
//
//  Created by luotao on 2021/6/19.
//  Copyright © 2021 AlezJi. All rights reserved.
//



//1   调用当前视图的pointInside:withEvent:方法判断触摸点是否在当前视图内。
//
//2   返回NO，则hitTest:withEvent:返回nil；若返回YES，则向当前视图的所有子视图发送hitTest:withEvent:消息，从最顶层视图一直到最底层视图即从subviews数组的末尾向前遍历，知道有子视图返回非空对象或者全部子视图遍历完。
//
//3 若有子视图返回非空对象，则hitTest:withEvent:方法返回此对象，处理结束。如所有子视图都返回nil，则返回自身(self)。


#import "Father.h"

@implementation Father

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"Father pointInside:%@",NSStringFromCGPoint(point));
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"Father hitTest");
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Father touchesBegan");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
