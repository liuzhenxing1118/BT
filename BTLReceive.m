//
//  BTLReceive.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/14.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "BTLReceive.h"

@implementation BTLReceive

- (void) initVariate
{
    self.m_pReceiveDelegateArray = NSMutableArray.new;
    [self.m_pReceiveDelegateArray removeAllObjects];
}

- (void)didDiscover:(NSString*) watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didDiscover:)])
        {
            [delegate didDiscover:watchName];
        }
    }
}

- (void)didConnectPeripheral:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didConnectPeripheral:)])
        {
            [delegate didConnectPeripheral:watchName];
        }
    }
}

- (void)didConnectCharacter:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didConnectCharacter:)])
        {
            [delegate didConnectCharacter:watchName];
        }
    }
}

//连接Character中
- (void)connectingCharacter:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(connectingCharacter:)])
        {
            [delegate connectingCharacter:watchName];
        }
    }
}

- (void)didFailToConnectPeripheral:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didFailToConnectPeripheral:)])
        {
            [delegate didFailToConnectPeripheral:watchName];
        }
    }
}

- (void)didFailToConnectCharacter:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(didFailToConnectCharacter:)])
        {
            [delegate didFailToConnectCharacter:watchName];
        }
    }
}

//蓝牙断开
- (void)disconnect:(NSString *)watchName
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(disconnect:)])
        {
            [delegate disconnect:watchName];
        }
    }
}

- (void)connectState:(NSString *)watchName RSSI:(NSInteger)rssi distance:(NSInteger)distance
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(connectState:RSSI:distance:)])
        {
            [delegate connectState:watchName RSSI:rssi distance:distance];
        }
    }
}

- (void)receiveDatas:(NSData*)datas
{
    for (id<BTLReceiveDelegate> delegate in self.m_pReceiveDelegateArray) {
        
        if (delegate && [delegate respondsToSelector:@selector(receiveDatas:)])
        {
            [delegate receiveDatas:datas];
        }
    }
}


@end
