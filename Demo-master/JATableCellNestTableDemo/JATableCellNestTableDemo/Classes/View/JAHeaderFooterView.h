//
//  JAHeaderFooterView.h
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/29.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const JAHeaderFooterViewIdentifier = @"JAHeaderFooterView";

@interface JAHeaderFooterView : UITableViewHeaderFooterView

- (void)configureTitleDay:(NSString *)title subTitle:(NSString *)subTitle isNeedHideTopLine:(BOOL)hideTopLine;

@end
