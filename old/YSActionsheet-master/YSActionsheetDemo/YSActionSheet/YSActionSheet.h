//
//  LYSActionSheet.h
//  TestCustomUIActionSheet
//
//  Created by Winson on 16/5/19.
//  Copyright © 2016年 microlink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBlock)(NSInteger selectIndex, NSString *selectStr);

@class YSActionSheet;

@protocol YSActionSheetDelegate <NSObject>

@optional 

- (void)ysActionSheet:(YSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;

@end



@interface YSActionSheet : UIView

@property (nonatomic, readonly) NSInteger cancelButtonIndex;
@property (assign, nonatomic) id<YSActionSheetDelegate>delegate;
@property (copy, nonatomic) SelectBlock selectBlock;

- (instancetype)initWithButtonTitles:(NSArray *)buttons cancelButtonTitle:(NSString *)cancelTitle;

- (void)show;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;

@end
