//
//  JAPictureCell.h
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/28.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class picurls;

static NSString *const JAPictureCellIdentifier = @"JAPictureCell";

@interface JAPictureCell : UITableViewCell

@property (nonatomic,strong) picurls *pics;

@end
