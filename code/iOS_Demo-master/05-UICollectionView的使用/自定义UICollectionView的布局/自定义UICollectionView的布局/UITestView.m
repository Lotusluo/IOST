//
//  UITestView.m
//  自定义UICollectionView的布局
//
//  Created by mac on 2021/4/8.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import "UITestView.h"

@interface UITestView()

@property(nonatomic) NSTimer* timer;

@end

@implementation UITestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor darkGrayColor];
   
    NSLog(@"%s","awakeFromNib");

    
    [NSThread detachNewThreadSelector:@selector(threadMethod) toTarget:self withObject:nil];
}

- (void)threadMethod{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    CFRunLoopRun();
}



-(void)timerMethod:(NSTimer*) timer{
    NSLog(@"repeat");
    dispatch_async(dispatch_get_main_queue(), ^{
        _testView.text = @"repeat";
    });
}

@end
