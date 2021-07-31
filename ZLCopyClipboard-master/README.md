# ZLCopyClipboard
iOS开发之复制字符串到剪贴板

这次需求有复制功能,把字符串复制到系统剪贴板,

![](https://github.com/ZLFighting/ZLCopyClipboard/blob/master/ZLCopyClipboard/截图.jpeg)

> 主要思路:
1. 在 View 里贴上scrollView
2. 在scrollView里贴上 UITextView,用于上下滑动展示完整数据

```
// 邀请链接
UIView *linkView2 = [[UIView alloc] init];
linkView2.backgroundColor = [UIColor whiteColor];
linkView2.frame = CGRectMake(0, CGRectGetMaxY(line.frame), UI_View_Width, cellH);
[self.view addSubview:linkView2];
// 邀请链接label
UILabel *linkLabel2 = [[UILabel alloc] init];
linkLabel2.backgroundColor = [UIColor clearColor];
linkLabel2.frame = CGRectMake(marginX, -1, 60, cellH);
linkLabel2.text = @"邀请链接";
linkLabel2.font = setupTextLabelFont;
linkLabel2.textColor = XHHColor(102, 102, 102);
[linkView2 addSubview:linkLabel2];
// 复制按钮
UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
[copyBtn setTitle:@"复制" forState:UIControlStateNormal];
copyBtn.frame = CGRectMake(UI_View_Width - marginX - btnW, (cellH - btnH) * 0.5, btnW, btnH);
copyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
[copyBtn addTarget:self action :@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
copyBtn.backgroundColor = [UIColor whiteColor];
[copyBtn setTitleColor:XHHTitleColor forState:UIControlStateNormal];
copyBtn.layer.borderColor = XHHTitleColor.CGColor;
copyBtn.layer.cornerRadius = XHH_btnCornerRadius;
copyBtn.layer.borderWidth = 1.0f;
[linkView2 addSubview:copyBtn];
self.copylinkBtn = copyBtn;

// 滑动邀请链接
UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(linkLabel2.frame), 0, UI_View_Width - linkLabel2.width - btnW - marginX * 2, cellH)];
scrollView.showsHorizontalScrollIndicator = NO;
scrollView.showsHorizontalScrollIndicator = NO;
scrollView.bounces = NO;
[linkView2 addSubview:scrollView];

UITextView *link = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, UI_View_Width - linkLabel2.width - btnW - marginX * 2, 50)];
link.text = @"wwww.ujfwegertkyluiopafsdfghnlrjkliop[sdfghjklertyui";
link.textColor = [UIColor grayColor];
link.textContainer.maximumNumberOfLines = 1;
link.scrollEnabled = YES;//是否可以拖动
link.editable = NO;//禁止编辑
[scrollView addSubview:link];
scrollView.contentSize = CGSizeMake(CGRectGetWidth(link.bounds), 50);
self.link = link;
```

```
/**
* 复制链接
*/
- (void)copylinkBtnClick {

[MBProgressHUD showSuccess:@"复制成功!"];
UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
pasteboard.string = self.link.text;
}
```

测试效果如下:
![](https://github.com/ZLFighting/ZLCopyClipboard/blob/master/ZLCopyClipboard/运行效果.gif)

您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦
