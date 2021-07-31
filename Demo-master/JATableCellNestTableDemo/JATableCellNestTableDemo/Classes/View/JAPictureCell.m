//
//  JAPictureCell.m
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/28.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import "JAPictureCell.h"
#import "JADataModel.h"
#import "UIImageView+WebCache.h"

@interface JAPictureCell ()


@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation JAPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPics:(picurls *)pics
{
    _pics = pics;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:pics.img]];
}
@end
