//
//  JALablelCell.m
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/28.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import "JALablelCell.h"

@interface JALablelCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation JALablelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lblTitle.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 99.0f;
    
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.lblTitle.text = title;
    
}
@end
