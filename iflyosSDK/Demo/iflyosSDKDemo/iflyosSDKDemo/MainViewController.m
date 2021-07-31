//
//  MainViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "MainViewController.h"
#import "VoiceTrainViewController.h"
#import "ViewController.h"
#import "BuiltInViewController.h"
#import "MusicViewController.h"
#import "AuthViewController.h"
#import "BLEViewController.h"
#import "DeviceViewController.h"
#import "CallrecordViewController.h"
#import "ContactsViewController.h"
#import "PushViewController.h"
#import "UserViewController.h"
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "QRCodeViewController.h"
#import "MediaViewController.h"
#import "NewBLEViewController.h"
#import "IFTTTViewController.h"
#import "AlertView.h"
#define CELL @"cell"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,IFLYOSsdkLoginDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;

@property (strong, nonatomic) NSMutableDictionary *accountsType;
@end

@implementation MainViewController
-(NSMutableDictionary *) accountsType {
    if (!_accountsType) {
        _accountsType = [[NSMutableDictionary alloc] init];
    }
    return _accountsType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iflyos SDK demo";
    
    self.datasource = [[NSMutableArray alloc] init];
    [self.datasource addObject:@"webView接口"];
    [self.datasource addObject:@"内置-技能"];
    [self.datasource addObject:@"内置-闹钟"];
    [self.datasource addObject:@"内置-内容账号"];
    [self.datasource addObject:@"内置-智能家居"];
    [self.datasource addObject:@"音乐接口"];
    [self.datasource addObject:@"蓝牙配网"];
    [self.datasource addObject:@"音箱操作"];
    [self.datasource addObject:@"用户信息操作"];
    [self.datasource addObject:@"二维码"];
//    [self.datasource addObject:@"联系人"];
//    [self.datasource addObject:@"通话记录"];
    [self.datasource addObject:@"内置-对话页"];
    [self.datasource addObject:@"获取token"];
    [self.datasource addObject:@"注销账号"];
    [self.datasource addObject:@"内置-IFTTT"];
    [self.datasource addObject:@"酷狗收藏同步"];
    [self.datasource addObject:@"内容账号类型"];
    [self.datasource addObject:@"推送服务"];
    [self.datasource addObject:@"播放记录"];
    [self.datasource addObject:@"F-9688蓝牙协议"];
    [self.datasource addObject:@"接口-IFTTT"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *rightButtonName = @"退出登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightButtonName style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    if ([IFLYOSSDK shareInstance].isLogin) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
}

/**
 *  注销账号成功
 */
-(void) onUserRevokeSuccess{
     NSLog(@"注销成功,退出登录");
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

/**
 *  注销账号失败
 */
-(void) onUserRevokeFail:(NSInteger) type error:(NSError *) error{
    NSLog(@"注销失败：%li,%@",type,error.localizedDescription);
}

-(void) logout{
    NSLog(@"退出登录");
    [[IFLYOSSDK shareInstance] logout:self];
}

/**
 *  注销成功
 */
-(void) onLogoutSuccess{
    NSLog(@"退出登陆成功");
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

/**
 *  注销失败
 */
-(void) onLogoutFailed:(NSInteger) type error:(NSError *) error{
    NSLog(@"退出登陆失败：%li,%@",type,error.localizedDescription);
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row == 0) {
        [self openWebView];
    }else if (row == 1) {
        [self openBuiltInView:SKILLS];
    }else if (row == 2) {
        [self openBuiltInViewNotWithDeviceId:CLOCKS];
    }else if (row == 3) {
        [self openBuiltInViewNotWithDeviceId:ACCOUNTS];
    }else if (row == 4) {
        [self openBuiltInViewNotWithDeviceId:CONTROLLED_DEVICES];
    }else if (row == 5) {
        [self openMusicView];
    }else if (row == 6) {
        [self openBLEView];
    }else if (row == 7) {
        //音箱操作
        [self openDeviceOperation];
    }else if (row == 8) {
        //用户信息操作
        [self openUserPage];
    }else if (row == 9) {
        [self openQRCodePage];
    }else if (row == 10) {
        [self openTalkPage:TALK];
    }else if (row == 11) {
        NSString *token = [[IFLYOSSDK shareInstance] getToken];
        [UIView showAlert:@"提示" message:token target:self];
    }else if (row == 12) {
        [self revokeAccount];
    }else if (row == 13) {
        [self openBuiltInViewNotWithDeviceId:IFTTT];
    }else if (row == 14){
        [self asyncKugouCollections];
    }else if (row == 15){
        [self openAccountsType];
    }else if (row == 16){
        [self openPushPage];
    }else if (row == 17){
        [self openRecordPlayPage];
    }else if (row == 18){
        [self openNewBLEViewController];
    }else if (row == 19){
        [self openIFTTTViewController];
    }
}

//设置行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = self.datasource.count;
    return row;
}

//设置每行的cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
    }
    cell.textLabel.text = self.datasource[row];
    return cell;
}

-(void) asyncKugouCollections{
    [IFLYOSSDK.shareInstance asyncKugouCollections:^(NSInteger statusCode) {
        NSLog(@"酷狗同步状态:%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"同步：%@",data);
    } requestFail:^(id _Nonnull error) {
        NSLog(@"同步错误：%@",error);
    }];
}

-(void) revokeAccount{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"警告" message:@"注销账号后，30天内不能登录" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [IFLYOSSDK.shareInstance revokeAccount:self];
    }]];
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}

-(void) openIFTTTViewController{
    IFTTTViewController *iftttVc = [[IFTTTViewController alloc] initWithNibName:@"IFTTTViewController" bundle:nil];
    [self.navigationController pushViewController:iftttVc animated:YES];
}

-(void) openNewBLEViewController{
    NewBLEViewController *bleVc = [[NewBLEViewController alloc] initWithNibName:@"NewBLEViewController" bundle:nil];
    [self.navigationController pushViewController:bleVc animated:YES];
}

-(void) openRecordPlayPage{
    MediaViewController *mediaVc = [[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
    [self.navigationController pushViewController:mediaVc animated:YES];
}

-(void) openPushPage{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    PushViewController *pushViewController = [[PushViewController alloc] initWithNibName:@"PushViewController" bundle:nil];
    [self.navigationController pushViewController:pushViewController animated:YES];
}

-(void) openQRCodePage{
    
    QRCodeViewController *qrCodeVc = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
    [self.navigationController pushViewController:qrCodeVc animated:YES];
}

-(void) openUserPage{
    UserViewController *userVc = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    [self.navigationController pushViewController:userVc animated:YES];
}

-(void) openContacts{
    ContactsViewController *contactsVc = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    [self.navigationController pushViewController:contactsVc animated:YES];
}

-(void) openCallrecord{
    CallrecordViewController *callrecordVc = [[CallrecordViewController alloc] initWithNibName:@"CallrecordViewController" bundle:nil];
    [self.navigationController pushViewController:callrecordVc animated:YES];
}

-(void) openDeviceOperation{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    DeviceViewController *dvc = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void) openVoiceTrain{
    VoiceTrainViewController *voiceVc = [[VoiceTrainViewController alloc] init];
    [self.navigationController pushViewController:voiceVc animated:YES];
}

-(void) openWebView{
    ViewController *webVc = [[ViewController alloc] init];
    [self.navigationController pushViewController:webVc animated:YES];
}

-(void) openBuiltInViewNotWithDeviceId:(URL_PATH_ENUM) pageIndex{
    BuiltInViewController *buitInVc = [[BuiltInViewController alloc] init];
    buitInVc.pageIndex = pageIndex;
    [self.navigationController pushViewController:buitInVc animated:YES];
}

-(void) openBuiltInView:(URL_PATH_ENUM) pageIndex{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
   
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* deviceId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
            }
        }
        
        if (deviceId){
            BuiltInViewController *buitInVc = [[BuiltInViewController alloc] init];
            buitInVc.pageIndex = pageIndex;
            buitInVc.deviceId = deviceId;
            [self.navigationController pushViewController:buitInVc animated:YES];
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void) openAccountsType {
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    [[IFLYOSSDK shareInstance] getAccountsType:^(NSInteger statusCode) {
        NSLog(@"请求状态：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSDictionary *dict = data;
        if (dict) {
            NSArray *accountsArray = dict[@"accounts"];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"参数" preferredStyle:UIAlertControllerStyleActionSheet];
            
            //定义输入框；
            
            for (NSDictionary *element in accountsArray) {
                NSString *type = element[@"bind_type"];
               
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:type style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *key = action.title;
                    
                    [self openBuiltInViewNotDeviceId:key];
                }];
                
                [alertController addAction:alertAction];
            }
            
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
    } requestFail:^(id _Nonnull error) {
        NSLog(@"error : %@",error);
        [UIView showAlert:@"提示" message:@"请求失败" target:self];
    }];
}


-(void) openBuiltInViewNotDeviceId:(NSString *) type{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
   
    BuiltInViewController *buitInVc = [[BuiltInViewController alloc] init];
    buitInVc.type = type;
    [self.navigationController pushViewController:buitInVc animated:YES];
}

-(void) openTalkPage:(URL_PATH_ENUM) pageIndex{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* deviceId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
            }
        }
        
        if (deviceId){
            BuiltInViewController *buitInVc = [[BuiltInViewController alloc] init];
            buitInVc.pageIndex = pageIndex;
            buitInVc.deviceId = deviceId;
            [self.navigationController pushViewController:buitInVc animated:YES];
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


-(void) openMusicView{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    MusicViewController *muiscVc = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
    [self.navigationController pushViewController:muiscVc animated:YES];
}

-(void) openAuthView{
    AuthViewController *avc= [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
    [self.navigationController pushViewController:avc animated:YES];
}

-(void) openCustomURL:(NSString *) url{
    AuthViewController *avc= [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
    avc.authUrl = url;
    [self.navigationController pushViewController:avc animated:YES];
}


-(void) openBLEView{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    BLEViewController *bleVc = [[BLEViewController alloc] initWithNibName:@"BLEViewController" bundle:nil];
    [self.navigationController pushViewController:bleVc animated:YES];
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
