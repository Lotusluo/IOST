//
//  BHButton.h
//  自定义button
//
//  Created by sunny on 16/7/23.
//  Copyright © 2016年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BHButtonItemType) {
    BHButtonItemTypeBigImage,  //不同图片大小的类型，图片与文字的间距不同
    BHButtonItemTypeSmallImage,
};

@interface BHButton : UIControl

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *imageName;

@property (nonatomic,assign) BHButtonItemType imageType;

+ (BHButton *)createButtonItemWIthtitle:(NSString *)title
                              imageName:(NSString *)imageName
                         buttonItemType:(BHButtonItemType)imageType;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;

@end
