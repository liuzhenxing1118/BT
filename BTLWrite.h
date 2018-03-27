//
//  BTLWrite.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/10.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTLWrite : NSObject

+ (void)closeVoice:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic;

+ (void)openVoice:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic;

+ (void)writeRecord:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic datas:(NSData*)datas;

+ (void)writeWatchLog:(CBPeripheral*)_peripheral characteristic:(CBCharacteristic*)_characteristic protocol:(NSInteger)protocol;

@end
