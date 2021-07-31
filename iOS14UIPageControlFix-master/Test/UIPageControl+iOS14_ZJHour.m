//
//  UIPageControl+iOS14_ZJHour.m
//  Test
//
//  Created by wsong on 2020/9/22.
//

#import "UIPageControl+iOS14_ZJHour.h"
#import <objc/runtime.h>

@interface UIPageControl ()

@property (nonatomic, strong) UIImage *ios14_zjhour_currentImage;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIImageView *> *ios14_zjhour_indicatorImages;

@end

@implementation UIPageControl (iOS14_ZJHour)

static BOOL ios14_zjhour_shouldTreatImageAsTemplate(UIImageView *obj, SEL sel, id arg1) {

    UIPageControl *pageControl = (id)obj;
    while ((pageControl = (id)pageControl.superview)) {
        if ([pageControl isKindOfClass:[UIPageControl class]]) {
            if (pageControl.ios14_zjhour_currentImage) {
                [pageControl.ios14_zjhour_indicatorImages setValue:obj forKeyPath:[[obj valueForKeyPath:@"_page"] description]];
                return NO;
            } else {
                break;
            }
        }
    }
    // 默认走系统的实现
    return ((BOOL (*)(UIView *, SEL, id))class_getMethodImplementation(obj.superclass, sel))(obj, sel, arg1);
}

+ (void)load {
    if (@available(iOS 14, *)) {
        Class clazz = NSClassFromString(@"_UIPageIndicatorView");
        SEL sel = NSSelectorFromString(@"_shouldTreatImageAsTemplate:");
        class_addMethod(clazz, sel, (IMP)ios14_zjhour_shouldTreatImageAsTemplate, method_getTypeEncoding(class_getInstanceMethod(clazz, sel)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setCurrentPage:)),
                                       class_getInstanceMethod(self, @selector(ios14_zjhour_setCurrentPage:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setNumberOfPages:)),
                                       class_getInstanceMethod(self, @selector(ios14_zjhour_setNumberOfPages:)));
    }
}

- (void)ios14_zjhour_setCurrentPage:(NSInteger)currentPage {
    [self ios14_zjhour_setCurrentPage:currentPage];
    [self ios14_zjhour_pageControlValueChange];
}

- (void)ios14_zjhour_setNumberOfPages:(NSInteger)numberOfPages {
    NSInteger currentPage = self.currentPage;
    [self ios14_zjhour_setNumberOfPages:numberOfPages];
    
    if (numberOfPages <= currentPage) {
        [self setIndicatorImage:self.ios14_zjhour_currentImage forPage:self.currentPage];
    }
    [self ios14_zjhour_refreshIndicatorTintColor];
}

- (void)setIos14_zjhour_currentImage:(UIImage *)ios14_zjhour_currentImage {
    objc_setAssociatedObject(self, @selector(ios14_zjhour_currentImage), ios14_zjhour_currentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)ios14_zjhour_currentImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableDictionary<NSString *, UIImageView *> *)ios14_zjhour_indicatorImages {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

/** 设置page control图片 */
- (void)ios14_zjhourSetCurrentImage:(UIImage *)currentImage pageImage:(UIImage *)pageImage {
    if (@available(iOS 14, *)) {
        self.ios14_zjhour_currentImage = currentImage;
        self.preferredIndicatorImage = pageImage;
        [self removeTarget:self action:@selector(ios14_zjhour_pageControlValueChange) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(ios14_zjhour_pageControlValueChange) forControlEvents:UIControlEventValueChanged];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ios14_zjhour_refreshIndicatorTintColor];
        });
    } else {
        [self setValue:currentImage forKeyPath:@"_currentPageImage"];
        [self setValue:pageImage forKeyPath:@"_pageImage"];
    }
}

- (void)ios14_zjhour_pageControlValueChange {
    NSLog(@"ios14_zjhour_pageControlValueChange");
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        if (i == self.currentPage) {
//            [self setIndicatorImage:self.ios14_zjhour_currentImage forPage:self.currentPage];
        } else {
//            [self setIndicatorImage:self.preferredIndicatorImage forPage:i];
        }
    }
}

- (void)ios14_zjhour_refreshIndicatorTintColor {
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        [self.ios14_zjhour_indicatorImages[@(i).description] tintColorDidChange];
    }
}

@end
