//
//  CCImageDetailViewController.h
//  CCImagePicker
//
//  Created by wsk on 16/8/22.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCImageDetailViewController : UIViewController

@property (nonatomic,assign)NSUInteger pageIndex;

+ (CCImageDetailViewController *)previewControllerForPageIndex:(NSUInteger)pageIndex;

@end
