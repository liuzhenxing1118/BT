//
//  BTLDelegate.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/22.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "BTLDelegate.h"

@implementation BTLDelegate

+ (void)addDelegate:(NSMutableArray*)array target:(id)target
{
    //已经存在，不添加
    if ([self isExist:array target:target])
        return;
    
    [array addObject:target];
    NSLog(@"BTL: addDelegate：总数：%lu",(unsigned long)array.count);
}

+ (void)removeDelegate:(NSMutableArray*)array target:(id)target
{
    [array removeObject:target];
    NSLog(@"BTL: removeDelegate：总数：%lu",(unsigned long)array.count);
}

+ (BOOL)isExist:(NSMutableArray*)array target:(id)target
{
    for (int i = 0; i < array.count; i++) {
        if (array[i] == target)
            return YES;
    }
    return NO;
}

@end
