
#import "ScanController.h"
#import "Loading.h"
#import "SBluetoothClient.h"
#import "LeDevice.h"

@interface ScanController ()

//搜索到的蓝牙设备
@property (nonatomic,strong) NSMutableArray<LeDevice *> *devices;

@end

@implementation ScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.devices = NSMutableArray.new;
    self.navigationItem.title=@"蓝牙搜索";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStylePlain target:self action:@selector(perFormScan:)];
}


-(void)perFormScan:(id)paramSender{
    [self.devices removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [SBluetoothClient.sharedInstance startScan:^(LeDevice * _Nullable device) {
        if(!device){
            NSLog(@"搜索失败");
            return;
        }
        if(![weakSelf.devices containsObject:device]){
            [weakSelf.devices addObject:device];
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    LeDevice *device=[self.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.leName;
    cell.detailTextLabel.text = device.identifier;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Loading show:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeDevice *device=[self.devices objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    [[SBluetoothClient sharedInstance] connect:device connectResult:^(NSInteger state) {
        [Loading dismiss];
        if(state == 0){
            DeviceController* dtvc=[weakSelf.storyboard instantiateViewControllerWithIdentifier:@"DeviceController"];
            [weakSelf.navigationController pushViewController:dtvc animated:YES];
        }else{
            NSLog(@"连接失败:%ld",(long)state);
        }
    }];
}

@end
