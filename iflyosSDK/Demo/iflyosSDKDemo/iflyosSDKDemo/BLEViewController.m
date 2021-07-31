//
//  BLEViewController.m
//  iflyosSDKDemo
//
//  Created by admin on 2018/11/9.
//  Copyright © 2018年 test. All rights reserved.
//

#import "BLEViewController.h"
#import "AuthViewController.h"
#import "UIView+UIView_alertView.h"
#import <iflyosSDKForiOS/IFLYOSNSString+SBJSONParsing.h>
#define kServiceUUID @"00001ff9-0000-1000-8000-00805f9b34fb"             // 服务的UUID
#define kWriteCharacteristicUUID @"00001ffa-0000-1000-8000-00805f9b34fb"      // 写特征的UUID
#define kReadCharacteristicUUID @"00001ffa-0000-1000-8000-00805f9b34fb"      // 读特征的UUID
#define keep_alive @"keep-alive"//保持连接
#define keep_alive_time 5.0f //每5秒发送一次

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BLEViewController ()<IFLYOSBLEManagerDelegate,CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *stopScanButton;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (strong,nonatomic) NSMutableArray *bleArrays;

@property(strong,nonatomic) WKWebView *webView;

// 中心管理者(管理设备的扫描和连接)
@property (nonatomic, strong) CBCentralManager *centralManager;
// 当前连接的BLE设备
@property (nonatomic, strong) CBPeripheral *currentPeripheral;
//特征值
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
//服务
@property (nonatomic, strong) CBService *service;


@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *factoryFlag;

@property (nonatomic, strong) UIView *clientInfoView;
@property (nonatomic, strong) UILabel *clientName;
@property (nonatomic, strong) UIImageView *clientImageView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property(atomic,assign) BOOL isKeepAlive;
@end

@implementation BLEViewController
#pragma BLE代码

-(UIActivityIndicatorView *) loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        [_loadingView setHidesWhenStopped:YES];
    }
    return _loadingView;
}
-(UIImageView *) clientImageView{
    if (!_clientImageView) {
        _clientImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 150, 150)];
    }
    return _clientImageView;
}

-(UILabel *) clientName{
    if (!_clientName) {
        _clientName = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 270, 30)];
        _clientName.text = @"未知";
        _clientName.textAlignment = NSTextAlignmentCenter;
    }
    return _clientName;
}

-(UIView *) clientInfoView{
    if (!_clientInfoView) {
        _clientInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
        _clientInfoView.backgroundColor = [UIColor clearColor];
        _clientInfoView.layer.cornerRadius = 12;
        _clientImageView.layer.masksToBounds = YES;
    }
    return _clientInfoView;
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

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"未知");
            
            break;
        case CBManagerStateResetting:
            NSLog(@"状态重置");
            
            break;
        case CBManagerStateUnsupported:
            NSLog(@"不支持蓝牙");
            
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"授权失败");
            
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙不可用");
            //跳转蓝牙设置界面
            
            
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙可用");
            
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
        NSLog(@"ble [%@] connecting",peripheral.name);
        // 连接蓝牙设备
        [self.centralManager connectPeripheral:peripheral options:nil];
        // 记录连接的蓝牙,并且设置该外围设备协议
        [peripheral setDelegate:self];
    }
}

//取消连接蓝牙
-(void) disconnect{
    if (self.currentPeripheral) {
        NSLog(@"ble disconnect : %@",self.currentPeripheral.name);
        NSData *bleData = [@"disconnect" dataUsingEncoding:NSUTF8StringEncoding];
        [self writeData:bleData];
    }
}

//写数据
-(void) writeData:(NSData *) data{
    if(self.writeCharacteristic){
        if (self.currentPeripheral.state == CBPeripheralStateConnected) {
            NSLog(@"ble data size:%lu byte",(unsigned long)data.length);
            if(self.writeCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
            {
                //手机向外设发送数据，写数据
                [self.currentPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            }else
            {
                [self.currentPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}

-(void) starScan{
    NSLog(@"ble star scan +++");
    [self.bleArrays removeAllObjects];
    [self.tableView reloadData];
    [self.logTextView setText:@""];
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:nil];
    [self.scanButton setEnabled:NO];
    [self.stopScanButton setEnabled:YES];
}

-(void) stopScan{
    NSLog(@"ble stop scan ---");
    [self.centralManager stopScan];
    [self.scanButton setEnabled:YES];
    [self.stopScanButton setEnabled:NO];
}

#pragma 蓝牙回调
//发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    NSLog(@"ble scan name ：%@，uuid：%@，rssi：%@",peripheral.name,peripheral.identifier.UUIDString,RSSI);
    if (advertisementData) {
        NSObject *value = [advertisementData objectForKey: @"kCBAdvDataManufacturerData"];
        const char *valueString = [[value description] cStringUsingEncoding: NSUTF8StringEncoding];
        NSString *adStr = [NSString stringWithCString:valueString encoding:NSUTF8StringEncoding];
        if (adStr){
            _clientId = [adStr getBLEAdvertClientId];
            _factoryFlag = [adStr getBLEAdvertFactoryFlag];
        }
        
        if (peripheral && self.clientId) {
            __weak typeof (self) weakSelf = self;
            [[IFLYOSSDK shareInstance] getClientInfo:self.clientId statusCode:^(NSInteger statusCode) {
                
            } requestSuccess:^(id _Nonnull data) {
                NSDictionary *clientInfoDict = data;
                NSString *imgURL = clientInfoDict[@"client_image"];
                NSString *name = clientInfoDict[@"client_name"];
                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
                UIImage *image = [UIImage imageWithData:imageData];
                [weakSelf updataView:name clientImage:image];
            } requestFail:^(id _Nonnull data) {
                
            }];
            
            [self.bleArrays addObject:peripheral];
            self.bleArrays = [[self.bleArrays valueForKeyPath:@"@distinctUnionOfObjects.self"] mutableCopy];
            [self.tableView reloadData];
        }
    }
}

/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"ble connect success...");
    self.currentPeripheral = peripheral;
    [self.currentPeripheral setDelegate:self];
    NSArray *uuids = @[[CBUUID UUIDWithString:kServiceUUID]];
    [self.currentPeripheral discoverServices:uuids];
    [self stopScan];
    [self.tableView reloadData];
}

/** 发现服务 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error)
    {
        NSLog(@"ble Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
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
        NSLog(@"ble Discovered Characteristics for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kReadCharacteristicUUID]]) {
            NSLog(@"蓝牙-发现读的特征");
            // 这里是读取Mac地址， 可不要， 数据固定， 用readValueForCharacteristic， 不用setNotifyValue:setNotifyValue
            self.readCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]]) {
            // 写的特征值
            NSLog(@"蓝牙-发现写的特征");
            self.writeCharacteristic = characteristic;
            //每5秒发送keep-alive
            [self keepAliveStart];
            [self stopScan];
        }else{
            [self keepAliveStop];
        }
        
    }
}

/**
 * 蓝牙连接后读特征
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"ble update characteristic fail:%@",error.userInfo);
        return ;
    }
    NSString *value=[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if (![value isEqualToString:@"(null)"] && value) {
        NSLog(@"ble name ：%@ | value : %@",peripheral.name,value);
        _deviceId = value;
        __weak typeof(self) weakSelf = self;
        [[IFLYOSSDK shareInstance] getDeviceCode:self.clientId deviceId:self.deviceId statusCode:^(NSInteger statusCode) {
            NSLog(@"ble deviceCode request status code : %li",statusCode);
        } requestSuccess:^(id _Nonnull data) {
            NSDictionary *resultDict = data;
            NSString *deviceCode = resultDict[@"device_code"];
            weakSelf.deviceCode = deviceCode;
            [weakSelf openLoginView];
        } requestFail:^(id _Nonnull data) {
            NSLog(@"ble deviceCode fail: %@",data);
        }];
    }
}

/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"ble connect fail:%@...",error.localizedDescription);
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"ble disconnect:%@...",error.localizedDescription);
    [self keepAliveStop];
}

-(void) keepAliveStart{
    if (self.isKeepAlive) {
        //正在检测，泽
        NSLog(@"ble keepAlive staring");
        return ;
    }
    self.isKeepAlive = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self.isKeepAlive) {
            //            NSLog(@"蓝牙-发送keep alive");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeData:[keep_alive dataUsingEncoding:NSUTF8StringEncoding]];
                //                [self writeData:[@"iflytek\niflytek!@#\n9c417cb54cd8" dataUsingEncoding:NSUTF8StringEncoding]];
            });
            [NSThread sleepForTimeInterval:keep_alive_time];
        }
        NSLog(@"ble keep alive over");
        [self keepAliveStop];
    });
}

-(void) keepAliveStop{
    self.isKeepAlive = NO;
}
#pragma ViewController代码

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.clientInfoView addSubview:self.clientImageView];
    [self.clientInfoView addSubview:self.clientName];
    [self.view addSubview:self.loadingView];
    //    [self.loadingView startAnimating];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bleArrays removeAllObjects];
    [self.tableView reloadData];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void) dealloc{
    [self disconnect];
}

#pragma tableView

-(void) updataView:(NSString *) name clientImage:(UIImage *) clientImage{
    if (name) {
        self.clientName.text = name;
    }
    if (clientImage) {
        [self.clientImageView setImage:clientImage];
    }
}

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

-(IBAction) scan:(id)sender{
    [self starScan];
    
}

-(IBAction) stopScan:(id)sender{
    [self stopScan];
}

-(void) openLoginView{
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
        NSLog(@"ble %@:%@:%@",namefield.text,passwordfiled.text,self.deviceCode);
        self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"蓝牙【%@】发送 = %@:%@:%@ \n",self.currentPeripheral.name,namefield.text,passwordfiled.text,self.deviceCode];
        if (self.deviceCode) {
            NSString *name = namefield.text;
            NSString *pwd = passwordfiled.text;
            NSString *bleData = [NSString stringWithFormat:@"id %@\npwd %@\ncode %@",name,pwd,self.deviceCode];
            [self writeData:[bleData dataUsingEncoding:NSUTF8StringEncoding]];
            [self.loadingView startAnimating];
            __weak typeof(self) weakSelf = self;
            [[IFLYOSSDK shareInstance] getBLEAuthrization:self.deviceCode statusCode:^(NSInteger statusCode) {
                NSLog(@"ble authrization request status code : %li",statusCode);
            } requestSuccess:^(id _Nonnull data) {
                NSLog(@"ble deviceCode success: %@",data);
                weakSelf.logTextView.text = [weakSelf.logTextView.text stringByAppendingFormat:@"蓝牙【%@】auth success... ^_^ \n",weakSelf.currentPeripheral.name];
                [weakSelf.loadingView stopAnimating];
            } requestFail:^(id _Nonnull data) {
                NSLog(@"ble deviceCode fail: %@",data);
                [UIView showAlert:@"提示" message:data target:self];
                weakSelf.logTextView.text = [weakSelf.logTextView.text stringByAppendingFormat:@"蓝牙【%@】auth fail... -^-\n",weakSelf.currentPeripheral.name];
                [weakSelf.loadingView stopAnimating];
            }];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"蓝牙【%@】关闭。。\n",self.currentPeripheral.name];
        [self disconnect];
    }]];
    
    [alertController.view addSubview:self.clientInfoView];
    [self presentViewController:alertController animated:YES completion:nil];
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
