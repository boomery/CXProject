//
//  SoundPlayer.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/23.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "SoundPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface SoundPlayer ()
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation SoundPlayer

static SoundPlayer *sharedPlayer = nil;
+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [self new];
    });
    return sharedPlayer;
}

+ (void)playMusicWithFileName:(NSString *)name
{
    sharedPlayer = [self sharedPlayer];
    NSString *string = @"0123456789";
    if ([string containsString:name])
    {
        /*
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"WAV"]];
        sharedPlayer.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        sharedPlayer.player.numberOfLoops = 0;
        sharedPlayer.player.volume = 0.8;
        [sharedPlayer.player play];
         */
        SystemSoundID soundID;
        //NSBundle来返回音频文件路径
        NSString *soundFile = [[NSBundle mainBundle] pathForResource:name ofType:@"WAV"];
        //建立SystemSoundID对象，但是这里要传地址(加&符号)。 第一个参数需要一个CFURLRef类型的url参数，要新建一个NSString来做桥接转换(bridge)，而这个NSString的值，就是上面的音频文件路径
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
        //播放提示音 带震动
        AudioServicesPlayAlertSound(soundID);
        //播放系统声音
        //    AudioServicesPlaySystemSound(soundID);
    }
}

@end
