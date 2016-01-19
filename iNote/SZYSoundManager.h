//
//  SZYSoundManager.h
//  iNote
//
//  Created by sunxiaoyuan on 15/12/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "SZYAudioRouter.h"

@interface SZYSoundManager : NSObject

typedef void (^playProgressBlock)(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished);
typedef void (^recordProgressBlock)(NSString *elapsedTime, NSError *error);

//初始化
+(instancetype)sharedManager;

//设置音频会话
+(void)setAudioSession;

//播放本地文件
-(void)startPlayingLocalFileWithPath:(NSString *)path andBlock:(playProgressBlock)block;

//进度操作
-(void)pause;
-(void)resume;
-(void)stop;
-(void)restart;
-(void)moveToSecond:(int)second;
-(void)moveToSection:(CGFloat)section;
//设置操作
-(void)changeVolumeToValue:(CGFloat)volume;
-(void)changeSpeedToRate:(CGFloat)rate;


//录制音频文件
-(void)startRecordingAudioWithFilePath:(NSString *)path shouldStopAtSecond:(NSTimeInterval)second andBlock:(recordProgressBlock)block;

//进度操作
-(void)pauseRecording;
-(void)resumeRecording;
-(void)stopAndSaveRecording;
//删除录音文件
-(void)deleteRecording;
-(NSInteger)timeRecorded;

//检测耳机是否插入
-(BOOL)areHeadphonesConnected;
//切换声音通道
-(void)forceOutputToDefaultDevice;
-(void)forceOutputToBuiltInSpeakers;

-(CGFloat)updateMeters;

@end

@interface NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end

@interface NSTimer (Control)

-(void)pauseTimer;
-(void)resumeTimer;

@end
