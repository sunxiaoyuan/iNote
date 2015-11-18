//
//  SZYPlayerViewController.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SZYPlayerViewController ()<AVAudioPlayerDelegate>

- (IBAction)startAction:(id)sender;
- (IBAction)stopAction:(id)sender;
- (IBAction)backAction:(id)sender;

@property (weak, nonatomic ) IBOutlet UIProgressView *playProgress;
@property (weak ,nonatomic ) NSTimer        *timer;//进度更新定时器
@property (nonatomic,strong) AVAudioPlayer  *audioPlayer;//播放器

@end

@implementation SZYPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

#pragma mark - 播放器代理方法

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放完成，自动跳回
    
}

#pragma mark - 响应方法

//播放
- (IBAction)startAction:(id)sender {
    
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast];//恢复定时器
    }
}

//暂停
- (IBAction)stopAction:(id)sender {
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate = [NSDate distantFuture];
        //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    }
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//更新播放进度
-(void)updateProgress{
    float progress = self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playProgress setProgress:progress animated:true];
}

#pragma mark - getters

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer){
        NSURL *url = [NSURL fileURLWithPath:self.videoPath];
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0;//设置为0不循环
        _audioPlayer.volume = 1.0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}


@end
