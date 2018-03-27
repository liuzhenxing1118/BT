//
//  BTLProtocol.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/10.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTLCentralManagerDelegate <NSObject>

@optional


- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

- (void)findPeripheralTimeout;

- (void)didConnectPeripheral:(CBPeripheral *)peripheral;

- (void)didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@end


@protocol BTLPeripheralDelegate <NSObject>

@optional

- (void)didDiscoverServices:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)didDiscoverCharacteristicsForService:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error;

- (void)didUpdateValueForCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error;


- (void)didReadRSSI:(CBPeripheral *)peripheral rssi:(NSNumber *)RSSI error:(NSError *)error;

@end



@interface BTLProtocol : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property(strong, nonatomic) NSMutableArray* m_pCentraldelegateArray;

@property(strong, nonatomic) NSMutableArray* m_pPeripheraldelegateArray;

- (void)initVariate;

@end
