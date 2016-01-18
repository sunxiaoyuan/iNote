//
//  SZYAudioRouter.h
//  iNote
//
//  Created by sunxiaoyuan on 15/12/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SZYAudioRouter : NSObject<AVAudioPlayerDelegate>

//初始化AudioSession
+(void)initAudioSessionRouting;
//切换声音服务通道（耳机、扬声器等）
+(void)switchToDefaultHardware;
+(void)forceOutputToBuiltInSpeakers;

@end
