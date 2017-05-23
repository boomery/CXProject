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
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"WAV"]];
        sharedPlayer.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        sharedPlayer.player.numberOfLoops = 0;
        sharedPlayer.player.volume = 0.8;
        [sharedPlayer.player play];
    }
}

@end
