//
//  PdIndicatorView.h
//  scrollDemo
//
//  Created by light_bo on 2018/11/20.
//  Copyright © 2018年 light_bo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PdIndicatorView : UIView

- (void)scrollAction:(NSInteger )index isLeft:(BOOL)isLeft ;
- (void)initDataWithCount:(NSInteger)count ;

@end
