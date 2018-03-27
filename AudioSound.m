//
//  AudioSound.m
//  Artimenring
//
//  Created by 振兴 刘 on 15/7/14.
//  Copyright (c) 2015年 BaH Cy. All rights reserved.
//

#import "AudioSound.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioSound()
{
    AVAudioPlayer* avLostPlayer;
    AVAudioPlayer* avDistancePlayer;
    AVAudioPlayer* avIMEIPlayer;
}
@end

@implementation AudioSound

#pragma mark- play
+ (AudioSound *)shardInstance
{
    static AudioSound *_staticAudioSound;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _staticAudioSound = [[AudioSound alloc] init];
    });
    return _staticAudioSound;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        avLostPlayer = nil;
        avDistancePlayer = nil;
        avIMEIPlayer = nil;
    }
    return self;
}

- (void)playVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playLostSound:(NSInteger)loops
{
    if (avLostPlayer && avLostPlayer.isPlaying)
        return;
    
    //从budle路径下读取音频文件　　轻音乐 - 萨克斯回家 这个文件名是你的歌曲名字,mp3是你的音频格式
    NSString *string = [[NSBundle mainBundle] pathForResource:@"alarm_beep" ofType:@"mp3"];
    
    avLostPlayer = [self playSoundExt:string isLoops:loops];
}

- (void)playDistanceSound
{
    if (avDistancePlayer && avDistancePlayer.isPlaying)
        return;
    
    //从budle路径下读取音频文件　　轻音乐 - 萨克斯回家 这个文件名是你的歌曲名字,mp3是你的音频格式
    NSString *string = [[NSBundle mainBundle] pathForResource:@"alarm_beep" ofType:@"mp3"];
    
    avDistancePlayer = [self playSoundExt:string isLoops:3];
}

- (void)playIMEISound
{
    if (avIMEIPlayer && avIMEIPlayer.isPlaying)
        return;
    
    //从budle路径下读取音频文件　　轻音乐 - 萨克斯回家 这个文件名是你的歌曲名字,mp3是你的音频格式
    NSString *string = [[NSBundle mainBundle] pathForResource:@"imei_scan_success" ofType:@"mp3"];
    
    avIMEIPlayer = [self playSoundExt:string isLoops:0];
}

- (AVAudioPlayer*)playSoundExt:(NSString*)path isLoops:(NSInteger)isLoops
{
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:path];
    //初始化音频类 并且添加播放文件
    AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //设置代理
    //avAudioPlayer.delegate = self;
    
    //设置初始音量大小
    avAudioPlayer.volume = 1;
    
    //设置音乐播放次数  -1为一直循环
    [avAudioPlayer setNumberOfLoops:isLoops];
    
    //预播放
    [avAudioPlayer prepareToPlay];
    [avAudioPlayer play];
    
    return avAudioPlayer;
}


#pragma mark- stop
- (void)stopLostSound
{
    if (avLostPlayer && avLostPlayer.isPlaying)
    {
        [avLostPlayer stop];
        avLostPlayer = nil;
    }
}

- (void)stopDistanceSound
{
    if (avDistancePlayer && avDistancePlayer.isPlaying)
    {
        [avDistancePlayer stop];
        avDistancePlayer = nil;
    }
}

- (void) dealloc
{
    ;
}

@end
