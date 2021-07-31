

#import "DeviceController.h"
#import "Loading.h"
#import "SBluetoothClient.h"
#import "WifiInfo.h"

@interface DeviceController ()

//可用的wifi列表
@property(nonatomic,strong)NSArray<WifiInfo*>* wifiInfos;

@end

@implementation DeviceController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=[SBluetoothClient sharedInstance].ssid;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"获取WIFI" style:UIBarButtonItemStylePlain target:self action:@selector(perFormGetWifi:)];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[SBluetoothClient sharedInstance] close];
}

-(void)perFormGetWifi:(id)paramSender{
    [Loading show:nil];
    __weak typeof(self) weakSelf = self;
    [[SBluetoothClient sharedInstance] getWifiList:^(NSArray<WifiInfo *> * _Nonnull wifiInfos) {
        [Loading dismiss];
        weakSelf.wifiInfos = wifiInfos;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wifiInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    WifiInfo *wifiInfo=[self.wifiInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = wifiInfo.ssid;
    cell.detailTextLabel.text = wifiInfo.bssid;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WifiInfo *wifiInfo=[self.wifiInfos objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入wifi密码" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*userNameTextField = alertController.textFields.firstObject;
        [Loading show:nil];
        __weak typeof(self) weakSelf = self;
        [[SBluetoothClient sharedInstance] link:wifiInfo password:userNameTextField.text linkResult:^(NSInteger state) {
            [Loading dismiss];
            NSString *tip = state == 0 ? @"配网成功!": @"配网失败!";
            UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:tip preferredStyle:UIAlertControllerStyleAlert];
            [alertController1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:TRUE];
            }]];
            [weakSelf presentViewController:alertController1 animated:YES completion:nil];
        }];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_NonnulltextField) {}];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
