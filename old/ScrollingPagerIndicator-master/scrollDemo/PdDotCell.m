//
//  PdDotCell.m
//  scrollDemo
//
//  Created by light_bo on 2018/11/19.
//  Copyright © 2018年 light_bo. All rights reserved.
//

#import "PdDotCell.h"
@interface PdDotCell ()

//@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *imageButton;
@end

@implementation PdDotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.imageButton setImage:[UIImage imageNamed:@"indicator_dot_small"] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:@"indicator_dot_big"] forState:UIControlStateSelected];
    [self addSubview:self.imageButton];

}

- (void)setImageSelected:(BOOL)imageSelected {

    if (imageSelected) {
        self.imageButton.selected = YES;
    }
    else {
        self.imageButton.selected  =  NO;
    }
}

- (void)setImageName:(NSString *)imageName {
    [self.imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  //  self.imageButton.selected = selected;
    // Configure the view for the selected state
}

@end
