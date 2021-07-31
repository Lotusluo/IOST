# iOS14UIPageControlFix
兼容iOS14下设置currentImage

在iOS14下UIPageControl的currentImage与pageImage私有属性被删除了，但是保留了方法设置_setPageImage，然而没什么用。反汇编看了下，系统就是直接在里面抛了个异常，打印了下日志。不知道算不算警告开发者，别瞎j8搞

```objc
// 兼容iOS14与iOS14之前
- (void)ios14_zjhourSetCurrentImage:(UIImage *)currentImage pageImage:(UIImage *)pageImage;
```

因为iOS14系统提供了设置图片的方法，但是系统的方法要配合color相关的方法来处理，会对设置的图片做tintColor的处理，因此本方法思路是拦截系统pageControl指示器图片设置图片对图片的渲染
