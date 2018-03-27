//
//  BTLDatas.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/16.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTLMacros.h"

@interface BTLDatas : NSObject


+ (NSData *)prepareRecordDataWithProtocol:(short)protocol a2itype:(Byte) a2itype times:(Byte)times relationship:(NSInteger)relationship mobile:(NSString *)mobile;

+ (NSData *)prepareDelRecordDataWithProtocol:(short)protocol a2itype:(Byte) a2itype mobile:(NSString*) mobile;

+ (NSDictionary*)parseRecordDatas:(NSData*)datas;

+ (NSDictionary*)parseCannelRecordDatas:(NSData*)datas;

+ (NSDictionary*)parseContactorDatas:(NSData*)datas;

+ (NSDictionary*)parseWatchLogDatas:(NSData*)datas;

@end
