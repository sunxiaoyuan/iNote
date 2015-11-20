//
//  SZYRecorderViewController.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SZYNoteModel.h"

@interface SZYRecorderViewController ()

//上下底层视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstrsint;
//开始－暂停按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordBtnHeightConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordBtnWidthConstrsint;
//播放按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnHeightConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnWidthConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnLeftConstrsint;
//完成按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnHeightConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnWidthConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnRightConstrsint;
//时间面板
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidthConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeightConstrsint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelTopConstrsint;

- (IBAction)doneAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *audioPower;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic, strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）


@end

@implementation SZYRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置音频会话
    [self setAudioSession];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    CGFloat viewW = self.view.bounds.size.width;
    CGFloat viewH = self.view.bounds.size.height;
    
    //渲染界面
    self.topViewHeightConstrsint.constant = viewH*0.6;
    self.bottomViewHeightConstrsint.constant = viewH*0.4;

    self.recordBtnWidthConstrsint.constant = viewW*0.4;
    self.recordBtnHeightConstrsint.constant = viewW*0.4;
    
    self.playBtnWidthConstrsint.constant = viewW*0.08;
    self.playBtnHeightConstrsint.constant = viewW*0.08;
//    self.playBtnLeftConstrsint.constant = viewW*0.15;
    
    self.doneBtnWidthConstrsint.constant = 0.16*viewW;
    self.doneBtnHeightConstrsint.constant = 0.07*viewH;
//    self.doneBtnRightConstrsint.constant = viewW*0.15;
    
    self.timeLabelWidthConstrsint.constant = 0.4*viewW;
    self.timeLabelHeightConstrsint.constant = 0.07*viewH;
    self.timeLabelTopConstrsint.constant = 0.02*viewH;

    [self.view layoutIfNeeded];

}


- (IBAction)doneAction:(id)sender {
    
    //停止录音
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPower.progress=0.0;
    //代理传值
    [self.delegate haveCompleteRecord:[self.currentNote videoPath]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)startAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record]; //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)stopAction:(id)sender {
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

//更新记录声音的强度
-(void)audioPowerChange{
    
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
    
}

#pragma mark - 私有方法
-(void)setAudioSession{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setActive:YES error:nil];
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

#pragma mark - getters

-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder){
        //录音本地存储路径
        NSURL *url = [NSURL fileURLWithPath:[self.currentNote videoPath]];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.meteringEnabled=YES;  //如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

-(NSTimer *)timer{
    if (!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


@end
