//
//  ViewController.m
//  10_RunTime
//
//  Created by Tengfei on 2017/5/13.
//  Copyright © 2017年 tengfei. All rights reserved.
//

#import "ViewController.h"
#import "CommentModel.h"
#import "NSObject+Model.h"
#import "NSObject+Test.h"
#import "User.h"
#import <Masonry.h>
#import "ViewController1.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>



@interface ViewController ()

@property(nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UIButton *blockA;
@property (weak, nonatomic) IBOutlet UILabel *testB;


@property (nonatomic )CFRunLoopRef runloop;
@property (nonatomic ,weak)NSThread *thread;
@property (nonatomic )CFRunLoopObserverRef observer;

@end

@implementation ViewController
- (IBAction)onTurnClick:(id)sender {
    NSLog(@"onTurnClick");
    [self test];
}


- (IBAction)asdasd:(id)sender {

    NSLog(@"CLICK");
//    _blockA.transform = CGAffineTransformMakeScale(3, 3);
    _blockA.frame = CGRectMake(0, 0, 200, 300);
//    [_blockA mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(200);
//    }];
        dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, 3* NSEC_PER_SEC);
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            NSLog(@"%@",self.blockA);
            [_testB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_blockA.mas_bottom).offset(50);
            }];
        });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
//    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, 3* NSEC_PER_SEC);
//    dispatch_after(time_t, dispatch_get_main_queue(), ^{
//        NSLog(@"%@",self.blockA);
//
//    });
//
  
//    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:nil];
//    NSURL *url=[NSURL fileURLWithPath:jsonPath];
//        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//
//    User *user = [User yy_modelWithJSON:data];
//
//    NSEnumerator *enumerator = [user.userModels objectEnumerator];
//    UserModel* model;
//    while (model = [enumerator nextObject]) {
//        NSLog(@"%@",model);
//    }
//
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bookmark.plist" ofType:nil];
    NSLog(@"%@",path);
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"-dict: %@",dict);
    //第一种方式 ： 用KVC的方式进行转化
//    CommentModel *kvc_m = [CommentModel kvc_modelWith:dict];
    

    //第二种方式 ：runtime的方式转化
    CommentModel *rm_m = [CommentModel modelWithDict1:dict];
//    NSLog(@"rm_m:%@",[CommentModel getInstance:@"haha"]);
//    [NSThread detachNewThreadSelector:@selector(threadMethod) toTarget:self withObject:nil];
    
    
    
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//            NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
//        });
//
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
//
//
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
//    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
//    [self performSelector:@selector(busyOperation) withObject:nil afterDelay:0.5];
//
//    CFRelease(observer);
    
   
}

-(void)busyOperation{
   NSLog(@"线程繁忙开始");
   long count = 0xffffffff;
   CGFloat calculateValue = 0;
   for (long i = 0; i < count; i++) {
       calculateValue = i/2;
   }
   NSLog(@"线程繁忙结束");
}

- (void)timerMethod{
    NSLog(@"timer2 run：%d",[NSThread isMainThread]);
}

- (void)writeStringToFile {
    
    NSDictionary *dict = @{
                           @"idStr": @"apple_0001",
                           @"text" : @"Agree!Nice weather!",
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           };
    
    // Build the path, and create if needed.
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"--path :  %@",path);
    NSString* fileAtPath = [path stringByAppendingPathComponent:@"bookmark.plist"];
    [dict writeToFile:fileAtPath atomically:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test{
    NSLog(@"test");
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadMethod) object:nil];
    self.thread = thread;
    [self.thread start];
//    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay1)];
//    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)threadMethod{
    NSLog(@"threadMethod");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    self.runloop = CFRunLoopGetCurrent();
    CFRunLoopRun();
    NSLog(@"a");
}

- (void)timerMethod:(id*)sender{
    CFRunLoopStop(self.runloop);
    NSLog(@"timer run:%@",NSThread.currentThread);
}

@end
