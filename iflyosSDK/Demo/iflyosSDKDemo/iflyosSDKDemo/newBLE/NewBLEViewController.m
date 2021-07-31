//
//  NewBLEViewController.m
//  iflyosSDKDemo
//
//  Created by 周经伟 on 2020/10/1.
//  Copyright © 2020 test. All rights reserved.
//

#import "NewBLEViewController.h"
#import "AuthViewController.h"
#import "NewBLEProtocalModel.h"
#import "NewBLEProtocalParser.h"
#import "UIView+UIView_alertView.h"
#import "NSString+NSString_hex.h"
#import "NSData+hex.h"
#import <iflyosSDKForiOS/IFLYOSNSString+SBJSONParsing.h>
#define kServiceUUID @"0000FFF0-0000-1000-8000-00805F9B34FB"             // 服务的UUID
#define kWriteCharacteristicUUID @"0000FFF4-0000-1000-8000-00805F9B34FB"      // 写特征的UUID
#define kReadCharacteristicUUID @"0000FFF4-0000-1000-8000-00805F9B34FB"      // 读特征的UUID
#define kNotifcationCharacteristicUUID @"0000FFF4-0000-1000-8000-00805F9B34FB"      // 订阅特征的UUID
#define keep_alive @"keep-alive"//保持连接
#define keep_alive_time 1.0f //每1秒发送一次

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NewBLEViewController ()<CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *startSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *stopSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectBLEButton;

//搜索的蓝牙数组
@property (strong,nonatomic) NSMutableArray *bleArrays;
// 中心管理者(管理设备的扫描和连接)
@property (nonatomic, strong) CBCentralManager *centralManager;
// 当前连接的BLE设备
@property (nonatomic, strong) CBPeripheral *currentPeripheral;
//特征值
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
//服务
@property (nonatomic, strong) CBService *service;

//全局视图
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIView *clientInfoView;

@property(atomic,assign) BOOL isRun;
//数据
@property (nonatomic, strong) NSMutableData *clientInfoDatas;
@property (assign,nonatomic) NSInteger clientInfoLen;
@property (assign,nonatomic) BOOL isClientInfo;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *deviceId;

@property (assign,nonatomic) BOOL isCheckDeviceCode;
@property (nonatomic, copy) NSString *deviceCode;

//协议组装
@property (nonatomic,strong) NewBLEProtocalModel *protocalModel;
//解析协议
@property (nonatomic,strong) NewBLEProtocalParser *protocalParser;
@end

@implementation NewBLEViewController

-(NSMutableData *) clientInfoDatas{
    if (!_clientInfoDatas) {
        _clientInfoDatas = [[NSMutableData alloc] init];
    }
    return _clientInfoDatas;
}

-(NewBLEProtocalModel *) protocalModel{
    if (!_protocalModel) {
        _protocalModel = [[NewBLEProtocalModel alloc] init];
    }
    return _protocalModel;
}

-(NewBLEProtocalParser *) protocalParser{
    if (!_protocalParser) {
        _protocalParser = [[NewBLEProtocalParser alloc] init];
    }
    return _protocalParser;
}

-(UIView *) clientInfoView{
    if (!_clientInfoView) {
        _clientInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
        _clientInfoView.backgroundColor = [UIColor clearColor];
        _clientInfoView.layer.cornerRadius = 12;
        _clientInfoView.layer.masksToBounds = YES;
    }
    return _clientInfoView;
}

-(UIActivityIndicatorView *) loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        [_loadingView setHidesWhenStopped:YES];
    }
    return _loadingView;
}

-(NSMutableArray *) bleArrays{
    if (!_bleArrays){
        _bleArrays = [[NSMutableArray alloc] init];
    }
    return _bleArrays;
}

-(CBCentralManager *) centralManager{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:dispatch_get_main_queue()
                                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
    return _centralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.editable = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.disconnectBLEButton setEnabled:NO];
    [self.view addSubview:self.loadingView];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopSendBLEData];
    [self disconnect];
}

-(void) dealloc{
    NSLog(@"退出配网");
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//打印日志
-(void) writeLog:(NSString *) txt{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"BLE log :: %@",txt);
        if (self.textView){
            self.textView.text = [self.textView.text stringByAppendingFormat:@"> %@ \n",txt];
            [self.textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
        }
    });
}

-(IBAction) scan:(id)sender{
    [self starScan];
}

-(IBAction) stopScan:(id)sender{
    [self stopScan];
}

- (IBAction)sendSsidPskAction:(id)sender {
    [self disconnect];
    [self.startSearchButton setEnabled:YES];
    [self.stopSearchButton setEnabled:NO];
    [self.disconnectBLEButton setEnabled:NO];
}

-(void) starScan{
    [self writeLog:@"ble star scan +++"];
    NSArray *uuids = @[[CBUUID UUIDWithString:kServiceUUID]];
    [self.bleArrays removeAllObjects];
    [self.tableView reloadData];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    [self.startSearchButton setEnabled:NO];
    [self.stopSearchButton setEnabled:YES];
    [self.disconnectBLEButton setEnabled:NO];
}

-(void) stopScan{
    [self writeLog:@"ble stop scan ---"];
    [self.centralManager stopScan];
    [self.startSearchButton setEnabled:NO];
    [self.stopSearchButton setEnabled:NO];
}


//检查蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            [self writeLog:@"未知"];
            
            break;
        case CBManagerStateResetting:
            [self writeLog:@"状态重置"];
            
            break;
        case CBManagerStateUnsupported:
            [self writeLog:@"不支持蓝牙"];
            
            break;
        case CBManagerStateUnauthorized:
            [self writeLog:@"授权失败"];
            
            break;
        case CBManagerStatePoweredOff:
            [self writeLog:@"蓝牙不可用"];
            //跳转蓝牙设置界面
            
            
            break;
        case CBManagerStatePoweredOn:
        {
            [self writeLog:@"蓝牙可用"];
            
            [self starScan];
        }
            break;
        default:
            
            break;
    }
}

#pragma IFLYBEL 连接操作
//连接蓝牙
-(void) connect:(CBPeripheral *) peripheral{
    if(peripheral){
        [self writeLog:[NSString stringWithFormat:@"ble [%@] connecting",peripheral.name]] ;
        // 连接蓝牙设备
        [self.centralManager connectPeripheral:peripheral options:nil];
        // 记录连接的蓝牙,并且设置该外围设备协议
        [peripheral setDelegate:self];
    }
}

//取消连接蓝牙
-(void) disconnect{
    if (self.currentPeripheral) {
        [self writeLog:[NSString stringWithFormat:@"ble disconnect : %@",self.currentPeripheral.name]];
//        NSData *bleData = [@"disconnect" dataUsingEncoding:NSUTF8StringEncoding];
//        [self writeData:bleData];
        [self.centralManager cancelPeripheralConnection:self.currentPeripheral];
        self.currentPeripheral = nil;
        [self.bleArrays removeAllObjects];
        [self.tableView reloadData];
        [self.disconnectBLEButton setEnabled:NO];
    }
}

//写数据
-(void) writeData:(NSData *) data{
    if(self.readCharacteristic){
        
        if (data) {
            NSMutableString *hexStr = [[NSMutableString alloc] init];
            [hexStr appendFormat:@"字节序(size:%lu): [",(unsigned long)data.length];
            for (int j = 0; j < data.length; ++j)
            {
                [hexStr appendFormat:@" %02X", ((UInt8 *) data.bytes)[j]];
            }
            [hexStr appendFormat:@" ]"];
            
            [self writeLog:hexStr];
        }
        
        if (self.currentPeripheral.state == CBPeripheralStateConnected) {
//            [self writeLog:[NSString stringWithFormat:@"ble data size:%lu byte",(unsigned long)data.length]] ;
            if(self.readCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
            {
                //手机向外设发送数据，写数据
                [self.currentPeripheral writeValue:data forCharacteristic:self.readCharacteristic type:CBCharacteristicWriteWithoutResponse];
            }else
            {
                [self.currentPeripheral writeValue:data forCharacteristic:self.readCharacteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}

#pragma 蓝牙回调
//发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    if (!peripheral.name) {
        return;
    }
    [self writeLog:[NSString stringWithFormat:@"ble scan name ：%@，uuid：%@，rssi：%@",peripheral.name,peripheral.identifier.UUIDString,RSSI]];
    [self.bleArrays addObject:peripheral];
    self.bleArrays = [[self.bleArrays valueForKeyPath:@"@distinctUnionOfObjects.self"] mutableCopy];
    [self.tableView reloadData];
}

/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [self writeLog:@"ble connect success..."];
    self.currentPeripheral = peripheral;
    [self.currentPeripheral setDelegate:self];
    NSArray *uuids = @[[CBUUID UUIDWithString:kServiceUUID]];
    [self.currentPeripheral discoverServices:uuids];
    [self.disconnectBLEButton setEnabled:YES];
    [self stopScan];
    [self.tableView reloadData];
}

/** 发现服务 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error)
    {
        [self writeLog:[NSString stringWithFormat:@"ble Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]]];
        return;
    }
    NSArray *uuids = @[[CBUUID UUIDWithString:kWriteCharacteristicUUID]];
    for (CBService *service in peripheral.services) {
        [self.currentPeripheral discoverCharacteristics:uuids forService:service];
    }
}

/** 发现特征回调 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error)
    {
        [self writeLog:[NSString stringWithFormat:@"ble Discovered Characteristics for %@ with error: %@", peripheral.name, [error localizedDescription]]];
        return;
    }
    [self writeLog:[NSString stringWithFormat:@"BLE 特征共: %li 个", service.characteristics.count]];
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        [self writeLog:[NSString stringWithFormat:@"BLE 特征共: %li 个", characteristic.properties]];
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kReadCharacteristicUUID]]) {
            [self writeLog:@"蓝牙-发现读的特征%@"];
            // 这里是读取Mac地址， 可不要， 数据固定， 用readValueForCharacteristic， 不用setNotifyValue:setNotifyValue
            self.readCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]]) {
            // 写的特征值
            [self writeLog:@"蓝牙-发现写的特征"];
            self.writeCharacteristic = characteristic;
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifcationCharacteristicUUID]]) {
            // 订阅特性，当数据频繁改变时，一般用它， 不用readValueForCharacteristic
            [self writeLog:@"蓝牙-发现订阅服务的特征"];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    [self openLoginView];
}

-(void) sendBLEData:(NSData *) data{
    //分包
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    
    if (data.length > 20){
        NSInteger num = data.length / 20; //分多少次包
        NSInteger last = data.length % 20; //余数
        
        if (last > 0) {
            num = num + 1;
        }
        [self writeLog:[NSString stringWithFormat:@"BLE 分包 %li 个, 剩下:%li",num,last]];
        
        for (int i = 0 ; i < num ; i++) {
            if (i == (num - 1)) {
                NSData *tmpData = [data subdataWithRange:NSMakeRange(i * 20, last)];
                [datas addObject:tmpData];
            }else{
                NSData *tmpData = [data subdataWithRange:NSMakeRange(i * 20, 20)];
                [datas addObject:tmpData];
            }
        }
        [self writeLog:[NSString stringWithFormat:@"总共：%li 个包",datas.count]];
        
        for (NSData *wData in datas){
            [self writeData:wData];
        }
    }else{
        [self writeData:data];
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.isRun = YES;
//        while (self.isRun) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self writeData:data];
//            });
//            [NSThread sleepForTimeInterval:keep_alive_time];
//        }
//        [self writeLog:@"ble send end...."];
//    });
}

-(void) stopSendBLEData{
    self.isRun = NO;
}

-(void) keepAliveStart{
//    if (self.isKeepAlive) {
//        //正在检测，泽
//        [self writeLog:@"ble keepAlive staring"];
//        return ;
//    }
//    self.isKeepAlive = YES;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (self.isKeepAlive) {
//            //            [self writeLog:@"蓝牙-发送keep alive");
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self writeData:[keep_alive dataUsingEncoding:NSUTF8StringEncoding]];
//                //                [self writeData:[@"iflytek\niflytek!@#\n9c417cb54cd8" dataUsingEncoding:NSUTF8StringEncoding]];
//            });
//            [NSThread sleepForTimeInterval:keep_alive_time];
//        }
//        [self writeLog:@"ble keep alive over"];
//        [self keepAliveStop];
//    });
}

-(void) keepAliveStop{
    self.isRun = NO;
}

/**
 * 蓝牙连接后读特征
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        [self writeLog:[NSString stringWithFormat:@"ble update characteristic fail:%@",error.userInfo]];
        return ;
    }
    
    NSData *respData = characteristic.value;
    __weak typeof(self) weakSelf = self;
    
    if (respData){
        NewBLEProtocalParserDeviceInfoModel *parser = [self.protocalParser parserResponseAck:respData];
        if (parser) {
            [self writeLog:[NSString stringWithFormat:@"设备->App :: %@",parser.hexString]];
        }
        
        //ssid & psk ACK
        if (parser.cmd == CMD_RESPONSE) {
            self.isClientInfo = NO;
            if (parser.cmdValue == 0x01) {
                //回复收到Ssid & psk
                [self writeLog:@"收到 Ssid & psk"];
            }else if (parser.cmdValue == 0x02) {
                //回复收到device code
                [self writeLog:@"收到 device code"];
            }
        }else if (parser.cmd == CMD_DEVICE_INFO){
            self.isClientInfo = YES;
            self.clientInfoLen = parser.len;
            if (self.clientInfoDatas.length <= 0) {
                [self.clientInfoDatas appendData:respData];
            }
        } else if (parser.cmd == CMD_LINK_STATUS) {
            self.isClientInfo = NO;
            if (parser.cmdValue == 0x01) {
                //回复收到连接路由器失败
                [weakSelf writeLog:[NSString stringWithFormat:@">>>>设备配网状态 : 连接路由器失败 %02X" ,parser.cmdValue]];
                weakSelf.isCheckDeviceCode = NO;
            }else if (parser.cmdValue == 0x02) {
                //回复收到连上路由器，没连接到互联网
                [weakSelf writeLog:[NSString stringWithFormat:@">>>>设备配网状态 : 连上路由器，没连接到互联网 %02X" ,parser.cmdValue]];
                weakSelf.isCheckDeviceCode = NO;
            }else if (parser.cmdValue == 0x03) {
                //回复收到连接到互联网
                [weakSelf writeLog:[NSString stringWithFormat:@">>>>设备配网状态 : 连接到互联网 %02X" ,parser.cmdValue]];
                [weakSelf checkDeviceCodeAuth];
            }
        }else{
            if (self.isClientInfo){
                if ( self.clientInfoDatas.length == self.clientInfoLen) {
                    [self.currentPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                    NSData *clientInfoData = [self.clientInfoDatas copy];
                    if (clientInfoData) {
                        NSMutableString *hexStr = [[NSMutableString alloc] init];
                        [hexStr appendFormat:@"字节序(size:%lu): client info [",(unsigned long)clientInfoData.length];
                        for (int j = 0; j < clientInfoData.length; ++j)
                        {
                            [hexStr appendFormat:@" %02X", ((UInt8 *) clientInfoData.bytes)[j]];
                        }
                        [hexStr appendFormat:@" ]"];
                        
                        [self writeLog:hexStr];
                    }
                
                    self.isClientInfo = NO;
                    NewBLEProtocalParserDeviceInfoModel *clientInfoParser = [self.protocalParser parserResponseAck:clientInfoData];
                    
                    [[IFLYOSSDK shareInstance] getDeviceCode:clientInfoParser.clientId deviceId:clientInfoParser.deviceId statusCode:^(NSInteger statusCode) {
                        NSLog(@"ble deviceCode request status code : %li",statusCode);
                    } requestSuccess:^(id _Nonnull data) {
                        NSDictionary *resultDict = data;
                        NSString *deviceCode = resultDict[@"device_code"];
                        weakSelf.deviceCode = deviceCode;
                        [weakSelf sendDeviceCode:deviceCode];
                        [weakSelf writeLog:[NSString stringWithFormat:@">>>>deviceCode : %@" ,deviceCode]];
                        [weakSelf.currentPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                    } requestFail:^(id _Nonnull data) {
                        NSLog(@"ble deviceCode fail: %@",data);
                        [weakSelf writeLog:[weakSelf convertToJsonData:data]];
                    }];
                }else{
                    [self.clientInfoDatas appendData:respData];
                }
            }
            
        }
    }
    /**
     * didUpdateValueForCharacteristic，此方法每次蓝牙发送回来的数据都会回调一次
     * 由于没有设备和win调试蓝牙设备，这里模拟了组装和解析BLE字节序的代码
     **/
//    [self test];
}

/**
 * 通过deviceCode查看是否授权成功
 */
-(void) checkDeviceCodeAuth{
    if (self.isCheckDeviceCode) {
        return;
    }
    [self.currentPeripheral setNotifyValue:NO forCharacteristic:self.writeCharacteristic];
    __weak typeof(self) weakSelf = self;
    [self.loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.isCheckDeviceCode = YES;
//        while (self.isCheckDeviceCode) {
            [[IFLYOSSDK shareInstance] getBLEAuthrization:self.deviceCode statusCode:^(NSInteger statusCode) {
                NSLog(@"ble authrization request status code : %li",statusCode);
            } requestSuccess:^(id _Nonnull data) {
                [weakSelf writeLog:[NSString stringWithFormat:@"ble deviceCode success: %@",data]];
                
                [IFLYOSSDK shareInstance].isStopBLEConfirmLoop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.isCheckDeviceCode = NO;
                    [weakSelf writeLog:[NSString stringWithFormat:@"蓝牙【%@】授权成功auth success... ^_^ \n",weakSelf.currentPeripheral.name]];
                    [weakSelf.loadingView stopAnimating];
                });
            } requestFail:^(id _Nonnull data) {
                [weakSelf writeLog:[NSString stringWithFormat:@"ble deviceCode fail: %@",data]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView showAlert:@"提示" message:data target:self];
                    [weakSelf writeLog:[NSString stringWithFormat:@"蓝牙【%@】auth fail... -^-\n",weakSelf.currentPeripheral.name]];
                    [weakSelf.loadingView stopAnimating];
                });
            }];
            
//            [NSThread sleepForTimeInterval:keep_alive_time];
//        }
        [self writeLog:@"ble send end...."];
    });
}

/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self writeLog:error.localizedDescription];
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [self writeLog:error.localizedDescription];
    [self keepAliveStop];
}
    
    
#pragma tableView

//设置行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = self.bleArrays.count;
    return row;
}

//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *bluetooth = self.bleArrays[indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(10, 10);//只能设置中心，不能设置大小
    [activityView startAnimating];
    cell.accessoryView = activityView;
    
    [self connect:bluetooth];
}

//设置每行的cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CBPeripheral *bluethoot = self.bleArrays[row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bleCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bleCell"];
    }
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 对齐方式
    style.alignment = NSTextAlignmentLeft;
    // 首行缩进
    //    style.firstLineHeadIndent =2.0f;
    
    NSString *bleInfo = [NSString stringWithFormat:@"%@(%@)",bluethoot.name?bluethoot.name:@"无",bluethoot.identifier.UUIDString];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:bleInfo attributes:@{ NSParagraphStyleAttributeName : style}];
    cell.textLabel.attributedText = attrText;
    return cell;
}

-(void) openLoginView{
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"配网"
                                                                              message: @"\n\n\n\n\n\n\n\n\n\n\n输入WiFi账号密码"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = @"iflytek";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"password";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
        textField.text = @"iflytek!@#";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        UITextField * passwordfiled = textfields[1];
        weakSelf.textView.text = [weakSelf.textView.text stringByAppendingFormat:@"蓝牙【%@】发送 = %@:%@ \n",weakSelf.currentPeripheral.name,namefield.text,passwordfiled.text];
        
        NSString *ssid = namefield.text;
        NSString *psk = passwordfiled.text;
        
        [weakSelf sendSsidAndPsk:ssid psk:psk];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf writeLog:[NSString stringWithFormat:@"蓝牙【%@】关闭。。\n",self.currentPeripheral.name]];
        [weakSelf disconnect];
    }]];
    
    [alertController.view addSubview:self.clientInfoView];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
/**
 * 组装协议和解析协议demo
 * 组装App -> 设备
 * 解析设备 -> App
 */
-(void) test{
//    //App -> 设备 请求SSID & PSK
//    NSData *wifiData = [self.protocalModel paySsidAndPsk:@"HKLT-8" psk:@"11112222"];
//    [self writeData:wifiData];
//
//    //App -> 设备 Ack 收到 clientId, deviceId
//    Byte deviceCodeAck = 0x02;
//    NSData *deviceCodeAckData = [self.protocalModel payAck:&deviceCodeAck];
//    [self writeData:deviceCodeAckData];
//
//    //App -> 设备 发送 devicecode:"12345"
//    NSData *deviceCodeData = [self.protocalModel payDeviceCode:@"12345"];
//    [self writeData:deviceCodeData];
//
//    //App -> 设备 收到联网的状态了
//    Byte linkAck = 0x01;
//    NSData *linAckAckData = [self.protocalModel payAck:&linkAck];
//    [self writeData:linAckAckData];
    
    //设备 -> App 应答:收到 SSID 和 PSK
    Byte wifiACK[] = {0x55,0x44,0x06,0x10,0x01,0xB0};
    
    Byte sendDeviceInfo[] = {0x55,0x44,0x4E,0x11,0x24,0x34,0x63,0x31,0x66,0x63,0x36,0x31,0x35,0x2d,0x61,0x63,0x65,0x37,0x2d,0x34,0x32,0x63,0x63,0x2d,0x62,0x61,0x31,0x63,0x2d,0x65,0x66,0x30,0x37,0x62,0x38,0x63,0x39,0x63,0x34,0x34,0x37,0x61,0x35,0x39,0x35,0x31,0x36,0x34,0x30,0x2d,0x37,0x32,0x31,0x30,0x2d,0x34,0x37,0x32,0x65,0x2d,0x39,0x38,0x39,0x38,0x2d,0x63,0x63,0x30,0x31,0x61,0x37,0x63,0x30,0x32,0x65,0x32,0x35,0xCB};
    
    Byte deviceCodeACK[] = {0x55,0x44,0x06,0x10,0x02,0xB1};
    
    Byte sendLink[] = {0x55,0x44,0x06,0x12,0x03,0xB4};
    
    NSData *wifiAckData = [[NSData alloc] initWithBytes:wifiACK length:6];
    NSData *sendDeviceInfoData = [[NSData alloc] initWithBytes:sendDeviceInfo length:78];
    NSData *deviceCodeACKData = [[NSData alloc] initWithBytes:deviceCodeACK length:6];
    NSData *sendLinkData = [[NSData alloc] initWithBytes:sendLink length:6];
    
    NewBLEProtocalParserDeviceInfoModel *parser = [self.protocalParser parserResponseAck:sendDeviceInfoData];
    [self writeLog:[NSString stringWithFormat:@"设备->App :: %@",parser.hexString]];
    
    __weak typeof(self) weakSelf = self;
    [[IFLYOSSDK shareInstance] getDeviceCode:parser.clientId deviceId:parser.deviceId statusCode:^(NSInteger statusCode) {
        NSLog(@"ble deviceCode request status code : %li",statusCode);
    } requestSuccess:^(id _Nonnull data) {
        NSDictionary *resultDict = data;
        NSString *deviceCode = resultDict[@"device_code"];
        weakSelf.deviceCode = deviceCode;
        [weakSelf openLoginView];
    } requestFail:^(id _Nonnull data) {
        NSLog(@"ble deviceCode fail: %@",data);
        [self writeLog:[self convertToJsonData:data]];
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

-(void) sendDeviceCode:(NSString *) deviceCode{
    //App -> 设备 发送 devicecode:"12345"
    NSData *deviceCodeData = [self.protocalModel payDeviceCode:deviceCode];
    [self sendBLEData:deviceCodeData];
}

-(void) sendSsidAndPsk:(NSString *) ssid psk:(NSString *) psk{
    //App -> 设备 请求SSID & PSK
    NSData *wifiData = [self.protocalModel paySsidAndPsk:ssid psk:psk];
    [self sendBLEData:wifiData];
}
@end

