//
//  IFTTTViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/11/12.
//  Copyright © 2020 test. All rights reserved.
//

#import "IFTTTViewController.h"
#import "LogTextViewController.h"
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "AlertView.h"
#import "UIView+UIView_alertView.h"
@interface IFTTTViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getIFTTTTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *getIFTTTActionTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *getIFTTTInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *getIFTTTPlanButton;
@property (weak, nonatomic) IBOutlet UIButton *getIFTTTMoreItemButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteIFTTTPlanButton;
@property (weak, nonatomic) IBOutlet UIButton *checkTextButton;

@property (weak, nonatomic) IBOutlet UITextField *execTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *execDataTextView;
@property (weak, nonatomic) IBOutlet UITextView *operationsTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreItemTextView;

@end

@implementation IFTTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createKeyboardButton];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addIFTTT:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    NSString *execTypeStr = self.execTypeLabel.text;
    NSString *execDataStr = self.execDataTextView.text;
    NSString *operationsStr = self.operationsTextView.text;
    if (!execTypeStr){
        [UIView showAlert:@"提示" message:@"execType不能为空" target:self];
        return ;
    }
    if (!execDataStr){
        [UIView showAlert:@"提示" message:@"execData不能为空" target:self];
        return ;
    }
    if (!operationsStr){
        [UIView showAlert:@"提示" message:@"operations不能为空" target:self];
        return ;
    }
    
    NSData *jsonData = [execDataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *execDataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
      //解析出错
        [UIView showAlert:@"提示" message:@"execData格式错误" target:self];
        return ;
    }
    NSArray *operations = [self stringToJSON:operationsStr];
    [[IFLYOSSDK shareInstance] addIFTTT:execTypeStr execData:execDataDict operations:operations token:nil statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[NSString stringWithFormat:@"%@",[self convertToJsonData:data]]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
    
}
- (IBAction)getIFTTTTypeAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入execType"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *execType;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    execType = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getIFTTTExecType:execType statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[NSString stringWithFormat:@"%@",[self convertToJsonData:data]]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)getIFTTTTypeActionAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入execType",@"请输入actionType"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *execType;
        NSString *actionType;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    execType = textField.text;
                    break;
                case 1:
                    actionType = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getIFTTTExecTypeActionTypes:execType actionType:actionType  statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[NSString stringWithFormat:@"%@",[self convertToJsonData:data]]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)getIFTTTInfoAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入token"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *token;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    token = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getIFTTTWithPlanToken:token statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[NSString stringWithFormat:@"%@",[self convertToJsonData:data]]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)getIFTTTAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    [[IFLYOSSDK shareInstance] getIFTTTs:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}
- (IBAction)getMoreItemAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    NSString *body = self.moreItemTextView.text;
    if (!body){
        [UIView showAlert:@"提示" message:@"body不能为空" target:self];
        return ;
    }
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *bodyDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
      //解析出错
        [UIView showAlert:@"提示" message:@"bodyDict格式错误" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入execType",@"请输入actionType",@"请输入iot_device_id"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *execType;
        NSString *actionType;
        NSString *device_id;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    execType = textField.text;
                    break;
                case 1:
                    actionType = textField.text;
                    break;
                case 2:
                    device_id = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getIFTTTExecTypeMoreItem:execType actionType:actionType deviceId:device_id body:bodyDict  statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[NSString stringWithFormat:@"%@",[self convertToJsonData:data]]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)deletePlanAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入tokens,若多个请用','分割"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *tokens;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    tokens = textField.text;
                    break;
            }
        }
        NSArray *tokensArray = [tokens componentsSeparatedByString:@","];
        
        [[IFLYOSSDK shareInstance] deleteIFTTTWithPlanTokens:tokensArray statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}
- (IBAction)checkTextAction:(id)sender {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入text"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *text;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    text = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getIFTTTCheck:text statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[NSString stringWithFormat:@"%@（状态码200）",[self convertToJsonData:data]]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
        
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

- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
         
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                 
                return tmp;
                 
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                 
                return [NSArray arrayWithObject:tmp];
                 
            } else {
                return nil;
            }
        } else {
            return nil;
        }
         
    } else {
        return nil;
    }
}

-(void) createKeyboardButton{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    [self.execTypeLabel setInputAccessoryView:topView];
    [self.execDataTextView setInputAccessoryView:topView];
    [self.operationsTextView setInputAccessoryView:topView];
    [self.moreItemTextView setInputAccessoryView:topView];
}

-(void) dismissKeyBoard{
    [self.execTypeLabel resignFirstResponder];//收起键盘
    [self.execDataTextView resignFirstResponder];//收起键盘
    [self.operationsTextView resignFirstResponder];//收起键盘
    [self.moreItemTextView resignFirstResponder];//收起键盘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.execTypeLabel isExclusiveTouch] &&
        ![self.execDataTextView isExclusiveTouch] &&
        ![self.operationsTextView isExclusiveTouch] &&
        ![self.moreItemTextView isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
        [self dismissKeyBoard];
    }
}
@end
