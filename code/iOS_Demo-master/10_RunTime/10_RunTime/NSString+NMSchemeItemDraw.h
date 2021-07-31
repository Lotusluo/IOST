//
//  NSString+NMSchemeItemDraw.h
//  10_RunTime
//
//  Created by luotao on 2021/7/2.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NMSchemeItemDraw)

-(void)  drawWithBasePoint:(CGPoint)basePoint
                 andAngle:(CGFloat)angle
                   andFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
