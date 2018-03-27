//
//  BTLDelegate.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/22.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLDelegate : NSObject

+ (void)addDelegate:(NSMutableArray*)array target:(id)target;

+ (void)removeDelegate:(NSMutableArray*)array target:(id)target;

@end
