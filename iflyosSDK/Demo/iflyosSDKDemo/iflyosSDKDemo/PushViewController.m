//
//  PushViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/8/20.
//  Copyright © 2020 test. All rights reserved.
//

#import "PushViewController.h"
#import <iflyosPushService/IFLYOSPushService.h>
#import <iflyosPushService/IFLYOSPushServiceProtocol.h>
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "UIView+UIView_alertView.h"
@interface PushViewController ()<IFLYOSPushServiceProtocol>
@property (weak, nonatomic) IBOutlet UITextField *deviceIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *listenDeviceStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *listenUserStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *closeListenDeviceStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *closeListenUserButton;
@property (nonatomic,strong) IFLYOSPushService *deviceStatePushService;
@property (nonatomic,strong) IFLYOSPushService *userStatePushService;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.layoutManager.allowsNonContiguousLayout= NO;
    [self.textView setEditable:NO];
    [self.closeListenUserButton setEnabled:NO];
    [self.closeListenDeviceStatusButton setEnabled:NO];
    [self createKeyboardButton];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.deviceStatePushService close];
    [self.userStatePushService close];
}

- (IBAction)listenDeviceStateAction:(id)sender {
    if ([self.deviceIdTextField.text isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"请输入设备ID" target:self];
        return ;
    }
    NSString *token = [IFLYOSSDK shareInstance].getToken;
    NSString *deviceId = self.deviceIdTextField.text;
    if (token && ![deviceId isEqualToString:@""]){
        self.deviceStatePushService = [IFLYOSPushService createSocket:token command:@"connect" fromType:@"ALIAS" deviceId:deviceId];
        self.deviceStatePushService.delegate = self;
        [self.deviceStatePushService open];
    }
}
- (IBAction)listenUserStatusAction:(id)sender {
    if ([self.userIdTextField.text isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"请输入用户ID" target:self];
        return ;
    }
    NSString *token = [IFLYOSSDK shareInstance].getToken;
    NSString *userId = self.userIdTextField.text;
    if (token && ![userId isEqualToString:@""]){
        self.userStatePushService = [IFLYOSPushService createSocket:token command:@"connect" fromType:@"ACCOUNT" deviceId:userId];
        self.userStatePushService.delegate = self;
        [self.userStatePushService open];
    }
}

- (IBAction)closeDeviceStateListenAction:(id)sender {
    [self.deviceStatePushService close];
}

- (IBAction)closeUserStateListenAction:(id)sender {
    [self.userStatePushService close];
}

#pragma 回调


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/**
 * socket连接成功
 */
-(void) onSockectOpenSuccess:(IFLYOSPushService *) socket{
    self.textView.text = @"";
    if (socket == self.deviceStatePushService) {
        NSLog(@"设备状态监听已打开");
        [self appendText: [NSString stringWithFormat:@"设备状态监听已打开。。。。"]];
        [self.closeListenDeviceStatusButton setEnabled:YES];
        [self.listenDeviceStatusButton setEnabled:NO];
    }else if (socket == self.userStatePushService) {
        NSLog(@"用户状态监听已打开");
        [self appendText: [NSString stringWithFormat:@"用户状态监听已打开。。。。"]];
        [self.closeListenUserButton setEnabled:YES];
        [self.listenUserStatusButton setEnabled:NO];
    }
}
/**
 * socket连接失败
 * error:失败原因
*/
-(void) onSockect:(IFLYOSPushService *) socket error:(NSError *) error{
    if (socket == self.deviceStatePushService) {
        NSLog(@"设备状态监听打开失败：%@",error);
        [self appendText: [NSString stringWithFormat:@"设备状态监听已关闭。。。。"]];
        [self.closeListenDeviceStatusButton setEnabled:NO];
        [self.listenDeviceStatusButton setEnabled:YES];
    }else if (socket == self.userStatePushService) {
        NSLog(@"用户状态监听打开失败：%@",error);
        [self appendText: [NSString stringWithFormat:@"用户状态监听已关闭。。。。"]];
        [self.closeListenUserButton setEnabled:NO];
        [self.listenUserStatusButton setEnabled:YES];
    }
}
/**
 * socket 主动关闭连接回调（关闭成功后，清理socket相关东西）
 * code:关闭代码
 * reason:关闭原因
 * wasClean:是否清除
*/
-(void) onSockect:(IFLYOSPushService *) socket didCloseWithCode:(NSInteger) code reason:(NSString *) reason wasClean:(BOOL)wasClean{
    if (socket == self.deviceStatePushService) {
        NSLog(@"设备状态监听已关闭：%@",reason);
        [self.closeListenDeviceStatusButton setEnabled:NO];
        [self.listenDeviceStatusButton setEnabled:YES];
    }else if (socket == self.userStatePushService) {
        NSLog(@"用户状态监听已关闭：%@",reason);
        [self.closeListenUserButton setEnabled:NO];
        [self.listenUserStatusButton setEnabled:YES];
    }
}

/**
 * 收到的信息
 * receiveMessage : 回调信息
 */
-(void) onSockect:(IFLYOSPushService *) socket receiveMessage:(id) receiveMessage{
    if (socket == self.deviceStatePushService) {
        NSLog(@"【*】设备状态：%@",receiveMessage);
        [self appendText: [NSString stringWithFormat:@"【*】设备状态：%@",receiveMessage]];
    }else if (socket == self.userStatePushService) {
        NSLog(@"【^】用户状态：%@",receiveMessage);
        [self appendText: [NSString stringWithFormat:@"【^】用户状态：%@",receiveMessage]];
    }
}

-(void) appendText:(NSString *) text{
    if (self.textView.text.length > 10000){
        self.textView.text = @"";
    }else{
        self.textView.text = [NSString stringWithFormat:@"%@\n%@",self.textView.text,text];
    }
    
    [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height-15, self.textView.contentSize.width, 10) animated:YES];
}

-(void) createKeyboardButton{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    [self.deviceIdTextField setInputAccessoryView:topView];

}

-(void) dismissKeyBoard{
    [self.deviceIdTextField resignFirstResponder];//收起键盘
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.deviceIdTextField isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
        [self dismissKeyBoard];
    }
}
@end
