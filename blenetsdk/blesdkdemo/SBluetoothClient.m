//
//  BluetoothClient.m
//  blesdkdemo
//
//  Created by tao luo on 2021/6/7.
//  Copyright © 2021 shen. All rights reserved.
//

#import "SBluetoothClient.h"

@interface SBluetoothClient()

//蓝牙中心设备管理器
@property(nonatomic,strong) CBCentralManager *mCBCentralManager;

@property(nonatomic,strong) onScanResult scanCallBack;
@property(nonatomic,strong) onConnectResult connectCallBack;
@property(nonatomic,strong) onWifiResult wifiCallBack;
@property(nonatomic,strong) onLinkResult linkCallBack;

@property(nonatomic,strong) NSMutableDictionary *map;

@property(nonatomic,strong) CBPeripheral *mCBPeripheral;

//读写特征
@property(nonatomic,strong) CBCharacteristic *mCBCharacteristic;

//返回的json数据
@property(nonatomic,strong)NSMutableData *buffer;

@end


@implementation SBluetoothClient

//Service
static CBUUID *WIFI_SERVICE_UUID;
//Characteristic
static CBUUID *WIFI_CHARACTERISTIC_UUID;
//Characteristic
static CBUUID *CLIENT_CONFIG_DESCRIPTOR_UUID;

+ (void)load{
    WIFI_SERVICE_UUID = [CBUUID UUIDWithString:@"0000180A-0000-1000-8000-00805F9B34FB"];
    WIFI_CHARACTERISTIC_UUID = [CBUUID UUIDWithString:@"00009999-0000-1000-8000-00805F9B34FB"];
    CLIENT_CONFIG_DESCRIPTOR_UUID = [CBUUID UUIDWithString:@"00002902-0000-1000-8000-00805f9b34fb"];
}

static SBluetoothClient *sharedSingleton = nil;

+ (SBluetoothClient *)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

//初始化SDK
- (void)initSDK{
    if(self.mCBCentralManager)
        return;
    self.mCBCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.map = NSMutableDictionary.new;
}

#pragma mark --CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    NSLog(@"centralManagerDidUpdateState:%ld",central.state);
    switch (central.state){
        case CBManagerStatePoweredOn:
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(self.scanCallBack && peripheral.name && ![peripheral.name isEqualToString:@""]){
        LeDevice *device = LeDevice.new;
        device.leName = peripheral.name;
        device.identifier = [NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString];
        self.scanCallBack(device);
        [self.map setObject:peripheral forKey:device.leName];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
//    NSLog(@"didConnectPeripheral:%@",peripheral);
    //只测试一个连接
    self.mCBPeripheral = peripheral;
    [self.mCBPeripheral setDelegate:self];
    [self.mCBPeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@"didFailToConnectPeripheral:%@",peripheral);
    //只测试一个连接
    self.mCBPeripheral = nil;
    [self connetStateCallBack:-1];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@"didDisconnectPeripheral:%@",peripheral);
    //只测试一个连接
    self.mCBPeripheral = nil;
    self.wifiCallBack = nil;
    self.linkCallBack = nil;
}

#pragma mark --CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error){
        NSLog(@"didDiscoverServices error:%@", [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services){
        if([service.UUID isEqual:WIFI_SERVICE_UUID]){
//            NSLog(@"Find Service!");
            [peripheral discoverCharacteristics:nil forService:service];
            return;
        }
    }
    [self connetStateCallBack:1];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        NSLog(@"didDiscoverCharacteristicsForService error:%@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics){
        if([characteristic.UUID isEqual:WIFI_CHARACTERISTIC_UUID]){
//            NSLog(@"Find Characteristic!");
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            return;
        }
    }
    [self connetStateCallBack:2];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"didUpdateNotificationStateForCharacteristic error:%@", [error localizedDescription]);
        return;
    }
    if([characteristic.UUID isEqual:WIFI_CHARACTERISTIC_UUID]){
        self.mCBCharacteristic = characteristic;
        [self connetStateCallBack:0];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        NSLog(@"didUpdateValueForCharacteristic error:%@", [error localizedDescription]);
        return;
    }
    Byte *bytePtr = (Byte *)[characteristic.value bytes];
    if([characteristic.value length] == 1){
        if(self.linkCallBack){
            if(bytePtr[0] == 0x01){
                self.linkCallBack(0);
            }else{
                self.linkCallBack(1);
            }
            self.linkCallBack = nil;
        }
        return;
    }
    if(bytePtr[0] == 0x01 && bytePtr[characteristic.value.length - 1] == 0x04){
        return;
    }
    if(!self.buffer){
        self.buffer = NSMutableData.new;
    }
    [self.buffer appendData:characteristic.value];
    NSError *parseErr;
    id dicts = [NSJSONSerialization JSONObjectWithData:self.buffer options:kNilOptions error:&parseErr];
    if(!parseErr){
        //        NSString *jsonStr = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
        //        NSLog(@"JSON:%@",jsonStr);
        NSMutableArray *wifiInfos = NSMutableArray.new;
        NSArray *predicateArr = dicts[@"ret"];
        predicateArr = [predicateArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    NSString *wifiName = evaluatedObject[@"ssid"];
                    return wifiName != nil && ![wifiName isEqualToString:@""];
        }]];
        for(NSDictionary *dict in predicateArr){
            WifiInfo *wifiInfo = WifiInfo.new;
            [wifiInfo setValuesForKeysWithDictionary:dict];
            [wifiInfos addObject:wifiInfo];
        }
        if(self.wifiCallBack){
            self.wifiCallBack(wifiInfos);
            self.wifiCallBack = nil;
        }
        self.buffer = nil;
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@"didWriteValueForCharacteristic:%@", characteristic);
}

-(void)connetTimeout{
    [self connetStateCallBack:-3];
}

-(void)connetStateCallBack:(NSInteger) state{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connetTimeout) object:nil];
    if(self.connectCallBack){
        self.connectCallBack(state);
        self.connectCallBack = nil;
    }
}


#pragma mark --open function
//开始扫描
- (void) startScan:(onScanResult)callback{
    [self stopScan];
//    NSLog(@"startScan");
    [self.map removeAllObjects];
    if(self.mCBCentralManager.state != CBManagerStatePoweredOn){
        NSLog(@"请确认是否打开蓝牙权限，或重启demo测试！");
        return;
    }
    self.scanCallBack = callback;
//    [self.mCBCentralManager scanForPeripheralsWithServices:@[WIFI_SERVICE_UUID] options:nil];
    [self.mCBCentralManager scanForPeripheralsWithServices:nil options:nil];
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:10];
}

//停止扫描
- (void) stopScan{
//    NSLog(@"stopScan");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScan) object:nil];
    if(self.mCBCentralManager.state != CBManagerStatePoweredOn){
        return;
    }
    [self.mCBCentralManager stopScan];
    self.scanCallBack = nil;
    self.connectCallBack = nil;
}

//开始连接
-(void) connect:(LeDevice *) device connectResult:(onConnectResult) callback{
    if(self.mCBPeripheral){
        NSLog(@"HAS CBPeripheral!");
        return;
    }
    self.mCBPeripheral = self.map[device.leName];
    NSLog(@"connect:%@",self.mCBPeripheral.name);
    [self stopScan];
    if(self.mCBPeripheral){
        self.connectCallBack = callback;
        [self.mCBCentralManager connectPeripheral:self.mCBPeripheral options:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connetTimeout) object:nil];
        [self performSelector:@selector(connetTimeout) withObject:nil afterDelay:10];
    }
}

//获取可用的WIFI列表
-(void) getWifiList:(onWifiResult) callback{
    if(!self.mCBPeripheral){
        NSLog(@"HAS NOT CBPeripheral!");
        return;
    }
    if(!self.mCBCharacteristic){
        NSLog(@"HAS NOT CBCharacteristic!");
        return;
    }
    self.wifiCallBack = callback;
    Byte data[14] = {0};
    data[0] = 0x01;
    data[13] = 0x04;
    NSString *str = @"wifilists";
    for(int i=0; i<str.length; i++){
        Byte ch = [str characterAtIndex: i];
        data[i + 1] = ch;
    }
    NSData *toData = [NSData dataWithBytes:data length:sizeof(data)];
    [self.mCBPeripheral writeValue:toData forCharacteristic:self.mCBCharacteristic type:CBCharacteristicWriteWithResponse];
}

//开始配网
-(void) link:(WifiInfo *) wifiInfo password:(NSString*)pwd linkResult:(onLinkResult) callback{
    if(!self.mCBPeripheral){
        NSLog(@"HAS NOT CBPeripheral!");
        return;
    }
    if(!self.mCBCharacteristic){
        NSLog(@"HAS NOT CBCharacteristic!");
        return;
    }
    self.linkCallBack = callback;
    Byte data[79] = {0};
    data[0] = 0x01;
    data[77] = [wifiInfo getEncryption];
    data[78] = 0x04;


   
    NSString *str = @"wifisetup";
    for(int i=0; i<str.length; i++){
        Byte ch = [str characterAtIndex: i];
        data[1 + i] = ch;
    }
    //临时处理字节，默认当成ASCII处理，实际情况请自行处理。
    str = wifiInfo.ssid;
    for(int i=0; i<str.length; i++){
        Byte ch = [str characterAtIndex: i];
        data[13 + i] = ch;
    }
    //临时处理字节，默认当成ASCII处理，实际情况请自行处理。
    str = pwd;
    for(int i=0; i<str.length; i++){
        Byte ch = [str characterAtIndex: i];
        data[45 + i] = ch;
    }
    NSData *toData = [NSData dataWithBytes:data length:sizeof(data)];
    [self.mCBPeripheral writeValue:toData forCharacteristic:self.mCBCharacteristic type:CBCharacteristicWriteWithResponse];
}

//关闭连接
-(void) close{
    if(!self.mCBPeripheral){
        NSLog(@"HAS NOT CBPeripheral!");
        return;
    }
    [self.mCBCentralManager cancelPeripheralConnection:self.mCBPeripheral];
}

-(NSString*) ssid{
    return self.mCBPeripheral ? self.mCBPeripheral.name : @"Unknown";
}

@end
