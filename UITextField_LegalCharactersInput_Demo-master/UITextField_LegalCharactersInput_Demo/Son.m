//
//  Son.m
//  UITextField_LegalCharactersInput_Demo
//
//  Created by luotao on 2021/6/19.
//  Copyright © 2021 AlezJi. All rights reserved.
//

#import "Son.h"

@implementation Son

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"Son pointInside");
    return YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"Son hitTest");
    return [super hitTest:point withEvent:event];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Son touchesBegan");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
