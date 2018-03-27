//
//  BTLProtocol.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/10.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "BTLProtocol.h"
#import "BTLManager.h"

@implementation BTLProtocol

- (void) initVariate
{
    self.m_pCentraldelegateArray = NSMutableArray.new;
    self.m_pPeripheraldelegateArray = NSMutableArray.new;
    
    [self.m_pCentraldelegateArray removeAllObjects];
    [self.m_pPeripheraldelegateArray removeAllObjects];
}

#pragma mark - 当设备状态变化后,调用此方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            [[BTLManager shardInstance] setIsPoweredOn:YES];
            [[BTLManager shardInstance] checkWatch];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IPHONE_BT_OPEN" object:nil];
            break;
            
        case CBCentralManagerStatePoweredOff:
            [[BTLManager shardInstance] setIsPoweredOn:NO];
            [[BTLManager shardInstance] destory];
            [EUtil showToastWithTitle:NSLocalizedString(@"BT.Open.Please", nil)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IPHONE_BT_CLOSE" object:nil];
            break;
            
        case CBCentralManagerStateUnsupported: {
            
#ifndef TARGET_IPHONE_SIMULATOR
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"BT.No.Support", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Got.It", nil)
                                                  otherButtonTitles:nil];
            
            [alert show];
#endif
            [[BTLManager shardInstance] setIsSupportBT4:NO];
            break;
        }
        case CBCentralManagerStateResetting: {
            //need to reload
            break;
        }
        case CBCentralManagerStateUnauthorized:
            break;
            
        case CBCentralManagerStateUnknown:
            break;
            
        default:
            break;
    }
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    for (id<BTLCentralManagerDelegate> delegate in self.m_pCentraldelegateArray) {
        
        if(delegate && [delegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)])
        {
            [delegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    for (id<BTLCentralManagerDelegate> delegate in self.m_pCentraldelegateArray) {
        
        if(delegate && [delegate respondsToSelector:@selector(didFailToConnectPeripheral:error:)])
        {
            [delegate didFailToConnectPeripheral:peripheral error:error];
        }
    }
}

#pragma mark - 连接到外设
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    for (id<BTLCentralManagerDelegate> delegate in self.m_pCentraldelegateArray) {
        
        if(delegate && [delegate respondsToSelector:@selector(didConnectPeripheral:)])
        {
            [delegate didConnectPeripheral:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    for (id<BTLCentralManagerDelegate> delegate in self.m_pCentraldelegateArray) {
        
        if(delegate && [delegate respondsToSelector:@selector(didDisconnectPeripheral:error:)])
        {
            [delegate didDisconnectPeripheral:peripheral error:error];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (id<BTLPeripheralDelegate> delegate in self.m_pPeripheraldelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didDiscoverServices:error:)])
        {
            [delegate didDiscoverServices:peripheral error:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (id<BTLPeripheralDelegate> delegate in self.m_pPeripheraldelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didDiscoverCharacteristicsForService:service:error:)]) {
            [delegate didDiscoverCharacteristicsForService:peripheral service:service error:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    for (id<BTLPeripheralDelegate> delegate in self.m_pPeripheraldelegateArray) {
        if (delegate && [delegate respondsToSelector:@selector(didReadRSSI:rssi:error:)]) {
            [delegate didReadRSSI:peripheral rssi:RSSI error:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    for (id<BTLPeripheralDelegate> delegate in self.m_pPeripheraldelegateArray) {
        if (delegate && [delegate respondsToSelector:@selector(didUpdateValueForCharacteristic:characteristic:error:)]) {
            [delegate didUpdateValueForCharacteristic:peripheral characteristic:characteristic error:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    ;
}

- (void)cleanup
{
}

- (void)dealloc {
    ;
}


@end
