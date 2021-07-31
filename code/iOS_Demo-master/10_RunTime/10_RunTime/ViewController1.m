//
//  ViewController1.m
//  10_RunTime
//
//  Created by luotao on 2021/4/13.
//  Copyright © 2021 tengfei. All rights reserved.
//

#import "ViewController1.h"
#import "NSTimer+Addition.h"
#import "Mall.h"
#import "UserModel.h"
#import "User.h"

@interface ViewController1 ()

@property(nonatomic) NSString* title1;

@property (nonatomic )CFRunLoopRef runloop;
@property (nonatomic ,weak)NSThread *thread;
@property (nonatomic )CFRunLoopObserverRef observer;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadMethod) object:nil];
    self.thread = thread;
    [self.thread start];
    
//    __weak typeof (self) weakself = self;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//        }];

//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    
//    __weak typeof(self) __SELF = self;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"执行耗时操作%@",[NSThread currentThread]);
//        //模拟耗时操作
//        [NSThread sleepForTimeInterval:10];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [__SELF timerMethod:nil];
//            NSLog(@"刷新UI%@",[NSThread currentThread]);
//        });
//    });
}

- (void)timerMethod:(id*)sender{
    self.title1 = @"timerMethod";
    NSLog(@"timer run");
}
- (void)dealloc{
    NSLog(@"销毁了");
// CFRelease(self.observer);
}

- (void)clicked{
//    [self.timer invalidate];
//    if (self.timer && self.thread) {
//        [self performSelector:@selector(cancel:) onThread:self.thread withObject:nil waitUntilDone:YES];
//    }
}
//    [self.timer invalidate];
//    CFRunLoopWakeUp(self.runloop);

- (void)cancel:(id) sender{
    if (self.thread) {
        [self.timer invalidate];
        CFRunLoopStop(self.runloop);//可以dealloc
    }
}


- (void)threadMethod{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
//    self.runloop = CFRunLoopGetCurrent();
//
//    self.observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
//    });
//    CFRunLoopAddObserver(self.runloop, self.observer, kCFRunLoopDefaultMode);
    
//    [[NSRunLoop currentRunLoop]];
//    CFRunLoopRun();

//    CFRelease(self.observer);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
