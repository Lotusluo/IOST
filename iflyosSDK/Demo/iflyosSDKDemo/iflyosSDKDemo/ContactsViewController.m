//
//  ContactsViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 test. All rights reserved.
//

#import "ContactsViewController.h"
#import "LogTextViewController.h"
#import "UserInfoModel.h"
@interface ContactsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasources;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(0, 0, 30, 30);
    [cancleButton setTitle:@"创建" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(createContacts) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.datasources == nil) {
        self.datasources = [[NSMutableArray alloc] init];
    }else{
        [self.datasources removeAllObjects];
    }
    [self asynRequestContacts];
}

-(void) asynRequestContacts{
//    [[IFLYOSSDK shareInstance] getContactsList:^(NSInteger statusCode) {
//        NSLog(@"状态码：%li",statusCode);
//    } requestSuccess:^(id _Nonnull data) {
//        NSDictionary *dict = (NSDictionary *)data;
//        NSArray *dataArray = dict[@"contacts"];
//        for (NSDictionary *userInfoDict in dataArray) {
//            UserInfoModel *user = [[UserInfoModel alloc] init];
//            user._id = [[userInfoDict valueForKey:@"id"] integerValue];
//            user.name = [userInfoDict valueForKey:@"name"];
//            
//            NSArray *phones = [userInfoDict valueForKey:@"phones"];
//            user.phones = phones;
//            [self.datasources addObject:user];
//        }
//        
//        [self.tableView reloadData];
//    } requestFail:^(id _Nonnull data) {
//        [self log:[self convertToJsonData:data]];
//    }];
}

-(void) createContacts{
    [self openContactsView];
}

//添加编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;;
}
//左滑风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UserInfoModel *userInfo = self.datasources[row];
    
    UITableViewRowAction *rowDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 点击删除时 do something
//        [[IFLYOSSDK shareInstance] deleteContacts:userInfo._id statusCode:^(NSInteger statusCode) {
//            NSLog(@"状态码：%li",statusCode);
//        } requestSuccess:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        } requestFail:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        }];
    }];
    
    //    rowActionSec.backgroundColor = [UIColor colorWithHexString:@"f38202"];
    rowDelete.backgroundColor = [UIColor redColor];
    
    
    
    UITableViewRowAction *rowUpdate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更新" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 点击更新 do something
        [self openContactsView:userInfo._id name:userInfo.name phones:userInfo.phones];
    }];
    
    return @[rowDelete,rowUpdate];
}

//设置行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = self.datasources.count;
    return row;
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    UserInfoModel *userInfo = self.datasources[row];
    
//    [[IFLYOSSDK shareInstance] getContactsInfo:userInfo._id statusCode:^(NSInteger statusCode) {
//        NSLog(@"状态码：%li",statusCode);
//    } requestSuccess:^(id _Nonnull data) {
//        [self log:[self convertToJsonData:data]];
//    } requestFail:^(id _Nonnull data) {
//        [self log:[self convertToJsonData:data]];
//    }];
}

//设置每行的cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UserInfoModel *userInfo = self.datasources[row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"contactsCell"];
    }
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)userInfo._id];
    cell.detailTextLabel.text = userInfo.name;
    return cell;
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

-(void) openContactsView{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"创建联系人"
                                                                              message: @"输入联系人名称电话"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = @"张三";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"phone";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = @"13800000000";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        UITextField * phonefield = textfields[1];
        NSLog(@"%@:%@",namefield.text,phonefield.text);
        
//        [[IFLYOSSDK shareInstance] createContacts:namefield.text phones:@[phonefield.text] statusCode:^(NSInteger statusCode) {
//            NSLog(@"状态码：%li",statusCode);
//        } requestSuccess:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        } requestFail:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消成功");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) openContactsView:(NSInteger) _id name:(NSString *)name phones:(NSArray *) phones{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"更新联系人"
                                                                              message: @"输入联系人名称电话"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = name;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"phone";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        if (phones && phones.count > 0) {
            textField.text = phones[0];
        }
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        UITextField * phonefield = textfields[1];
        NSLog(@"%@:%@",namefield.text,phonefield.text);
        
//        [[IFLYOSSDK shareInstance] updateContacts:_id name:namefield.text phones:@[phonefield.text] statusCode:^(NSInteger statusCode) {
//            NSLog(@"状态码：%li",statusCode);
//        } requestSuccess:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        } requestFail:^(id _Nonnull data) {
//            [self log:[self convertToJsonData:data]];
//        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消成功");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
