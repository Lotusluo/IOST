//
//  TableViewCellNoImg.m
//  CellDequeueReusableDemo
//
//  Created by Damon on 2017/11/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "TableViewCellNoImg.h"
#import "Masonry.h"

@interface TableViewCellNoImg()
@property (strong,nonatomic) UILabel *itemTitleLabel;
@property (strong,nonatomic) UILabel *itemDesLabel;
@property (strong,nonatomic) UILabel *itemPriceLabel;
@property (strong,nonatomic) UIButton *itemBuyButton;
@property (strong,nonatomic) ItemModel *model;
@end

@implementation TableViewCellNoImg

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWithModel:(ItemModel*)model
{
    _model = model;
    [self.itemTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(14);
    }];
    [self.itemDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemTitleLabel.mas_bottom).offset(9.5);
        make.left.equalTo(_itemTitleLabel);
    }];
    [self.itemPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(_itemDesLabel.mas_right);
    }];
    [self.itemBuyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-14.5);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
}

-(UILabel*)itemTitleLabel{
    if (!_itemTitleLabel) {
        _itemTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_itemTitleLabel];
        [_itemTitleLabel setTextColor:UIColorFromRGB(0x333333)];
        [_itemTitleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    [_itemTitleLabel setText:_model.itemTitle];
    [_itemTitleLabel sizeToFit];
    return _itemTitleLabel;
}

-(UILabel*)itemDesLabel{
    if (!_itemDesLabel) {
        _itemDesLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_itemDesLabel];
        [_itemDesLabel setTextColor:UIColorFromRGB(0x666666)];
        [_itemDesLabel setFont:[UIFont systemFontOfSize:14]];
    }
    [_itemDesLabel setText:_model.itemDetail];
    [_itemDesLabel sizeToFit];
    return _itemDesLabel;
}

-(UILabel*)itemPriceLabel{
    if (!_itemPriceLabel) {
        _itemPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_itemPriceLabel];
        [_itemPriceLabel setTextColor:UIColorFromRGB(0xff167b)];
        [_itemPriceLabel setFont:[UIFont systemFontOfSize:28]];
    }
    [_itemPriceLabel setText:_model.price];
    [_itemPriceLabel sizeToFit];
    return _itemPriceLabel;
}

-(UIButton*)itemBuyButton{
    if (!_itemBuyButton) {
        _itemBuyButton = [[UIButton alloc] init];
        [_itemBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_itemBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_itemBuyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_itemBuyButton setBackgroundColor:UIColorFromRGB(0xff69ab)];
        [_itemBuyButton addTarget:self action:@selector(startPay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_itemBuyButton];
        _itemBuyButton.layer.masksToBounds = YES;
        _itemBuyButton.layer.cornerRadius = 15;
    }
    return _itemBuyButton;
}

-(void)startPay{
    NSLog(@"购买");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
