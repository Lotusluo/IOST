//
//  JANestCell.h
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/27.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class dayjourney;

static NSString *const JANestCellIdentifier = @"JANestCell";

@interface JANestCell : UITableViewCell

@property (nonatomic,strong) dayjourney *dayModel;

@end
