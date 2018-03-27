//
//  AudioSound.h
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/14.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AudioSound : NSObject

+ (AudioSound *)shardInstance;

- (void)playVibrate;

- (void)playLostSound:(NSInteger)loops;

- (void)playDistanceSound;

- (void)playIMEISound;

- (void)stopLostSound;

- (void)stopDistanceSound;

@end
