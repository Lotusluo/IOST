# UIShadow-UIView
- 给UIImageView添加直角、圆角阴影
- [https://www.jianshu.com/p/8a249043df02](https://www.jianshu.com/p/8a249043df02)


##### pod 导入
> pod  'UIShadow+UIView'

#### 或者解压下载的文件，拖入UIShadow+UIView文件夹到你的项目

> 使用时导入头文件 UIShadow+UIView.h


<img src='https://github.com/wangxiaocan/UIShadow-UIView/blob/master/IMG_3253.png' width='300px' alt='效果图'/>


### how to use

> #import "UIShadow+UIView.h"

```Object-C
_coverImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.jpg"]];
_coverImgView.bounds = CGRectMake(0, 0, 240, 320);
_coverImgView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
_coverImgView.shadow_opacity = 1.0;
_coverImgView.shadow_color = [UIColor redColor];
_coverImgView.shadow_offset = CGSizeZero;
_coverImgView.shadow_radius = 3.0;
_coverImgView.shadow_corner_radius = 6.0;
_coverImgView.showShadowLayer = YES;
[self.view addSubview:_coverImgView];
    
//    or use below function
//    [_coverImgView showDefaultShadow];
```



