#import "BTLServiceCharacter.h"
#import "BTLPeripheral.h"
#import "BTLManager.h"
#import "BTLMacros.h"
#import "BTLDelegate.h"


@interface BTLServiceCharacter ()
{
    NSTimer *m_pTimer;
}

@property (strong, nonatomic) BTLManagerOne *m_pBTLManagerOne;
@property (strong, nonatomic) BTLPeripheral *m_pBTLPeripheral;

@end



@implementation BTLServiceCharacter

- (void)initBtLManagerOne:(BTLManagerOne*)_BTLManagerOne
{
    self.m_pBTLManagerOne = _BTLManagerOne;
}

- (void)initBTLPeripheral:(BTLPeripheral*)_BTLPeripheral {
    
    self.m_pBTLPeripheral = _BTLPeripheral;
    self.m_pBTLPeripheral.m_pCBPeripheral.delegate = [[BTLManager shardInstance] getBTLProtocol];
}

- (void)initBTLProtocolDelegate {
    
    NSMutableArray* array = [[BTLManager shardInstance] getBTLProtocol].m_pPeripheraldelegateArray;
    [BTLDelegate addDelegate:array target:self];
}

- (void)removeBTLProtocolDelegate {
    
    NSMutableArray* array = [[BTLManager shardInstance] getBTLProtocol].m_pPeripheraldelegateArray;
    [BTLDelegate removeDelegate:array target:self];
}

- (void) initUUIDWithService:(NSString*) _service Characteristics:(NSString*) _characteristics {
    
    self.m_sService = _service;
    self.m_sCharacteristics = _characteristics;
}


#pragma mark - Callback
/** The Transfer Service was discovered
 */
- (void)didDiscoverServices:(CBPeripheral *)peripheral error:(NSError *)error;
{
    //外设不匹配
    if (![self checkIsOwnPeripheral:peripheral])
        return;
    
    if (error) {
        NSLog(@"BTL: Error discovering services: %@", [error localizedDescription]);

        [[[BTLManager shardInstance] getBTLReceive] didFailToConnectCharacter:[self.m_pBTLManagerOne getWatchName]];
        return;
    }
    
    if (peripheral.services.count <= 0) {
        NSLog(@"BTL: Error services个数为0");
        return;
    }
    
    NSLog(@"BTL: 找到服务列表: %@ ",peripheral.services);
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:self.m_sService]])
        {
            NSLog(@"BTL: 匹配到service，设备：%@, 服务：%@", peripheral, service);
            [peripheral discoverCharacteristics:nil forService:service];
            self.m_pService = service;
            return;
        }
    }
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)didDiscoverCharacteristicsForService:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error;
{
    //外设不匹配
    if (![self checkIsOwnPeripheral:peripheral])
        return;
    
    //服务不匹配
    if (self.m_pService != service) {
        return;
    }
    
    // Deal with errors (if any)
    if (error) {
        NSLog(@"BTL: Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    if (service.characteristics.count <= 0) {
        NSLog(@"BTL: Error characteristics个数为0");
        return;
    }
    
    NSLog(@"BTL: 找到特征列表: %@ ", service.characteristics);
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.m_sCharacteristics]]) {
            
            // If it is, subscribe to it 接受通知数据
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            self.m_pCharacteristic = characteristic;
            
            self.m_bIsConnect = YES;
            
#ifdef BTL_LOST_DISTANCE
            //防丢才读RSSI
            if (self.m_iType == E_SC_DISTANCE)
                [self loopReadRSSI];
#endif
            
            [[[BTLManager shardInstance] getBTLReceive] didConnectCharacter:[self.m_pBTLManagerOne getWatchName]];
            NSLog(@"=========== BTL:特性已经连上 ==========")
            
            return;
        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

- (void)didUpdateValueForCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //外设不匹配
    if (![self checkIsOwnPeripheral:peripheral])
        return;
    
    //特性不匹配
    if (self.m_pCharacteristic != characteristic) {
        return;
    }
    
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    // Log it
    NSLog(@"收到蓝牙返回数据！");
    [[[BTLManager shardInstance] getBTLReceive] receiveDatas:characteristic.value];
}



#pragma mark - Action
- (void)discoverServices {
    
    [self.m_pBTLPeripheral.m_pCBPeripheral discoverServices:nil];
    [[[BTLManager shardInstance] getBTLReceive] connectingCharacter:[self.m_pBTLManagerOne getWatchName]];
}

- (void) readRSSI
{
    //NSDate* now = [NSDate date];
    //NSLog(@"时间：%@", now);
    
    [self.m_pBTLPeripheral.m_pCBPeripheral readRSSI];
}

- (void) loopReadRSSI
{
    if (self.m_iType != E_SC_DISTANCE)
        return;
    
    if (self.m_bIsConnect == NO)
        return;
    
    [self removeTimer];
    [self addTimer];
}

- (void)didReadRSSI:(CBPeripheral *)peripheral rssi:(NSNumber *)RSSI error:(NSError *)error
{
    //外设不匹配
    if (![self checkIsOwnPeripheral:peripheral])
        return;
    
    NSInteger _rssi = abs([RSSI intValue]);
    NSInteger _distance = [self calculateDistance:_rssi];
    NSLog(@"BTL: RSSI:%ld, 距离: %ld", (long)_rssi, (long)_distance);
    [[[BTLManager shardInstance] getBTLReceive] connectState:[self.m_pBTLManagerOne getWatchName] RSSI:_rssi distance:_distance];
}

- (void)addTimer
{
    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:BTL_READ_RSSI_INTERVAL target:self selector:kSEL(readRSSI) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    if (m_pTimer != nil) {
        [m_pTimer invalidate];
        m_pTimer = nil;
    }
}

- (NSInteger)calculateDistance:(NSInteger)rssi
{
    if (rssi == 0) {
        return -1.0; // if we cannot determine accuracy, return -1.
    }
    
    double ratio = rssi*1.0/BTL_1METER_RSSI;
    if (ratio < 1.0) {
        return powl(ratio,10);
    }
    else {
        double accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
        return accuracy;
    }
}

#pragma mark - check
- (BOOL) checkIsOwnPeripheral:(CBPeripheral *)peripheral
{
    if([peripheral.name isEqualToString: [self.m_pBTLManagerOne getWatchName]])
        return YES;
    else
        return NO;
}


- (void)dealloc {
    ;
}

@end
