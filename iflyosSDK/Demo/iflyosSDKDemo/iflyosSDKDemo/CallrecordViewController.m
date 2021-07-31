//
//  CallrecordViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/11/13.
//  Copyright © 2018年 test. All rights reserved.
//

#import "CallrecordViewController.h"
#import "LogTextViewController.h"

@interface CallrecordViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasources;
@property (weak, nonatomic) IBOutlet UITextField *deviceIdTextField;

@end

@implementation CallrecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createKeyboardButton];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.datasources == nil) {
        self.datasources = [[NSMutableArray alloc] init];
    }else{
        [self.datasources removeAllObjects];
    }
    [self asynRequestRecord];
}

- (IBAction)requestRecord:(id)sender {
    [self asynRequestRecord];
}

-(void) asynRequestRecord{
    if(self.deviceIdTextField.text==nil || [self.deviceIdTextField.text isEqualToString:@""]){
        return;
    }
//    [[IFLYOSSDK shareInstance] getContactRecords:self.deviceIdTextField.text statusCode:^(NSInteger statusCode) {
//        NSLog(@"状态码：%li",statusCode);
//    } requestSuccess:^(id _Nonnull data) {
//        NSDictionary *dict = (NSDictionary *)data;
//        NSArray *dataArray = dict[@"contact_records"];
//        for (NSDictionary *record in dataArray) {
//            [self.datasources addObject:record[@"phone"]];
//        }
//        [self.tableView reloadData];
//    } requestFail:^(id _Nonnull data) {
//        [self log:[self convertToJsonData:data]];
//    }];
}

//设置行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = self.datasources.count;
    return row;
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//设置每行的cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *phone = self.datasources[row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recordCell"];
    }
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = phone;
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
