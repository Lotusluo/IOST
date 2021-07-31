//
//  UserViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2019/1/23.
//  Copyright © 2019年 test. All rights reserved.
//

#import "UserViewController.h"
#import "AuthViewController.h"
#import "LogTextViewController.h"
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
@interface UserViewController ()<IFLYOSsdkLoginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *customTokenVc;
@property (weak, nonatomic) IBOutlet UIButton *setCustomTokenButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *revokeButton;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)revokeAction:(id)sender {
    [[IFLYOSSDK shareInstance] revokeAccount:self];
}

- (IBAction)setCustomToken:(id)sender {
    BOOL isLogin = [[IFLYOSSDK shareInstance] setCustomToken:self.customTokenVc.text];
    if (isLogin) {
        NSLog(@"token设置成功！");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)loadUrl:(id)sender {
    NSString *url = self.urlTextField.text;
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    AuthViewController *authVc = [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
    authVc.authUrl = url;
    [self.navigationController pushViewController:authVc animated:YES];
}

- (IBAction)logout:(id)sender {
    [[IFLYOSSDK shareInstance] logout:self];
}
/**
 *  注销成功
 */
-(void) onLogoutSuccess{
    NSLog(@"退出登陆成功");
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  注销失败
 */
-(void) onLogoutFailed:(NSInteger) type error:(NSError *) error{
    NSLog(@"退出登陆失败：%li,%@",type,error.localizedDescription);
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  注销成功
 */
-(void) onUserRevokeSuccess{
    NSLog(@"退出登陆成功");
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  注销失败
 */
-(void) onUserRevokeFail:(NSInteger) type error:(NSError *) error{
    NSLog(@"退出登陆失败：%li,%@",type,error.localizedDescription);
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
@end
