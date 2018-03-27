//
//  BTLCentralManager.m
//  Artimenring
//
//  Created by BaH Cy on 4/13/15.
//  Copyright (c) 2015 BaH Cy. All rights reserved.
//

#import "BTLCentralManager.h"
#import "BTLManager.h"

@interface BTLCentralManager()
@end

@implementation BTLCentralManager


- (void)initCentralManager {

    self.m_pCentralManager = [[CBCentralManager alloc] initWithDelegate:[[BTLManager shardInstance] getBTLProtocol] queue:nil];
}

- (void)scan {
    [self.m_pCentralManager scanForPeripheralsWithServices:nil
                                                   options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void)retrieveWatchesWithIdentifiers:(NSArray *)identifiers {
    NSArray *watches = [self.m_pCentralManager retrievePeripheralsWithIdentifiers:identifiers];
    for(CBPeripheral *watch in watches)
    {
        BTLManagerOne *managerOne = [[BTLManager shardInstance] ManagerOneByWatchName:watch.name];
        if(managerOne)
        {
            [managerOne connect:watch];
        }
    }
}

- (void)stopScan
{
    [self.m_pCentralManager stopScan];
}


-(void) connect:(CBPeripheral*) peripheral
{
    [self.m_pCentralManager connectPeripheral:peripheral
                                      options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    
    [self.m_pCentralManager cancelPeripheralConnection:peripheral];
}

- (void)dealloc {
    ;
}

@end
