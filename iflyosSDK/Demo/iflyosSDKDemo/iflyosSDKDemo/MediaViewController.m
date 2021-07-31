//
//  MediaViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/9/1.
//  Copyright © 2020 test. All rights reserved.
//

#import "MediaViewController.h"
#import "LogTextViewController.h"
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "AlertView.h"
#import "UIView+UIView_alertView.h"
@interface MediaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *deviceIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *tagIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *idsTextField;
@property (weak, nonatomic) IBOutlet UITextField *sourceTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mediaIdTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@end

@implementation MediaViewController

-(NSMutableArray *) datasource{
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datasource addObject:@"获取标签"];
    [self.datasource addObject:@"查看播放记录接口"];
    [self.datasource addObject:@"删除播放记录"];
    [self.datasource addObject:@"播放记录列表播放接口"];
    [self setupView];
    [self createKeyboardButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) setupView{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = self.datasource.count;
    return row;
}

//设置每行的cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaViewControllerCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaViewControllerCell"];
    }
    cell.textLabel.text = self.datasource[row];
    return cell;
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (row) {
        case 0:
            [self openTags];
            break;
        case 1:
            [self openRecords];
            break;
        case 2:
            [self openDeleteRecords];
            break;
        case 3:
            [self openRecordsPlay];
            break;
        default:
            break;
    }
}

-(void) log:(NSString *) text{
    LogTextViewController *logVc = [[LogTextViewController alloc] initWithNibName:@"LogTextViewController" bundle:nil];
    logVc.text = text;
    [self.navigationController pushViewController:logVc animated:YES];
}

-(void) openTags{
    [[IFLYOSSDK shareInstance] getRecordsTags:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) openRecords{
    NSString *deviceId = self.deviceIdTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    
    NSString *tagId = self.tagIdTextField.text;
    if(!tagId || [tagId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"tagId不能为空" target:self];
        return ;
    }
    
    [[IFLYOSSDK shareInstance] getRecordsPlay:deviceId tag_id:[tagId integerValue] statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) openDeleteRecords{
    NSString *deviceId = self.deviceIdTextField.text;
    if(!deviceId || [deviceId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"deviceId不能为空" target:self];
        return ;
    }
    NSString *tagId = self.tagIdTextField.text;

    NSArray *idsArray = nil;
    NSString *ids = self.idsTextField.text;
    if(!ids || ![ids isEqualToString:@""]){
        idsArray = [ids componentsSeparatedByString:@","];
    }
    
    NSMutableArray *idsIntArray = [[NSMutableArray alloc] init];
    for (NSString *idStr in idsArray){
        NSInteger _id = [idStr integerValue];
        [idsIntArray addObject:@(_id)];
    }
    
    if (idsIntArray.count == 0){
        idsIntArray = nil;
    }
    
    [[IFLYOSSDK shareInstance] deleteRecords:deviceId tag_id:[tagId integerValue] ids:idsIntArray statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
}

-(void) openRecordsPlay{
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
    
    NSString *mediaId = self.mediaIdTextField.text;
    
    NSString *tagId = self.tagIdTextField.text;
    if(!tagId || [tagId isEqualToString:@""]){
        [UIView showAlert:@"提示" message:@"tag_id不能为空" target:self];
        return ;
    }
    
    [[IFLYOSSDK shareInstance] playRecordsList:deviceId source_type:sourceType media_id:mediaId tag_id:[tagId integerValue] statusCode:^(NSInteger statusCode) {
        NSLog(@"状态码：%li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSLog(@"success : %@",data);
        [self log:[self convertToJsonData:data]];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"error : %@",data);
        [self log:[self convertToJsonData:data]];
    }];
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
    
    [self.deviceIdTextField setInputAccessoryView:topView];
    [self.tagIdTextField setInputAccessoryView:topView];
    [self.idsTextField setInputAccessoryView:topView];
    [self.sourceTypeTextField setInputAccessoryView:topView];
    [self.mediaIdTextField setInputAccessoryView:topView];
    
}

-(void) dismissKeyBoard{
    [self.deviceIdTextField resignFirstResponder];//收起键盘
    [self.tagIdTextField resignFirstResponder];//收起键盘
    [self.idsTextField resignFirstResponder];//收起键盘
    [self.sourceTypeTextField resignFirstResponder];//收起键盘
    [self.mediaIdTextField resignFirstResponder];//收起键盘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.deviceIdTextField isExclusiveTouch] &&
        ![self.tagIdTextField isExclusiveTouch] &&
        ![self.idsTextField isExclusiveTouch] &&
        ![self.sourceTypeTextField isExclusiveTouch]&&
        ![self.mediaIdTextField isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
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
@end
