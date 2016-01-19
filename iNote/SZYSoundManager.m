//
//  SZYSoundManager.m
//  iNote
//
//  Created by sunxiaoyuan on 15/12/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSoundManager.h"

#define kTimerUpdateFrequency 0.1

@interface SZYSoundManager ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioPlayer   *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer         *playTimer;
@property (nonatomic, strong) NSTimer         *recordTimer;

@end

@implementation SZYSoundManager

+(instancetype)sharedManager {
    
    static SZYSoundManager *soundManager = nil;
    
    //用于检查该代码块是否已经被调度的谓词（是一个长整型，实际上作为BOOL使用）
    static dispatch_once_t onceToken;
    
    //dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    dispatch_once(&onceToken, ^{
        soundManager = [[self alloc]init];
    });
    return soundManager;
}

+(void)setAudioSession{
    
    [SZYAudioRouter initAudioSessionRouting];
}

#pragma mark 播放功能

-(void)startPlayingLocalFileWithPath:(NSString *)path andBlock:(playProgressBlock)block {

    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    //创建播放器
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    //开始播放
    [_audioPlayer play];
    //当前播放进度
    __block int percentage = 0;//这里用__block修饰变量，才能在block中修改变量的值
    
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerUpdateFrequency block:^{
        
        if (percentage != 99) { //这里设置99时因为在100秒的瞬间currentTime会失去值，导致计时器进入死循环
            
            percentage = (int)((_audioPlayer.currentTime * 100)/_audioPlayer.duration);
            int timeRemaining = _audioPlayer.duration - _audioPlayer.currentTime;
            block(percentage, _audioPlayer.currentTime, timeRemaining, error, NO);
            
        } else {
            
            int timeRemaining = _audioPlayer.duration - _audioPlayer.currentTime;
            block(100, _audioPlayer.currentTime, timeRemaining, error, YES);
            //暂停定时器
            [_playTimer pauseTimer];
        }
    } repeats:YES];
}

-(void)pause {
    [_audioPlayer pause];
    [_playTimer pauseTimer];
}

-(void)resume {
    [_audioPlayer play];
    [_playTimer resumeTimer];
}

-(void)stop {
    [_audioPlayer stop];
    [_playTimer invalidate];
    _playTimer = nil;
}

-(void)restart {
    [_audioPlayer setCurrentTime:0];
}

-(void)moveToSecond:(int)second {
    [_audioPlayer setCurrentTime:second];
}

-(void)moveToSection:(CGFloat)section {
    int audioPlayerSection = _audioPlayer.duration * section;
    [_audioPlayer setCurrentTime:audioPlayerSection];
}

-(void)changeSpeedToRate:(CGFloat)rate {
    _audioPlayer.rate = rate;
}

-(void)changeVolumeToValue:(CGFloat)volume {
    _audioPlayer.volume = volume;
}

#pragma mark  录音功能

-(void)startRecordingAudioWithFilePath:(NSString *)path shouldStopAtSecond:(NSTimeInterval)second andBlock:(recordProgressBlock)block{
    
    NSError *error = nil;
    NSURL *audioURL = [NSURL URLWithString:path];
    NSDictionary *audioSetting = [self getAudioSetting];
    if (!_recorder) {
        _recorder = [[AVAudioRecorder alloc]initWithURL:audioURL settings:audioSetting error:&error];
        _recorder.meteringEnabled = YES;
    }
    if (second == 0 && !second) {
        [_recorder record];
    } else {
        //录制指定时间
        [_recorder recordForDuration:second];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"mm:ss";
    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerUpdateFrequency block:^{

        NSDate *recordedTimeDate = [NSDate dateWithTimeIntervalSince1970:[self timeRecorded]];
        NSString *eclipsedTime = [formatter stringFromDate:recordedTimeDate];
        block(eclipsedTime,error);

    } repeats:YES];
}

//录音文件设置
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //录音被终止时，清除计时器
    [_recordTimer invalidate];
    _recordTimer = nil;
}

-(void)pauseRecording {
    if ([_recorder isRecording]) {
        [_recorder pause];
        [_recordTimer pauseTimer];
    }
}

-(void)resumeRecording {
    if (![_recorder isRecording]) {
        [_recorder record];
        [_recordTimer resumeTimer];
    }
}

-(void)stopAndSaveRecording {
    [_recorder stop];
}

-(void)deleteRecording {
    //必须先保证保证录音机是暂停的
    [self pauseRecording];
    [_recorder deleteRecording];
}

-(NSInteger)timeRecorded {
    return [_recorder currentTime];
}

-(BOOL)areHeadphonesConnected {
    
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance]currentRoute];
    BOOL headphonesLocated = NO;
    for (AVAudioSessionPortDescription *portDescription in route.outputs) {
        headphonesLocated |= ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]);
    }
    return headphonesLocated;
}

-(void)forceOutputToDefaultDevice {
    
    [SZYAudioRouter initAudioSessionRouting];
    [SZYAudioRouter switchToDefaultHardware];
}

-(void)forceOutputToBuiltInSpeakers {
    
    [SZYAudioRouter initAudioSessionRouting];
    [SZYAudioRouter forceOutputToBuiltInSpeakers];
}

-(CGFloat)updateMeters{
    
    [self.recorder updateMeters];
    return pow (10, [self.recorder averagePowerForChannel:0] / 20);
}

@end


@implementation NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(executeBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)executeBlock:(NSTimer *)inTimer {
    
    if ([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end

@implementation NSTimer (Control)

//暂停时间
static NSString * const pauseDate = @"NSTimerPauseDate";
//启动时间
static NSString * const previousFireDate = @"NSTimerPreviousFireDate";

-(void)pauseTimer {
    
    //setters
    //将函数执行时的时间绑定给实例变量－pauseDate
    objc_setAssociatedObject(self, (__bridge const void *)(pauseDate), [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //将启动时间绑定给实例变量－previousFireDate
    objc_setAssociatedObject(self, (__bridge const void *)(previousFireDate), self.fireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //暂停计时器
    self.fireDate = [NSDate distantFuture];
}

-(void)resumeTimer {
    //getters
    NSDate *pauseDateTime = objc_getAssociatedObject(self, (__bridge const void *)pauseDate);
    NSDate *previousFireDateTime = objc_getAssociatedObject(self, (__bridge const void *)previousFireDate);
    //上次暂停时距今的时间间隔
    const NSTimeInterval pauseTime = -[pauseDateTime timeIntervalSinceNow];
    //启动定时器
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDateTime];
}


@end
