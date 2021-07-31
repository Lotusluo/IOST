//
//  ZRSCuseormImgView.h
//  Camp
//
//  Created by 周荣水 on 2017/1/10.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface ZRSCustomImgView : UIImageView

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end
