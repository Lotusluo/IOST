//
//  ViewController.m
//  Test
//
//  Created by wsong on 2020/9/17.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UIPageControl+iOS14_ZJHour.h"
#import "Test.h"

@interface UIColor (x)

@end

@implementation UIColor (x)

+ (void)load {
//    method_exchangeImplementations(class_getClassMethod([UIColor class], @selector(systemBlueColor)), class_getClassMethod([UIColor class], @selector(test_systemBlueColor)));
}

+ (void)test_systemBlueColor {
//    [self test_systemBlueColor];
}

@end

@interface ViewController ()

@end

@implementation ViewController

static void setColor(id obj, SEL sel, id color) {

}

static void setImage(id obj, SEL sel, id image) {
    void (*fp)(id, SEL, UIImage *image) = class_getMethodImplementation([obj class], @selector(t_setImage:));
    fp(obj, sel, image);
}
//
+ (void)load {
//    Class clazz = NSClassFromString(@"_UIPageIndicatorView");
//    class_addMethod(clazz, @selector(setTintColor:), (IMP)setColor, method_getTypeEncoding(class_getInstanceMethod(self, @selector(setTintColor:))));
//    class_addMethod(clazz, @selector(t_setImage:), (IMP)setImage, method_getTypeEncoding(class_getInstanceMethod(self, @selector(setImage:))));
//    method_exchangeImplementations(class_getInstanceMethod(clazz, @selector(t_setImage:)),
//                                   class_getInstanceMethod(clazz, @selector(setImage:)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 100, 200, 30)];
    
    [pc ios14_zjhourSetCurrentImage:[UIImage imageNamed:@"40"] pageImage:[UIImage systemImageNamed:@"cart"]];
    pc.numberOfPages = 5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
    
    
//    void (*fp)(id obj, SEL sel, UIImage *image) = class_getMethodImplementation([UIPageControl class], @selector(_setPageImage:));
//    UIImage *image = [UIImage imageNamed:@"40"];
//    fp(pc, @selector(_setPageImage:), image);
    
//    [pc _setPageImage:[UIImage imageNamed:@"40"]];
    
//    - (void) _setPageImage:(id)arg1 {
//
//    }
//    - (void) _setCurrentPageImage:(id)arg1 {
        
//    }
    
    
//    void (*fp)(id, SEL, NSInteger) = class_getMethodImplementation([UIPageControl class], @selector(setNumberOfPages:));
//    fp(pc, @selector(setNumberOfPages:), 5);

    
    pc.currentPage = 0;
//
//    [pc addTarget:self
//           action:@selector(test:) forControlEvents:UIControlEventValueChanged];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%zd", pc.currentPage);
//    });
//    pc.pageIndicatorTintColor = [UIColor redColor];
    
//    UIImage *image = [ imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
//    pc.preferredIndicatorImage = image;
    [self.view addSubview:pc];
}
////
//- (void)test:(UIPageControl *)pc {
//
//    NSLog(@"------%zd", pc.currentPage);
//
//    for (NSInteger i = 0; i < pc.numberOfPages; i++) {
//        if (i == pc.currentPage) {
//            [pc setIndicatorImage:[UIImage imageNamed:@"40"] forPage:pc.currentPage];
//        } else {
//            [pc setIndicatorImage:[UIImage systemImageNamed:@"cart"] forPage:i];
//        }
//    }
//
////    [pc setIndicatorImage:[UIImage imageNamed:@"4"] forPage:pc.currentPage];
//}


@end
