//
//  BTLReceive.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/14.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BTLReceiveDelegate <NSObject>

@optional


//找到外设
- (void)didDiscover:(NSString*) watchName;

//已经连接上外设，但是没有连接Character
- (void)didConnectPeripheral:(NSString *)watchName;

//已经连接上Character
- (void)didConnectCharacter:(NSString *)watchName;

//连接Character中
- (void)connectingCharacter:(NSString *)watchName;

//连接外设失败
- (void)didFailToConnectPeripheral:(NSString *)watchName;

//连接服务特性失败
- (void)didFailToConnectCharacter:(NSString *)watchName;

//蓝牙断开
- (void)disconnect:(NSString *)watchName;

//连接状态，RSSI值，距离
- (void)connectState:(NSString *)watchName RSSI:(NSInteger)rssi distance:(NSInteger)distance;

//手表返回数据
- (void)receiveDatas:(NSData*)datas;

@end


@interface BTLReceive : NSObject

@property(strong, nonatomic) NSMutableArray* m_pReceiveDelegateArray;

- (void)initVariate;

//找到外设
- (void)didDiscover:(NSString*) watchName;

//已经连接上外设，但是没有连接Character
- (void)didConnectPeripheral:(NSString *)watchName;

//已经连接上Character
- (void)didConnectCharacter:(NSString *)watchName;

//连接Character中
- (void)connectingCharacter:(NSString *)watchName;

//连接外设失败
- (void)didFailToConnectPeripheral:(NSString *)watchName;

//连接服务特性失败
- (void)didFailToConnectCharacter:(NSString *)watchName;

//蓝牙断开
- (void)disconnect:(NSString *)watchName;

//连接状态，RSSI值，距离
- (void)connectState:(NSString *)watchName RSSI:(NSInteger)rssi distance:(NSInteger)distance;

//录音时，手表返回数据
- (void)receiveDatas:(NSData*)datas;

@end
