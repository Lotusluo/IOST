//
//  UIView+XX.m
//  adasdasdasd
//
//  Created by luotao on 2021/6/22.
//

#import "UIView+XX.h"
#import <objc/runtime.h>

@implementation UIView (XX)

//+ (void)load {
//    Method sendAction = class_getInstanceMethod(self,@selector(layoutSubviews));
//    Method customSendAction = class_getInstanceMethod(self,@selector(customLayoutSubviews));
//    method_exchangeImplementations(sendAction, customSendAction);
//    NSLog(@"UIView load");
//}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(ritl_borderlayoutsubViews));
        
        BOOL didAddMethod = class_addMethod(self, @selector(layoutSubviews), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {//追加成功，进行替换
            
            class_replaceMethod(self,
                                @selector(layoutSubviews),
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
        }else {
            
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

-(void)ritl_borderlayoutsubViews{
    [self ritl_borderlayoutsubViews];
    NSLog(@"customLayoutSubviews");
}

@end
