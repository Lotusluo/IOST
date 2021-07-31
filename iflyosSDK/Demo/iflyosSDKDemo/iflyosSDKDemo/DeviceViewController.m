//
//  DeviceViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/11/12.
//  Copyright © 2018年 test. All rights reserved.
//

#import "DeviceViewController.h"
#import "LogTextViewController.h"
#import "BuiltInViewController.h"
#import "AuthViewController.h"
#import "AlertView.h"
@interface DeviceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UISwitch *authSwitch;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *extendsTextField;
@property (weak, nonatomic) IBOutlet UISwitch *childrenMode;
@property (weak, nonatomic) IBOutlet UITextField *zoneTextField;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *extends = @{@"zone":@"房间",@"type":@"1",@"id":@"11282",@"frequency":@"37900",@"brand":@"美的",@"friendlyName":@"小明",@"deviceType":@(13),@"exts":@"xxxxx",@"supportKeys":@[@{@"key_id":@(1),@"key_name":@"电源"}]};
    self.extendsTextField.text = [self convertToJsonData:extends];
    [self createKeyboardButton];
    [self.childrenMode addTarget:self action:@selector(childrenModeAction:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}
-(void)childrenModeAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    
    NSString *alias = self.aliasTextField.text;
    NSString *zone = self.zoneTextField.text;
    if ([zone isEqualToString:@""]) {
        zone = nil;
    }
    if(alias.length > 30){
        [UIView showAlert:@"提示" message:@"别名不能超过30个字符" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] setDeviceAlias:deviceId alias:alias continousMode:false childrenMode:isButtonOn zone:zone statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) openBuiltInView:(URL_PATH_ENUM) pageIndex deviceId:(NSString *)deviceId{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    if (deviceId){
        BuiltInViewController *buitInVc = [[BuiltInViewController alloc] init];
        buitInVc.pageIndex = pageIndex;
        buitInVc.deviceId = deviceId;
        [self.navigationController pushViewController:buitInVc animated:YES];
    }
}

- (IBAction)deviceInfo:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] getDeviceInfo:deviceId statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}


- (IBAction)deviceAlias:(id)sender {
    
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    
    NSString *alias = self.aliasTextField.text;
    NSString *zone = self.zoneTextField.text;
    if ([alias isEqualToString:@""]) {
        alias = nil;
    }
    if ([zone isEqualToString:@""]) {
        zone = nil;
    }
    if(alias.length > 30){
        [UIView showAlert:@"提示" message:@"别名不能超过30个字符" target:self];
        return ;
    }
    
    [[IFLYOSSDK shareInstance] setDeviceAlias:deviceId alias:alias continousMode:false childrenMode:self.childrenMode.isOn zone:zone statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

- (IBAction)wakeupwords:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [self openBuiltInView:WAKEUP_WORDS deviceId:deviceId];
}

- (IBAction)speaker:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [self openBuiltInView:SPEARER deviceId:deviceId];
}

- (IBAction)sleepModel:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [self openBuiltInView:SLEEP deviceId:deviceId];
}

- (IBAction)bluetooth:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [self openBuiltInView:BLUETOOTH deviceId:deviceId];
}

- (IBAction)versionCheck:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [self openBuiltInView:DEVICE_VERSION_UPDATE deviceId:deviceId];
}

- (IBAction)reboot:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] rebootDevice:deviceId statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}

- (IBAction)resetNetwork:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] resetDeviceNetwork:deviceId statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}

- (IBAction)restore:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] restoreDeviceToFactorySetting:deviceId statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}

-(IBAction) sendQuiet:(id)sender{
    NSString *ssid = self.ssidTextField.text;
    NSString *pwd = self.pwdTextField.text;
    BOOL isAuth = self.authSwitch.enabled;
    [[iflyosQuietSDKForiOS shareInstance] sendQuiet:ssid password:pwd isAuth:isAuth];
}
- (IBAction)authCode:(id)sender {
    NSString *authUrl = [NSString stringWithFormat:@"%@/device?user_code=%@",[IFLYOSConfig shareInstance].authAddress,self.authCodeTextField.text];
    AuthViewController *avc= [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
    avc.authUrl = authUrl;
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)infraredTest:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    NSDictionary *extends = [self dictionaryWithJsonString:self.extendsTextField.text];
    if(!extends){
        [UIView showAlert:@"提示" message:@"extends不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] infraredButtonTest:deviceId extends:extends statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}
- (IBAction)infraredAdd:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    NSDictionary *extends = [self dictionaryWithJsonString:self.extendsTextField.text];
    if(!extends){
        [UIView showAlert:@"提示" message:@"extends不能为空" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] infraredAddDeviceInfo:deviceId extends:extends statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}
- (IBAction)deviceType:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入clientId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* clientId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    clientId = textField.text;
                    break;
            }
        }
        
        if (clientId){
            [[IFLYOSSDK shareInstance] getClientInfo:clientId statusCode:^(NSInteger statusCode) {
                NSLog(@"状态码：%li",statusCode);
            } requestSuccess:^(id _Nonnull data) {
                NSLog(@"success : %@",data);
                [self log:[self convertToJsonData:data]];
            } requestFail:^(id _Nonnull data) {
                [self log:[self convertToJsonData:data]];
                NSLog(@"error : %@",data);
            }];
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
}
- (IBAction)deviceTypeList:(id)sender {
    [[IFLYOSSDK shareInstance] getClientInfos:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        [self log:[self convertToJsonData:data]];
        NSLog(@"error : %@",data);
    }];
}
- (IBAction)deviceCode:(id)sender {
    NSString *deviceId = self.deviceTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入clientId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* clientId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    clientId = textField.text;
                    break;
            }
        }
        
        if (clientId){
            [[IFLYOSSDK shareInstance] getDeviceCode:clientId deviceId:deviceId statusCode:^(NSInteger statusCode) {
                NSLog(@"状态码：%li",statusCode);
            } requestSuccess:^(id _Nonnull data) {
                NSLog(@"success : %@",data);
                [self log:[self convertToJsonData:data]];
            } requestFail:^(id _Nonnull data) {
                [self log:[self convertToJsonData:data]];
                NSLog(@"error : %@",data);
            }];
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
}

-(void) log:(NSString *) text{
    LogTextViewController *logVc = [[LogTextViewController alloc] initWithNibName:@"LogTextViewController" bundle:nil];
    logVc.text = text;
    [self.navigationController pushViewController:logVc animated:YES];
}

-(NSString *)convertToJsonArray:(NSArray *) array{
    if(array == nil){
        return @"";
    }
    NSString *string = [array componentsJoinedByString:@","];
    return string;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    NSString *jsonString;
    if ([dict isKindOfClass:[NSData class]]) {
        if (!dict) {
            
            NSLog(@"%@",error);
            
        }else{
            
            jsonString = [[NSString alloc]initWithData:dict encoding:NSUTF8StringEncoding];
            
        }
        
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0,jsonString.length};
        
        //去掉字符串中的空格
        
        //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        //去掉字符串中的换行符
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        
        return mutStr;
    }
    
    if(dict == nil){
        return @"";
    }
    
    if([dict isKindOfClass:[NSString class]]){
        return (NSString *)dict;
    }
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

-(void) createKeyboardButton{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    [self.deviceTextField setInputAccessoryView:topView];
    [self.aliasTextField setInputAccessoryView:topView];
    [self.textView setInputAccessoryView:topView];
    [self.ssidTextField setInputAccessoryView:topView];
    [self.pwdTextField setInputAccessoryView:topView];
    [self.authCodeTextField setInputAccessoryView:topView];
    [self.zoneTextField setInputAccessoryView:topView];
    [self.extendsTextField setInputAccessoryView:topView];
}

-(void) dismissKeyBoard{
    [self.deviceTextField resignFirstResponder];//收起键盘
    [self.aliasTextField resignFirstResponder];//收起键盘
    [self.textView resignFirstResponder];//收起键盘
    [self.ssidTextField resignFirstResponder];//收起键盘
    [self.pwdTextField resignFirstResponder];//收起键盘
    [self.authCodeTextField resignFirstResponder];//收起键盘
    [self.zoneTextField resignFirstResponder];//收起键盘
    [self.extendsTextField resignFirstResponder];//收起键盘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.deviceTextField isExclusiveTouch] &&
        ![self.aliasTextField isExclusiveTouch] &&
        ![self.textView isExclusiveTouch] &&
        ![self.ssidTextField isExclusiveTouch]&&
        ![self.pwdTextField isExclusiveTouch]&&
        ![self.extendsTextField isExclusiveTouch]&&
        ![self.zoneTextField isExclusiveTouch]&&
        ![self.authCodeTextField isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
        [self dismissKeyBoard];
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
