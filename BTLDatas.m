//
//  BTLDatas.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/16.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "BTLDatas.h"
#import "BTLMacros.h"

@implementation BTLDatas

#pragma mark - prepare
+ (NSData *)prepareRecordDataWithProtocol:(short)protocol a2itype:(Byte) a2itype times:(Byte)times relationship:(NSInteger)relationship mobile:(NSString *)mobile {
    if (![mobile isValidateMobile]) {
        return nil;
    }
    
    short len;
    Byte mobileArray[32] = {0};
    
    if (mobile != nil) {
        NSData *mobileData = [mobile dataUsingEncoding: NSASCIIStringEncoding];
        Byte *mobileBytes = (Byte *)[mobileData bytes];
        len = [mobileData length] + 5;//从第四位开始的长度
        for(int i = 0;i < [mobileData length];i++) {
            mobileArray[i] = mobileBytes[i];
        }
    } else {
        len = 0;
    }
    
    int dataSize = 40;
    Byte targetBytes[dataSize];
    for (int i = 0; i < dataSize; i++) {
        targetBytes[i] = 0;
    }
    targetBytes[0] = protocol & 0xff;
    targetBytes[1] = (protocol >> 8) & 0xff;
    
    targetBytes[2] = len & 0xff;
    targetBytes[3] = (len >> 8) & 0xff;
    
    targetBytes[4] = a2itype;
    //5 6 - reserved
    
    targetBytes[7] = times;
    targetBytes[8] = (Byte)relationship;
    
    if (len > 0) {
        for (int i = 0; i < 32; i++) {
            targetBytes[9 + i] = mobileArray[i];
        }
    }
    
    return [[NSMutableData alloc] initWithBytes:targetBytes length:dataSize];
}

+ (NSData *)prepareDelRecordDataWithProtocol:(short)protocol a2itype:(Byte) a2itype mobile:(NSString*) mobile
{
    if (![mobile isValidateMobile]) {
        return nil;
    }
    
    short len;
    Byte mobileArray[32];
    
    if (mobile != nil) {
        NSData *mobileData = [mobile dataUsingEncoding: NSASCIIStringEncoding];
        Byte *mobileBytes = (Byte *)[mobileData bytes];
        len = [mobileData length] + 3;//从第四位开始的长度
        for(int i = 0;i < [mobileData length];i++) {
            mobileArray[i] = mobileBytes[i];
        }
    } else {
        len = 0;
    }
    
    int dataSize = 38;
    Byte targetBytes[dataSize];
    for (int i = 0; i < dataSize; i++) {
        targetBytes[i] = 0;
    }
    targetBytes[0] = protocol & 0xff;
    targetBytes[1] = (protocol >> 8) & 0xff;
    
    targetBytes[2] = len & 0xff;
    targetBytes[3] = (len >> 8) & 0xff;
    
    targetBytes[4] = a2itype;
    
    //5 6 - reserved
    
    if (len > 0) {
        for (int i = 0; i < 32; i++) {
            targetBytes[7 + i] = mobileArray[i];
        }
    }
    
    return [[NSMutableData alloc] initWithBytes:targetBytes length:dataSize];
}


#pragma mark - parse
+ (NSDictionary*)parseRecordDatas:(NSData*)datas
{
    NSDictionary* dic;
    
    //NSString *str = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
    //NSData* encodeDatas = [str dataUsingEncoding: NSASCIIStringEncoding];
    Byte *bytes = (Byte *)[datas bytes];
    if (bytes == nil) {
        NSLog(@"返回数据解析为空")
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int type = 0;
    type = bytes[0] & 0xff;
    type |= (bytes[1]<<8) & 0xff00;
    type = (short)type;
    
    if (type != 103)
    {
        NSLog(@"蓝牙返回数据协议号不对:@%d", type)
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int len = 0;
    len = bytes[2] & 0xff;
    len |= (bytes[3]<<8) & 0xff00;
    len = (short)len;
    
    a2i_handle_type a2itype = (a2i_handle_type)(bytes[4] & 0xff); //当前录音的状态 1-training 2-取消录音 3-删除 4-录音失败
    int status = bytes[5] & 0xff;
    status = (Byte)status;

    
    if(a2itype == A2I_HANDLE_TRAINING)
    {
        int enrollmentID = bytes[8] & 0xff;
        enrollmentID = (Byte)enrollmentID;
        
        int times = bytes[9] & 0xff;
        times = (Byte)times;
        
        NSLog(@"返回数据1：%d,%d,%d,%d,%d",type, len, a2itype, status, times);
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:1], @"isOk",
               [NSNumber numberWithInt:a2itype], @"a2itype",
               [NSNumber numberWithInt:status], @"status",
               [NSNumber numberWithInt:times], @"times",
               [NSNumber numberWithInt:0], @"reasonId",
               [NSNumber numberWithInt:enrollmentID], @"enrollmentID", nil];
    }
    else if(a2itype == A2I_HANDLE_TRAINING_FAILED)
    {
        int reasonId = bytes[8] & 0xff;
        reasonId = (short)reasonId;
        int times = bytes[9] & 0xff;
        times = (Byte)times;
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:1], @"isOk",
               [NSNumber numberWithInt:a2itype], @"a2itype",
               [NSNumber numberWithInt:status], @"status",
               [NSNumber numberWithInt:times], @"times",
               [NSNumber numberWithInt:reasonId], @"reasonId",
               [NSNumber numberWithInt:0], @"_voice", nil];
    }
    else if(a2itype == A2I_HANDLE_TRAINING_CANCEL)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:1], @"isOk",
               [NSNumber numberWithInt:status], @"status",
               [NSNumber numberWithInt:a2itype], @"a2itype", nil];
    }
    else {
        assert(0);
    }
    
    return dic;
}

+ (NSDictionary*)parseCannelRecordDatas:(NSData*)datas
{
    NSDictionary* dic;
    
    //NSString *str = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
    //NSData* encodeDatas = [str dataUsingEncoding: NSASCIIStringEncoding];
    Byte *bytes = (Byte *)[datas bytes];
    if (bytes == nil) {
        NSLog(@"返回数据解析为空")
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int type = 0;
    type = bytes[0] & 0xff;
    type |= (bytes[1]<<8) & 0xff00;
    type = (short)type;
    
    
    if (type != 103)
    {
        NSLog(@"蓝牙返回数据协议号不对:@%d", type)
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int len = 0;
    len = bytes[2] & 0xff;
    len |= (bytes[3]<<8) & 0xff00;
    len = (short)len;
    
    a2i_handle_type a2itype = (a2i_handle_type)(bytes[4] & 0xff); //当前录音的状态 1-training 3-删除
    
    int status = bytes[5] & 0xff;
    status = (Byte)status;
    
    int reasonId = bytes[8] & 0xff;
    reasonId = (short)reasonId;
    
    NSLog(@"返回数据1：%d,%d,%d,%d",type, len, a2itype, status);
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithInt:1], @"isOk",
           [NSNumber numberWithInt:a2itype], @"a2itype",
           [NSNumber numberWithInt:status], @"status",
           [NSNumber numberWithInt:reasonId], @"reasonId",nil];
    
    return dic;
}

+ (NSDictionary*)parseContactorDatas:(NSData*)datas
{
    NSDictionary* dic;
    
    //NSString *str = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
    //NSData* encodeDatas = [str dataUsingEncoding: NSASCIIStringEncoding];
    Byte *bytes = (Byte *)[datas bytes];
    if (bytes == nil) {
        NSLog(@"返回数据解析为空")
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int type = 0;
    type = bytes[0] & 0xff;
    type |= (bytes[1]<<8) & 0xff00;
    type = (short)type;
    
    
    if (type != 104)
    {
        NSLog(@"蓝牙返回数据协议号不对:@%d", type)
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int len = 0;
    len = bytes[2] & 0xff;
    len |= (bytes[3]<<8) & 0xff00;
    len = (short)len;
    
    //4,5 reserved
    int voice_num = 0;
    voice_num = bytes[6] & 0xff;
    NSMutableArray *contactorArray = [NSMutableArray.alloc init];
    
    int voice_idx = 0;
    int dataIdx = 7;
    while(voice_idx < voice_num)
    {
        int contactLen = bytes[dataIdx] & 0xff;
        int enrollmentId = bytes[dataIdx + 1] & 0xff;
        int memberIdx = bytes[dataIdx + 2] & 0xff;
        
        int phoneLen = contactLen - 5;
        char number[32] = {0};
        for(int idx = 0; idx < phoneLen; ++idx)
        {
            number[idx] = bytes[dataIdx + 5 + idx];
        }
        NSString *phoneStr = [NSString stringWithCString:number encoding:NSUTF8StringEncoding];
        
        NSDictionary *contactor = [NSDictionary dictionaryWithObjectsAndKeys:
               [[NSNumber numberWithInt:enrollmentId] stringValue], @"enrollmentId",
               [[NSNumber numberWithInt:memberIdx] stringValue], @"memberIdx",
               phoneStr, @"phone",nil];
        
        [contactorArray addObject:contactor];
        voice_idx++;
        dataIdx += contactLen;
    }
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithInt:1], @"isOk",
           [NSNumber numberWithInt:type], @"type",
           contactorArray, @"contactors",nil];
    
    return dic;
}

+ (NSDictionary*)parseWatchLogDatas:(NSData*)datas
{
    NSDictionary* dic = [NSDictionary new];
    
    Byte *bytes = (Byte *)[datas bytes];
    if (bytes == nil) {
        NSLog(@"返回数据解析为空")
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    int type = 0;
    type = bytes[0] & 0xff;
    type |= (bytes[1]<<8) & 0xff00;
    type = (short)type;
    
    
    if (type == 613)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:0], @"isOk", nil];
        return dic;
    }
    
    //int le = strlen(bytes);

    

    char imeiArray[16] = {0};
    for (int i = 1; i <=15; i++) {
        imeiArray[i-1] = bytes[i];
    }
    
    NSString* imei = [NSString stringWithUTF8String:imeiArray];


    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithInt:1], @"isOk",
           imei, @"imei",
                         nil];
    
    return dic;
}

//    int findchar(char ch,char str[],int n)
//    {
//        int i=0;
//        while(str[i]!=ch&&i<n)
//            i++;
//        if(i==n) i=-1;
//        return i;
//    }

@end
