#import "BTLPeripheral.h"
#import "BTLManager.h"
#import "BTLManagerOne.h"
#import "BTLCentralManager.h"
#import "BTLMacros.h"
#import "BTLDelegate.h"


@interface BTLPeripheral ()

@property (assign, nonatomic) BTLManagerOne *m_pManagerOne;

@end


@implementation BTLPeripheral

- (void)initBTLManagerOne:(BTLManagerOne*)_BTLManagerOne {
    
    self.m_pManagerOne = _BTLManagerOne;
}

- (void)initBTLProtocolDelegate {
    
    NSMutableArray* array = [[BTLManager shardInstance] getBTLProtocol].m_pCentraldelegateArray;
    [BTLDelegate addDelegate:array target:self];
}

- (void)removeBTLProtocolDelegate {
    
    NSMutableArray* array = [[BTLManager shardInstance] getBTLProtocol].m_pCentraldelegateArray;
    [BTLDelegate removeDelegate:array target:self];
}


- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (self.m_bIsConnect == YES && self.m_pCBPeripheral != nil)
        return;
    
    //外设不匹配
    if (![self checkIsOwn:peripheral])
        return;
    
    self.m_pCBPeripheral = peripheral;
    
    [[[BTLManager shardInstance] getBTLReceive] didDiscover:[self.m_pManagerOne getWatchName]];
    
    [[[BTLManager shardInstance] getBTLCentralManager] connect:peripheral];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)didConnectPeripheral:(CBPeripheral *)peripheral
{
    if(self.m_bIsConnect)
        return;
    
    //外设不匹配
    if (![self checkIsOwn:peripheral])
        return;
    
    self.m_bIsConnect = YES;
    
    [[[BTLManager shardInstance] getBTLReceive] didConnectPeripheral:[self.m_pManagerOne getWatchName]];
    
    //如果已经想要连接Character，尝试重连
    [self.m_pManagerOne reconnect];
    
    NSLog(@"=========== BTL:外设已经连上 =========== ");
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //外设不匹配
    if (![self checkIsOwn:peripheral])
        return;
    
    NSLog(@"BTL: 连接失败: 手表：%@, 错误：%@", self.m_pManagerOne.m_sWatchName, [error localizedDescription]);
    
    self.m_pCBPeripheral = nil;
    self.m_bIsConnect = NO;
    
    [[[BTLManager shardInstance] getBTLReceive] didFailToConnectPeripheral:[self.m_pManagerOne getWatchName]];
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //外设不匹配
    if (![self checkIsOwn:peripheral])
        return;
    
    NSLog(@"BTL: 与手表蓝牙断开: %@", self.m_pManagerOne.m_sWatchName);
    self.m_pCBPeripheral = nil;
    self.m_bIsConnect = NO;
    
    [[[BTLManager shardInstance] getBTLReceive] disconnect:[self.m_pManagerOne getWatchName]];
    
    //重新扫描，尝试连接
    [[[BTLManager shardInstance] getBTLScan] scan];
}

- (BOOL) checkIsOwn:(CBPeripheral *)peripheral
{
    NSLog(@"BTL: 搜索到外设：%@, 目标手表：%@", peripheral.name, [self.m_pManagerOne getWatchName]);
    if([peripheral.name isEqualToString: [self.m_pManagerOne getWatchName]])
        return YES;
    else
        return NO;
}

- (void)dealloc {
    ;
}



@end