//
//  MusicViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2018/9/28.
//  Copyright © 2018年 test. All rights reserved.
//

#import "MusicViewController.h"
#import "LogTextViewController.h"
#import "AlertView.h"
#define CELL @"cell"
@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *musicIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *groupIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *sourceTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *sectionIdTextField;
@property (strong, nonatomic) NSMutableArray *datasource;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"音乐接口";
    
    self.datasource = [[NSMutableArray alloc] init];
    [self.datasource addObject:@"获取用户已绑定设备列表"];
    [self.datasource addObject:@"删除用户绑定设备"];
    [self.datasource addObject:@"获取音频管理首页数据"];
    [self.datasource addObject:@"音乐搜索[周杰伦]"];
    [self.datasource addObject:@"用户已收藏列表"];
    [self.datasource addObject:@"收藏音乐(废弃)"];
    [self.datasource addObject:@"取消收藏音乐（废弃）"];
    [self.datasource addObject:@"获取指定设备当前播放器状态"];
    [self.datasource addObject:@"指定设备播放音乐"];
    [self.datasource addObject:@"指定设备播放用户收藏的音乐"];
    [self.datasource addObject:@"指定设备播放分类/榜单下所有音乐"];
    [self.datasource addObject:@"指定设备停止播放"];
    [self.datasource addObject:@"指定设备继续播放"];
    [self.datasource addObject:@"指定设备播放上一首"];
    [self.datasource addObject:@"指定设备播放下一首"];
    [self.datasource addObject:@"指定设备控制音量，volume 范围 [0,100],这里100"];
    [self.datasource addObject:@"获取音频播放组"];
    [self.datasource addObject:@"获取用户信息"];
    [self.datasource addObject:@"获取信源列表"];
    [self.datasource addObject:@"获取分组列表"];
    [self.datasource addObject:@"取消信源收藏"];
    [self.datasource addObject:@"获取用户userId"];
    [self.datasource addObject:@"获取内容账号信息"];
    
    [self.datasource addObject:@"查看专辑"];
    [self.datasource addObject:@"收藏接口（新）"];
    [self.datasource addObject:@"取消收藏（新）"];
    [self.datasource addObject:@"我的收藏列表"];
    [self.datasource addObject:@"收藏标签列表"];
    [self.datasource addObject:@"我的播放列表"];
    [self.datasource addObject:@"专辑播放"];
    [self.datasource addObject:@"收藏歌单播放"];
    [self.datasource addObject:@"播放列表播放"];
    [self.datasource addObject:@"留声变声列表"];
    [self.datasource addObject:@"指定设备变声"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createKeyboardButton];
    // Do any additional setup after loading the view from its nib.
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *deviceId = self.deviceIdTextField.text;
    NSString *groupId = self.groupIdTextField.text;
    NSString *musicId = self.musicIdTextField.text;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row == 0) {
        [[IFLYOSSDK shareInstance] getUserDevices:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 1) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] deleteUserDevice:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 2) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] getMusicGroups:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 3) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] searchMusic:deviceId keyword:self.keywordTextField.text page:1 limit:20 statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 4) {
        NSString *sourceType = self.sourceTypeTextField.text;
        if(!sourceType || [sourceType isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
            return ;
        }
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] getMusicCollections:deviceId sourceType:sourceType startId:nil limit:100 statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 5) {
        [UIView showAlert:@"提示" message:@"已废弃" target:self];
        return ;
        
//        NSString *musicId = self.musicIdTextField.text;
//        if(!musicId || [musicId isEqualToString:@""]){
//            [UIView showAlert:@"提示" message:@"musicId不能为空" target:self];
//            return ;
//        }
//        NSString *sourceType = self.sourceTypeTextField.text;
//        if(!sourceType || [sourceType isEqualToString:@""]){
//            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
//            return ;
//        }
//        [[IFLYOSSDK shareInstance] likeMusic:musicId sourceType:sourceType statusCode:^(NSInteger statusCode) {
//            NSLog(@"状态码：%li",statusCode);
//        } requestSuccess:^(id _Nonnull data) {
//            NSLog(@"success : %@",data);
//            [self log:[self convertToJsonData:data]];
//        } requestFail:^(id _Nonnull data) {
//            NSLog(@"error : %@",data);
//            [self log:[self convertToJsonData:data]];
//        }];
    }else if (row == 6) {
        [UIView showAlert:@"提示" message:@"已废弃" target:self];
        return ;
//        NSString *musicId = self.musicIdTextField.text;
//        if(!musicId || [musicId isEqualToString:@""]){
//            [UIView showAlert:@"提示" message:@"musicId不能为空" target:self];
//            return ;
//        }
//        NSString *sourceType = self.sourceTypeTextField.text;
//        if(!sourceType || [musicId isEqualToString:@""]){
//            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
//            return ;
//        }
//        [[IFLYOSSDK shareInstance] unlikeMusic:@[musicId] sourceType:sourceType statusCode:^(NSInteger statusCode) {
//            NSLog(@"状态码：%li",statusCode);
//        } requestSuccess:^(id _Nonnull data) {
//            NSLog(@"success : %@",data);
//            [self log:[self convertToJsonData:data]];
//        } requestFail:^(id _Nonnull data) {
//            NSLog(@"error : %@",data);
//            [self log:[self convertToJsonData:data]];
//        }];
    }else if (row == 7) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""] ){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] getMusicControlState:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 8) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""] ){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        NSString *musicId = self.musicIdTextField.text;
        if(!musicId || [musicId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"musicId不能为空" target:self];
            return ;
        }
        NSString *sourceType = self.sourceTypeTextField.text;
        if(!sourceType || [sourceType isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlPlay:deviceId mediaId:musicId sourceType:sourceType statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 9) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        NSString *sourceType = self.sourceTypeTextField.text;
        if(!sourceType || [sourceType isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlPlayCollections:deviceId mediaId:musicId sourceType:sourceType statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 10) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        NSString *sourceType = self.sourceTypeTextField.text;
        if(!sourceType || [sourceType isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
            return ;
        }
        NSString *groupId = self.groupIdTextField.text;
        if(!groupId || [groupId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"groupId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlPlayGroup:deviceId groupId:groupId mediaId:musicId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 11) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlStop:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 12) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlResume:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 13) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlPrevious:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 14) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlNext:deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 15) {
        NSString *deviceId = self.deviceIdTextField.text;
        if(!deviceId || [deviceId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] musicControlVolume:deviceId volume:[self.volumeTextField.text integerValue] statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 16) {
        NSString *groupId = self.groupIdTextField.text;
        if(!groupId || [groupId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"groupId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] getMusicGroupsList:1 limit:20 groupId:groupId statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 17) {
        [[IFLYOSSDK shareInstance] getUserInfo:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 18) {
        [[IFLYOSSDK shareInstance] getMediaSources:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 19) {
        NSString *sectionId = self.sectionIdTextField.text;
        if(!sectionId || [sectionId isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sectionId不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] getMediaGroupList:sectionId deviceId:self.deviceIdTextField.text statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 20) {
        NSString *sourceType = self.sourceTypeTextField.text;
        if(!sourceType || [sourceType isEqualToString:@""]){
            [UIView showAlert:@"提示" message:@"sourceType不能为空" target:self];
            return ;
        }
        [[IFLYOSSDK shareInstance] deleteMediaSourcesWithType:sourceType statusCode:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 21) {
        [[IFLYOSSDK shareInstance] getUserId:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 22) {
        [[IFLYOSSDK shareInstance] getAccount:^(NSInteger statusCode) {
            NSLog(@"状态码：%li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSLog(@"success : %@",data);
            [self log:[self convertToJsonData:data]];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"error : %@",data);
            [self log:[self convertToJsonData:data]];
        }];
    }else if (row == 23) {
        [self getAlbum];
    }else if (row == 24) {
        [self likeMedia];
    }else if (row == 25) {
        [self unlikeMedia];
    }else if (row == 26) {
        [self myCollectionList];
    }else if (row == 27) {
        [self collectionTags];
    }else if (row == 28) {
        [self playList];
    }else if (row == 29) {
        [self playAlbum];
    }else if (row == 30) {
        [self playCollections];
    }else if (row == 31) {
        [self playNow];
    }else if (row == 32) {
        [self getVoiceList];
    }else if (row == 33) {
        [self changeTransform];
    }
}

-(void) changeTransform{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值",@"请输入voiceId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *deviceId;
        NSString *voiceId;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
                case 1:
                    voiceId = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] transformVoices:deviceId voiceId:voiceId statusCode:^(NSInteger statusCode) {
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

-(void) getVoiceList{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    [[IFLYOSSDK shareInstance] transformVoices:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) playNow{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值",@"请输入mediaId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *deviceId;
        NSString *mediaId;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
                case 1:
                    mediaId = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] playNow:deviceId mediaId:mediaId statusCode:^(NSInteger statusCode) {
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

-(void) playCollections{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值",@"请输入tagId值",@"请输入mediaId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *deviceId;
        NSInteger tagId = 0;
        NSString *mediaId;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
                case 1:
                    tagId = [textField.text integerValue];
                    break;
                case 2:
                    mediaId = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] playCollections:deviceId tagId:tagId mediaId:mediaId  statusCode:^(NSInteger statusCode) {
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


-(void) playAlbum{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值",@"请输入mediaId值",@"请输入sourceType值",@"请输入likeType值",@"请输入business值",@"请输入albumId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *deviceId;
        NSString *mediaId;
        NSString *sourceType;
        NSString *likeType;
        NSString *business;
        NSString *albumId;
        
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
                case 1:
                    mediaId = textField.text;
                    break;
                case 2:
                    sourceType = textField.text;
                    break;
                case 3:
                    likeType = textField.text;
                    break;
                case 4:
                    business = textField.text;
                    break;
                case 5:
                    albumId = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] playAlbum:deviceId albumId:albumId mediaId:mediaId sourceType:sourceType bussiness:business statusCode:^(NSInteger statusCode) {
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

-(void) playList{
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
        
        [[IFLYOSSDK shareInstance] getPlayList:deviceId statusCode:^(NSInteger statusCode) {
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

-(void) collectionTags{
    [[IFLYOSSDK shareInstance] getCollectionTags:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) myCollectionList{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入deviceId值",@"请输入tagId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* deviceId;
        NSInteger tagId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    deviceId = textField.text;
                    break;
                case 1:
                    tagId = textField.text ? [textField.text integerValue] : 1;
                    break;
   
            }
        }
        
        [[IFLYOSSDK shareInstance] getCollectionList:deviceId tagId:tagId statusCode:^(NSInteger statusCode) {
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

-(void) unlikeMedia{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入likeType值",@"请输入tagId值",@"请输入mediaIds值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger tagId = 0;
        NSString* likeType;
        NSArray* mediaIds;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    likeType = textField.text;
                    break;
                case 1:
                    tagId = textField.text ? [textField.text integerValue] : 1;
                    break;
                case 2:
                    mediaIds = [textField.text componentsSeparatedByString:@","];
                    break;
               
            }
        }
        
        [[IFLYOSSDK shareInstance] unLikeMediaWithLikeType:likeType tagId:tagId mediaIds:mediaIds statusCode:^(NSInteger statusCode) {
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

-(void) likeMedia{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入albumId值",@"请输入信源值",@"请输入业务类型值",@"请输入tagId值",@"请输入likeType值",@"请输入meidaId值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* albumId;
        NSString* sourceType;
        NSString* business;
        NSInteger tagId = 0;
        NSString* likeType;
        NSString* mediaId;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    albumId = textField.text;
                    break;
                case 1:
                    sourceType = textField.text;
                    break;
                case 2:
                    business = textField.text;
                    break;
                case 3:
                    tagId = textField.text ? [textField.text integerValue] : 1;
                    break;
                case 4:
                    likeType = textField.text;
                    break;
                case 5:
                    mediaId = textField.text;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] likeMedia:mediaId sourceType:sourceType likeType:likeType business:business tagId:tagId albumId:albumId statusCode:^(NSInteger statusCode) {
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

-(void) getAlbum{
    if (![IFLYOSSDK shareInstance].isLogin){
        [UIView showAlert:@"提示" message:@"未登录，请先登录" target:self];
        return ;
    }
    
    UIAlertController *alertController = [AlertView createAlert:@[@"请输入albumId值",@"请输入信源值",@"请输入业务类型值",@"请输入页码值",@"请输入页数量值"]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* albumId;
        NSString* sourceType;
        NSString* business;
        NSInteger page;
        NSInteger limit;
        for (UITextField *textField in alertController.textFields){
            switch (textField.tag){
                case 0:
                    albumId = textField.text;
                    break;
                case 1:
                    sourceType = textField.text;
                    break;
                case 2:
                    business = textField.text;
                    break;
                case 3:
                    page = textField.text ? [textField.text integerValue] : 1;
                    break;
                case 4:
                    limit = textField.text ? [textField.text integerValue] : 20;
                    break;
            }
        }
        
        [[IFLYOSSDK shareInstance] getAlbum:albumId deviceId:_deviceIdTextField.text sourceType:sourceType business:business limit:limit page:page statusCode:^(NSInteger statusCode) {
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
    
    [self.musicIdTextField setInputAccessoryView:topView];
    [self.deviceIdTextField setInputAccessoryView:topView];
    [self.groupIdTextField setInputAccessoryView:topView];
    [self.keywordTextField setInputAccessoryView:topView];
    [self.volumeTextField setInputAccessoryView:topView];
    [self.sourceTypeTextField setInputAccessoryView:topView];
    [self.sectionIdTextField setInputAccessoryView:topView];
}

-(void) dismissKeyBoard{
    [self.musicIdTextField resignFirstResponder];//收起键盘
    [self.deviceIdTextField resignFirstResponder];//收起键盘
    [self.groupIdTextField resignFirstResponder];//收起键盘
    [self.keywordTextField resignFirstResponder];//收起键盘
    [self.volumeTextField resignFirstResponder];//收起键盘
    [self.sourceTypeTextField resignFirstResponder];//收起键盘
    [self.sectionIdTextField resignFirstResponder];//收起键盘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.musicIdTextField isExclusiveTouch] && ![self.groupIdTextField isExclusiveTouch] && ![self.deviceIdTextField isExclusiveTouch] && ![self.sourceTypeTextField isExclusiveTouch] && ![self.sectionIdTextField isExclusiveTouch] ) {//判断点击是否在textfield和键盘以外
        [self dismissKeyBoard];
    }
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
