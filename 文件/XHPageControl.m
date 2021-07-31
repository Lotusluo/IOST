#import "XHPageControl.h"

@interface XHPageControl()

@property (nonatomic) CGSize size;

@end

@implementation XHPageControl

- (instancetype)initWithFrame:(CGRect)frame currentImage:(UIImage *)currentImage andDefaultImage:(UIImage *)defaultImage {
    
    self = [super initWithFrame:frame];
    self.currentImage = currentImage;
    self.defaultImage = defaultImage;
    return self;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)setUpDots {
    
    if (self.currentImage && self.defaultImage) {
        self.size = self.currentImage.size;
    } else {
        self.size = CGSizeMake(kScale_Space(10), kScale_Space(10));
    }
    
    if (self.pageSize.height && self.pageSize.width) {
        self.size = self.pageSize;
    }
    
    for (int i = 0; i < [self.subviews count]; i++) {
        
        UIView *dot = [self.subviews objectAtIndex:i];
        
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, self.size.width, self.size.width)];
        if ([dot.subviews count] == 0) {
            UIImageView *view = [[UIImageView alloc]initWithFrame: dot.bounds];
            [dot addSubview:view];
        };
        UIImageView *view = dot.subviews[0];
        if (i == self.currentPage) {
            if (self.currentImage) {
                view.image = self.currentImage;
                dot.backgroundColor = [UIColor clearColor];
            } else {
                view.image = nil;
                dot.backgroundColor = self.currentPageIndicatorTintColor;
            }
        } else if (self.defaultImage) {
            view.image = self.defaultImage;
            dot.backgroundColor = [UIColor clearColor];
        } else {
            view.image = nil;
            dot.backgroundColor = self.pageIndicatorTintColor;
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    WS(weakSelf);
    if(@available(iOS 14.0, *)) {  //  兼容iOS 14
    // 因为项目用SDAutoLayout框架布局，需PageControl布局完才能获取到全体的subView。其他布局直接 调用setPageControlImage方法。
        [self setDidFinishAutoLayoutBlock:^(CGRect frame) { 
            [weakSelf setPageControlImage];
        }];
    } else {
        [self setUpDots];
    }
}

- (void)setPageControlImage {
    
    UIView *fview1 = self;
    
    UIView *subView1 = fview1.subviews.firstObject;
    
    fview1 = subView1;
    
    subView1 = fview1.subviews.firstObject;
    
    fview1 = subView1;
    
    subView1 = fview1.subviews.firstObject;
    
    if(subView1 && [subView1 isKindOfClass:[UIImageView class]]) {
        [self modfinPageControlSubViews:fview1];
    }
}

- (void)modfinPageControlSubViews:(UIView *)fView {
    
    for(int i = 0; i < [fView.subviews count]; i++)  {
        
        UIImageView *dot = [fView.subviews objectAtIndex:i];
        [dot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        dot.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [UIImageView new];
        if (i == self.currentPage) {
            
            imageView.frame = CGRectMake(0, 0, self.currentImage.size.width, self.currentImage.size.height);
            imageView.image = self.currentImage;
            [dot addSubview:imageView];
            
        } else {
            
            imageView.frame = CGRectMake(0, 0, self.defaultImage.size.width, self.defaultImage.size.height);
            imageView.image = self.defaultImage;
            [dot addSubview:imageView];
        }
    }
}

@end