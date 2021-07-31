//
//  JALablelCell.h
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/28.
//  Copyright © 2016年 littleBoy. All rights reserved.
//
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#import <UIKit/UIKit.h>

static NSString *const JALablelCellIdentifier = @"JALablelCell";

@interface JALablelCell : UITableViewCell

@property (nonatomic,copy) NSString *title;

@end
