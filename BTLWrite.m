//
//  BTLWrite.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/10.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
#import "BTLWrite.h"
#import "BTLMacros.h"


@implementation BTLWrite


+ (void)closeVoice:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic {
    
    Byte targetBytes[1];
    targetBytes[0] = 0;
    NSData *testData = [[NSData alloc] initWithBytes:targetBytes length:1];
    [_peripheral writeValue:testData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"BTL: 关闭断开响音")
}

+ (void)openVoice:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic {
    
    Byte targetBytes[1];
    targetBytes[0] = 2;
    NSData *testData = [[NSData alloc] initWithBytes:targetBytes length:1];
    [_peripheral writeValue:testData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"BTL: 开启断开响音")
}

+ (void)writeWatchLog:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic protocol:(NSInteger)protocol
{
    Byte targetBytes[2];
    targetBytes[0] = protocol & 0xff;
    targetBytes[1] = (protocol >> 8) & 0xff;
    NSData *testData = [[NSData alloc] initWithBytes:targetBytes length:2];
    [_peripheral writeValue:testData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
}

+ (void)writeRecord:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic datas:(NSData*)datas
{
    [_peripheral writeValue:datas forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"BTL: 写入录音相关数据")
}

@end
