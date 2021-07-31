//
//  ZSDOptionItem.h
//  demo
//
//  Created by zhaoxiao on 15/2/12.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//--------------下拉选择实体-----------------

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZSDOptionItem : NSObject

@property (nonatomic,copy) UIImage *optionImage;
@property (nonatomic,copy) UIImage *optionSelectedImage;
@property (nonatomic,copy) NSString *optionText;

@end
