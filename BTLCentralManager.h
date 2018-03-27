//
//  BTLCentralManager.h
//  Artimenring
//
//  Created by BaH Cy on 4/13/15.
//  Copyright (c) 2015 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



@interface BTLCentralManager : NSObject

/** 中央设备 */
@property(strong, nonatomic) CBCentralManager *m_pCentralManager;


- (void)initCentralManager;

- (void)scan;

- (void)retrieveWatchesWithIdentifiers:(NSArray *)identifiers;

/** 停止扫描 */
- (void)stopScan;

-(void)connect:(CBPeripheral*) peripheral;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end
