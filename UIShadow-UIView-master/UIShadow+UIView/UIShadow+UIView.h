//
//  UIShadow+UIView.h
//  PageTest
//
//  Created by 王文科 on 2019/6/11.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface  UIView(UIShadow_UIImageView)

@property (nonatomic, strong, nullable) CALayer   *shadow_layer;

@property (nonatomic, strong) UIColor   *shadow_color;
@property (nonatomic, assign) CGSize    shadow_offset;
@property (nonatomic, assign) CGFloat   shadow_radius;
@property (nonatomic, assign) CGFloat   shadow_corner_radius;
@property (nonatomic, assign) CGFloat   shadow_opacity;
@property (nonatomic, assign) CGPathRef shadow_path;
@property (nonatomic, getter=isShowShadowLayer) BOOL showShadowLayer;

- (void)showDefaultShadow;

@end

NS_ASSUME_NONNULL_END
