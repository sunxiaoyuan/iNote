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
#import "NSDate+TimeStamp.h"
#import "SZYSoundManager.h"
#import "SZYSoundWaveView.h"

@interface SZYRecorderViewController ()

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

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
//完成
- (IBAction)doneAction:(id)sender;
//开始／暂停
- (IBAction)startAction:(id)sender;
//取消（返回）
- (IBAction)cancelAction:(id)sender;
//重置
- (IBAction)clearAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *clearbtn;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, assign) BOOL             isNeedNewRecorder;//是否需要创建新的录音设备
@property (nonatomic, strong) SZYSoundManager  *soundManager;
@property (nonatomic, strong) NSString         *startRecordTime;
@property (nonatomic, strong) SZYSoundWaveView *soundWaveView;
@property (nonatomic, strong) CADisplayLink    *meterUpdateDisplayLink;

@end

@implementation SZYRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置音频会话
    [SZYSoundManager setAudioSession];
    //设置面板颜色
    self.topView.backgroundColor = UIColorFromRGB(0x57bffc);
    self.bottomView.backgroundColor = UIColorFromRGB(0x00a2ff);
    //文字适配
    self.timeLabel.font = FONT_16;
    self.clearbtn.titleLabel.font = FONT_16;
    self.doneBtn.titleLabel.font = FONT_16;
    self.cancelBtn.titleLabel.font = FONT_18;

    self.isNeedNewRecorder = YES;
    self.soundManager = [SZYSoundManager sharedManager];
    [self.view addSubview:self.soundWaveView];
    self.soundWaveView.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    CGFloat viewW = self.view.bounds.size.width;
    CGFloat viewH = self.view.bounds.size.height;
    
    //渲染界面
    self.topViewHeightConstrsint.constant    = viewH * 0.6;
    self.bottomViewHeightConstrsint.constant = viewH * 0.4;

    self.recordBtnWidthConstrsint.constant   = viewW * 0.4;
    self.recordBtnHeightConstrsint.constant  = viewW * 0.4;

    self.playBtnWidthConstrsint.constant     = viewW * 0.16;
    self.playBtnHeightConstrsint.constant    = viewW * 0.07;
//    self.playBtnLeftConstrsint.constant = viewW*0.15;

    self.doneBtnWidthConstrsint.constant     = 0.16 * viewW;
    self.doneBtnHeightConstrsint.constant    = 0.07 * viewH;
//    self.doneBtnRightConstrsint.constant = viewW*0.15;

    self.timeLabelWidthConstrsint.constant   = 0.4 * viewW;
    self.timeLabelHeightConstrsint.constant  = 0.07 * viewH;
    self.timeLabelTopConstrsint.constant     = 0.02 * viewH;

    //强制重新布局子控件
    [self.view layoutIfNeeded];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopUpdatingMeter];
}


#pragma mark - 响应事件

- (IBAction)doneAction:(id)sender {
    
    //停止录音并保存
    [self.soundManager stopAndSaveRecording];
    //通知代理
    [self.delegate haveCompleteRecordAtTime:self.startRecordTime];
    //直接返回详情页
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isNeedNewRecorder) { //第一次点击，触发“开始录音”的动作
        //开始录音
        self.startRecordTime = [NSDate szyTimeStamp];
        [self.soundManager startRecordingAudioWithFilePath:[self.currentNote videoPath] shouldStopAtSecond:0 andBlock:^(NSString *elapsedTime, NSError *error) {
            
            self.timeLabel.text = elapsedTime;
        }];
        //更新声波
        [self startUpdatingMeter];
        
        self.isNeedNewRecorder = NO;
        //重置按钮可用（默认是不可用的）
        self.clearbtn.enabled = YES;
        
    }else{
        if (btn.selected) { //点击了“暂停”
            [self.soundManager pauseRecording];
        }else{ //点击了“开始”
            [self.soundManager resumeRecording];
        }
    }
    btn.selected = !btn.selected;
<<<<<<< HEAD
}

- (IBAction)cancelAction:(id)sender {
    [self stopAudioServiceAndDeleteFileWithDirClear:YES];
=======
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self.currentNote deleteVideoAtLocalWithDirClear:YES];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearAction:(id)sender {
<<<<<<< HEAD
    [self stopAudioServiceAndDeleteFileWithDirClear:NO];
=======
    /*
     注意：这个接口之所以会保存录音文件，是因为在底层调用stop函数后，录音文件自动会保存，需要根据实际情况清除本地录音文件
     */
    [self.soundManager stopAndSaveRecording];
    //清除本地文件,但暂时保存目录
    [self.currentNote deleteVideoAtLocalWithDirClear:NO];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    self.isNeedNewRecorder = YES;
    self.timeLabel.text = @"00:00";
}

- (void)updateMeters{
    if (self.soundWaveView.hidden) self.soundWaveView.hidden = NO;
    [self.soundWaveView updateWithLevel:[self.soundManager updateMeters]];
}

#pragma mark - 私有方法
<<<<<<< HEAD
-(void)stopAudioServiceAndDeleteFileWithDirClear:(BOOL)isClear{
    /*
     注意：这个接口之所以会保存录音文件，是因为在底层调用stop函数后，录音文件自动会保存，需要根据实际情况清除本地录音文件
     */
    [self.soundManager stopAndSaveRecording];
    [self.currentNote deleteVideoAtLocalWithDirClear:isClear];
}



=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(void)startUpdatingMeter{
    
    //CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类
    [self.meterUpdateDisplayLink invalidate];
    self.meterUpdateDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [self.meterUpdateDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  
}

-(void)stopUpdatingMeter{
    
    [self.meterUpdateDisplayLink invalidate];
    self.meterUpdateDisplayLink = nil;
}

#pragma mark - getters

-(SZYSoundWaveView *)soundWaveView{
    if (!_soundWaveView){
        _soundWaveView = [[SZYSoundWaveView alloc]initWithFrame:CGRectMake(0, 150, UIScreenWidth, 100)];
    }
    return _soundWaveView;
}

@end
