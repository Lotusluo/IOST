//
//  ViewController.m
//  adasdasdasd
//
//  Created by luotao on 2021/6/22.
//

#import "ViewController.h"
#import "TestView.h"
#import "UIView+XX.h"
#import "CppObject.hpp"
#import "AntiCppObject.hpp"
#import "TrickOC.h"
#import "TrickCpp.hpp"
#import "PeopleCPP.hpp"
#import "PeopleOC.h"
#import <Testlib/InsetsLabel.h>
#import <objc/message.h>
#import "UIView+XX.h"

void transferFun(void *obj,...){
    PeopleOC *peopleOC = (__bridge_transfer PeopleOC*)obj;
    char *t;
    va_list val;
    va_start(val,obj);
    t=va_arg(val,char*);//获取下一个参数需要赋值的。
    va_end(val);
    [peopleOC saySomethings:[[NSString alloc] initWithUTF8String:t]];
};

struct delegate{
    TestView* oc;
};

@interface ViewController ()

@property(nonatomic,strong)CAShapeLayer *layer;

@property(nonatomic,strong)NSString *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.test = @"test";
    InsetsLabel *skillView = [[InsetsLabel alloc] init];
    skillView.rightInset = 10;
    skillView.leftInset = 10;
//    skillView.preferredMaxLayoutWidth = 200;
    skillView.text = @"skillStr";
    skillView.textColor = [UIColor whiteColor];
    skillView.backgroundColor = [UIColor redColor];

//    skillView.frame = CGRectMake(50, 50, 300, 80);
//    [skillView sizeToFit];
    [self.view addSubview:skillView];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
//    [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 80, 80)] bezierPathByReversingPath]];
//    self.layer = [CAShapeLayer layer];
//    self.layer.fillColor = [UIColor clearColor].CGColor;
//    self.layer.strokeColor = [UIColor orangeColor].CGColor;
//    self.layer.lineWidth = 3;
//    UIBezierPath * path1 = [UIBezierPath bezierPath];
//    [path1 moveToPoint:CGPointMake(50, 50)];
//    [path1 addLineToPoint:CGPointMake(200,200)];
//    self.layer.path = path1.CGPath;
//
//    [self.view.layer addSublayer:self.layer];
    
//  
//    
//    CppObject *cpp = new CppObject;
//    cpp->ExampleMethod("haha");
//    delete cpp;
    
//    AntiCppObject *cpp1 = new AntiCppObject;
//    cpp1->ExampleMethod([@"黑" UTF8String]);
//    delete cpp1;
    
    
//    void* pointer = nil;
//    TrickOC* trickoc = [[TrickOC alloc]init];
//    pointer = (__bridge_retained void*)trickoc;
//    TrickCpp * trick = new TrickCpp(pointer,trickoc.call);
//    trick->function();

//    NSArray * values = @[
//                         @[@1.0, @0.9, @0.8, @0.9, @0.8, @0.9, @0.8],
//                         @[@1.0, @0.8, @0.5, @0.1, @0.5, @0.7, @1.0],
//                         @[@1.0, @0.7, @0.4, @0.4, @0.7, @0.9, @1.0]
//                         ];
//    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.values = values[0];
//    animation.duration = 10;
//    animation.repeatCount = HUGE_VAL;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.layer addAnimation:animation forKey:@"ESSEQAnimation"];
     
}

- (IBAction)click:(id)sender {
    self.view.name1 = @"name1";
    NSLog(@"name1:%@",self.view.name1);
    PeopleOC *peopleOC = [PeopleOC new];
    void *pointer = (__bridge_retained void*)peopleOC;
    PeopleCPP *peopleCPP = new PeopleCPP(pointer,transferFun);
    delete peopleCPP;
//    PeopleOC *people = [[PeopleOC alloc] init];
//    void *pointer = (__bridge_retained void*)people;
//    delete pointer;
//    [people performSelector:@selector(saySomethingsNew:) withObject:@"陶瓷"];
//    objc_msgSend(people.class, @selector(saySomethings:),@"xixi");
}
//
//void eat(id _id){
//    void* t = (__bridge_retained void*)_id;
//    CF
//    printf("eat");
//}

@end
