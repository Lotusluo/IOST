//
//  JAHeaderFooterView.m
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/29.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import "JAHeaderFooterView.h"

@interface JAHeaderFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblSectionTitle;

@property (weak, nonatomic) IBOutlet UIView *topLine;

@end

@implementation JAHeaderFooterView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lblDay.textColor = [UIColor whiteColor];
    self.lblDay.font = [UIFont boldSystemFontOfSize:20.0f];
    self.lblSectionTitle.textColor = [UIColor whiteColor];
    self.lblSectionTitle.font = [UIFont systemFontOfSize:16.0f];
    
    self.lblSectionTitle.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 83.0f;
}

- (void)configureTitleDay:(NSString *)title subTitle:(NSString *)subTitle isNeedHideTopLine:(BOOL)hideTopLine
{
    self.lblDay.text = title;
    self.lblSectionTitle.text = subTitle;
    self.topLine.hidden = hideTopLine;
}

@end
