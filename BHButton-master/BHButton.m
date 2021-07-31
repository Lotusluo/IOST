//
//  BHButton.m
//  自定义button
//
//  Created by sunny on 16/7/23.
//  Copyright © 2016年 sunny. All rights reserved.
//

#import "BHButton.h"
#import "UIView+BH.h"
#import "constant.h"

@interface BHButton ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *imageView;

@end

static NSInteger const smallImageWH = 30;
static NSInteger const bigImageWH = 46;

static NSInteger const smallDistance = 10;
static NSInteger const bigDistance = 20;

static NSInteger const bigFont = 15;
static NSInteger const smallFont = 12;

@implementation BHButton

+ (BHButton *)createButtonItemWIthtitle:(NSString *)title
                                  imageName:(NSString *)imageName
                             buttonItemType:(BHButtonItemType)imageType
{
    BHButton *item = [[BHButton alloc] initWithTitle:title imageName:imageName buttonItemType:imageType];
    item.title = title;
    item.imageName = imageName;
    item.imageType = imageType;
    return item;
}

- (id)initWithTitle:(NSString *)title imageName:(NSString *)imageName buttonItemType:(BHButtonItemType)imageType
{
    self = [super init];
    if (self) {
        
        _title = title;
        _imageType = imageType;
        _imageName = imageName;
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        self.backgroundColor = BHColorWithSix(BHAppWhiteColor);
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_imageType == BHButtonItemTypeBigImage) {
        
        //整体的高度：121
        
        self.imageView.frame = CGRectMake(self.width / 2 - bigImageWH / 2, self.height / 2 - 41, bigImageWH, bigImageWH);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + bigDistance, self.width, bigFont + 2);
    }
    if (_imageType == BHButtonItemTypeSmallImage) {
        
        //整体的高度：72
        self.imageView.frame = CGRectMake(self.width / 2 - smallImageWH / 2, self.height / 2 - 26, smallImageWH, smallImageWH);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + smallDistance, self.width, smallFont + 2);
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setImageType:(BHButtonItemType)imageType
{
    _imageType = imageType;
    
    CGRect fram = self.frame;
    
    [self setFrame:fram];
    
    if (imageType == BHButtonItemTypeBigImage) {
        _titleLabel.font = [UIFont systemFontOfSize:bigFont];
        _titleLabel.textColor = BHColorWithSix(BHAppWhiteColor);
    }
    if (imageType == BHButtonItemTypeSmallImage) {
        _titleLabel.font = [UIFont systemFontOfSize:smallFont];
        _titleLabel.textColor = BHColorWithSix(BHAppBlackColor);
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        if (_imageType == BHButtonItemTypeBigImage) {
            _titleLabel.font = [UIFont systemFontOfSize:bigFont];
            _titleLabel.textColor = BHColorWithSix(BHAppWhiteColor);
        }
        if (_imageType == BHButtonItemTypeSmallImage) {
            _titleLabel.font = [UIFont systemFontOfSize:smallFont];
            _titleLabel.textColor = BHColorWithSix(BHAppBlackColor);
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

//重写UIControl的方法
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (_imageType == BHButtonItemTypeBigImage) {
        _titleLabel.textColor = [UIColor grayColor];
    }
    if (_imageType == BHButtonItemTypeSmallImage) {
        self.backgroundColor = [UIColor grayColor];
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (_imageType == BHButtonItemTypeBigImage) {
        _titleLabel.textColor = [UIColor grayColor];
    }
    if (_imageType == BHButtonItemTypeSmallImage) {
        self.backgroundColor = [UIColor grayColor];
    }
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (_imageType == BHButtonItemTypeBigImage) {
        _titleLabel.textColor = BHColorWithSix(BHAppWhiteColor);
    }
    if (_imageType == BHButtonItemTypeSmallImage) {
        self.backgroundColor = BHColorWithSix(BHAppWhiteColor);
    }
    
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    if (_imageType == BHButtonItemTypeBigImage) {
        _titleLabel.textColor = BHColorWithSix(BHAppWhiteColor);
    }
    if (_imageType == BHButtonItemTypeSmallImage) {
        self.backgroundColor = BHColorWithSix(BHAppWhiteColor);
    }
    [super cancelTrackingWithEvent:event];
}

@end
