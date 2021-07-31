//
//  ViewController.m
//  SAnimationDemo
//
//  Created by Superman on 2018/9/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"

#define kTAG_BASE_VALUE 90

@interface ViewController ()
@property (strong, nonatomic)  UIView *firstView;
@property (strong, nonatomic)  UIView *secondView;
@property (strong, nonatomic)  UIView *threeView;
@property (strong, nonatomic)  UIView *fourView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    [self restartAnimation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self restartAnimation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:@"APPEnterForeground" object:nil];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APPEnterForeground" object:nil];

}
-(void)restartAnimation{
    [self startAnimationForFirstView];
    [self startAnimationForSecondView];
    [self startAnimationForThirdView];
    [self startAnimationFOrFourthView];
}
-(void)initUI{
    _firstView=[[UIView alloc]init];
    _firstView.frame=CGRectMake(165, 100, 45, 45);
//    _firstView.frame=CGRectMake(165, 174, 45, 45);
    CGRect frame=_firstView.frame;
    [self.view addSubview:_firstView];
    UIImageView *imageVIew = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian.png"];
    imageVIew.layer.anchorPoint =CGPointMake(28.5/ 45.0, 16/ 45.0);
    imageVIew.frame=frame;
    [_firstView addSubview:imageVIew];
    
    imageVIew=[self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1.png"];
    [_firstView addSubview:imageVIew];
    imageVIew=[self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2.png"];
    [_firstView addSubview:imageVIew];
    
    
    
    _secondView=[[UIView alloc]init];
    _secondView.frame=CGRectMake(165,150 , 45, 45);

    [self.view addSubview:_secondView];
//    UIImageView *ima=[self createImageViewWithFrame:_secondView.frame tag:kTAG_BASE_VALUE named:@"pic_ceshi1_biaoqian"];
    imageVIew=[self createImageViewWithFrame:_secondView.frame tag:kTAG_BASE_VALUE named:@"pic_ceshi1_biaoqian"];
    [_secondView addSubview:imageVIew];
    
    CGRect frameSec = CGRectMake(45 - 18, 0, 18, 19.5);
    UIView *contentView=[[UIView alloc]init];
    contentView.layer.anchorPoint=CGPointMake(0, 1);
    contentView.frame = frameSec;
    contentView.tag =kTAG_BASE_VALUE + 10;
    [self.secondView addSubview:contentView];
    imageVIew = [self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE named:@"pic_ceshi1_qipao(1)"];
    [contentView addSubview:imageVIew];
    imageVIew=[self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi1_zi"];
    imageVIew.layer.anchorPoint =CGPointMake(0, 1);
    imageVIew.frame = contentView.bounds;
    [contentView addSubview:imageVIew];
    
    
    _threeView=[[UIView alloc]init];
    _threeView.frame=CGRectMake(165, 200, 45, 45);
//    _threeView.frame=CGRectMake(165, 381, 45, 45);

    [self.view addSubview:_threeView];
    imageVIew=[self createImageViewWithFrame:_threeView.frame tag:kTAG_BASE_VALUE named:@"pic_ceshi3_biaoqian"];
    imageVIew.layer.anchorPoint = CGPointMake(0.5, 12/ 45.0);
    imageVIew.frame=_threeView.frame;
    [_threeView addSubview:imageVIew];
    
    
    _fourView=[[UIView alloc]init];
    _fourView.frame=CGRectMake(165, 250,45, 45);
//    _fourView.frame=CGRectMake(165, 486,45, 45);

    [self.view addSubview:_fourView];

    imageVIew=[self createImageViewWithFrame:_fourView.frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian"];
    [_fourView addSubview:imageVIew];
    imageVIew = [self createImageViewWithFrame:_fourView.frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1"];
    [self.fourView addSubview:imageVIew];
    imageVIew= [self createImageViewWithFrame:_fourView.frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2"];
    [self.fourView addSubview:imageVIew];
}


-(void)startAnimationForFirstView{
    id fromValue=[NSNumber numberWithFloat:-M_PI/10.0];
    id toValue=[NSNumber numberWithFloat:M_PI/10.0];
    UIImageView *imageView=[self.view viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
    
    fromValue=@1;
    toValue=@0.1;
    imageView=[self.firstView viewWithTag:kTAG_BASE_VALUE + 1];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
    
    fromValue=@0.1;
    toValue=@1;
    imageView =[self.firstView viewWithTag:kTAG_BASE_VALUE + 2];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
}
-(void)startAnimationForSecondView{
    id fromValue=[NSNumber numberWithFloat:-M_PI/ 12.0];
    id toValue=[NSNumber numberWithFloat:0];
    NSString *rAnimationKey =@"transform.rotation.z";
    NSString *sAnimationKey=@"transform.scale";
    
    CAAnimation *rAnimation=[self createSAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    CAAnimation *sAnimation=[self createSAnimationWithKeyPath:sAnimationKey fromValue:@0.9 toValue:@1];
    
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    animationGroup.repeatCount=HUGE_VALF;
    animationGroup.duration=1;
    animationGroup.autoreverses=YES;
    animationGroup.animations=@[rAnimation,sAnimation];
    UIView *contentView=[self.secondView viewWithTag:kTAG_BASE_VALUE + 10];
    [contentView.layer addAnimation:animationGroup forKey:nil];
    
    UIImageView *imageView=[contentView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue=[NSNumber numberWithFloat:0];
    toValue=[NSNumber numberWithFloat:-M_PI/30.0];
    CAAnimation *ziAnimation=[self createKAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    [imageView.layer addAnimation:ziAnimation forKey:nil];
}
-(void)startAnimationForThirdView{
    id fromValue=[NSNumber numberWithFloat:-M_PI/10.0];
    id toValue=[NSNumber numberWithFloat:M_PI/10.0];
    UIImageView *imageView=[self.threeView viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
}
-(void)startAnimationFOrFourthView{
    UIImageView *imageView=[self.fourView viewWithTag:kTAG_BASE_VALUE];
    id fromValue=[NSValue valueWithCGPoint:CGPointMake(45/ 2 + 1.5, 45/ 2 + 1.5)];
    id toValue=[NSValue valueWithCGPoint:CGPointMake(45/ 2 - 1.5, 45/ 2 - 1.5)];
    [self animationWithView:imageView keyPath:@"position" fromValue:fromValue toValue:toValue];
    
    imageView=[self.fourView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue=@1;
    toValue=@0.1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
    
    imageView=[self.fourView viewWithTag:kTAG_BASE_VALUE + 2];
    fromValue=@0.1;
    toValue=@1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue duration:0.6];
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame tag:(NSInteger)tag named:(NSString *)name{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.tag = tag;
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}
-(void)animationWithView:(UIView *)view keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAAnimation *animation=[self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    [view.layer addAnimation:animation forKey:nil];
}
-(void)animationWithView:(UIView *)view keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue duration:(CGFloat)duration{
    CAAnimation *animation =[self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    animation.duration=duration;
    [view.layer addAnimation:animation forKey:nil];
}
-(CAAnimation *)createSAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:keyPath];
    animation.timingFunction=mediaTiming;
    animation.duration=0.2;
    animation.repeatCount=1;
    animation.fromValue=fromValue;
    animation.toValue=toValue;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    return animation;
    
}
-(CAAnimation *)createKAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAKeyframeAnimation *animation =[CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration=2;
    animation.calculationMode=kCAAnimationCubic;
    animation.repeatCount=HUGE_VALF;
    animation.values=@[fromValue, fromValue, @(-[toValue floatValue]/ 2.0), toValue, fromValue, fromValue];
    animation.keyTimes=@[@(0), @(0.075), @(0.09), @(0.13), @(0.16), @(1)];
    return animation;
}
-(CAAnimation *)createAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration=1.5;
    
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.timingFunction=mediaTiming;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue =fromValue;
    animation.toValue=toValue;
    animation.autoreverses = YES;
    
    return animation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

























