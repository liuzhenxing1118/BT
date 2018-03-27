//
//  BTLScan.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/16.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "BTLScan.h"
#import "BTLManager.h"

@interface BTLScan()
{
    NSTimer* m_pTimer;
    BOOL m_bIsScan;
    NSInteger m_iCount;
}
@end

@implementation BTLScan

#pragma mark- Scan

- (void)initVariate
{
    m_pTimer = nil;
    m_bIsScan = NO;
    m_iCount = 0;
}

- (void) scan
{
    NSMutableArray *uuidArray = [NSMutableArray.alloc init];
    for ( BTLManagerOne* manager in [[BTLManager shardInstance] getManagerOneArray] ) {
        NSString *watchName = [manager getWatchName];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* uuidString = [defaults objectForKey:watchName];
        if(uuidString != nil)
        {
            NSUUID *uuid = [NSUUID.alloc initWithUUIDString:uuidString];
            [uuidArray addObject:uuid];
        }
    }
    
    if(uuidArray.count > 0)
        ;//[[[BTLManager shardInstance] getBTLCentralManager] retrieveWatchesWithIdentifiers:uuidArray];
    
    [self check];
    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:kSEL(check) userInfo:nil repeats:YES];
}

- (void)stop
{
    [[[BTLManager shardInstance] getBTLCentralManager] stopScan];
    [m_pTimer invalidate];
    
    [self initVariate];
}

- (void)check
{
    ++m_iCount;
    
    if ([self isConnectAllWatch] == NO) {
        if (m_bIsScan == NO || m_iCount >= 100){
            [[[BTLManager shardInstance] getBTLCentralManager] scan];
            m_bIsScan = YES;
            m_iCount = 0;
        }
    }
    else {
        if (m_bIsScan == YES)
            [self stop];
    }
}

- (BOOL) isConnectAllWatch
{
    for ( BTLManagerOne* manager in [[BTLManager shardInstance] getManagerOneArray] ) {
        
        if ([[manager getBTLPeripheral] getIsConnect] == NO) {
            return NO;
        }
    }
    
    return YES;
}


@end
