//
//  OptionCell.m
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import "OptionCell.h"

@interface OptionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end

@implementation OptionCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setOptionItem:(ZSDOptionItem *)optionItem
{
    if(_optionItem != optionItem)
    {
        _optionItem = optionItem;
        
        _iconImageView.image = _optionItem.optionImage;
        _optionLabel.text = _optionItem.optionText;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        _optionLabel.textColor = [UIColor redColor];
        [_selectionImageView setHidden:NO];
    }
    else
    {
        _optionLabel.textColor = [UIColor blackColor];
        [_selectionImageView setHidden:YES];
    }
}

@end
