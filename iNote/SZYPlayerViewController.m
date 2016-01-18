//
//  SZYPlayerViewController.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYPlayerViewController.h"
#import "SZYSoundManager.h"

@interface SZYPlayerViewController ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIButton *resumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *resumeOrPauseBtn;
- (IBAction)playAction:(UIButton *)sender;
- (IBAction)backOrForwardAudio:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)resumeOrPauseAction:(UIButton *)sender;
@property (nonatomic, strong) NSString       *audioPath;
@property (nonatomic, strong) SZYSoundManager *soundManager;

//约束部分
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backBtnWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backBtnHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backBtnLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resumeBtnHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resumeBtnWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resumeBtnBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playBtnWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playBtnHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playBtnLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *elapsedLblWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *elapsedLblHeightConstraint;

@end

@implementation SZYPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //文字适配
    self.backBtn.titleLabel.font = FONT_18;
    //色彩适配
    self.topView.backgroundColor = UIColorFromRGB(0x57bffc);
    self.bottomView.backgroundColor = UIColorFromRGB(0x00a2ff);

    self.soundManager = [SZYSoundManager sharedManager];
    //设置音频会话
    [SZYSoundManager setAudioSession];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGFloat viewW = self.view.width;
    CGFloat viewH = self.view.height;
    
    self.topViewHeightConstraint.constant = 0.618 * viewH;
    self.bottomViewHeightConstraint.constant = 0.382 * viewH;
    
    self.backBtnTopConstraint.constant = 0.05 * viewH;
    self.backBtnLeftConstraint.constant = 0.05 * viewW;
    self.backBtnWidthConstraint.constant = 0.14 * viewW;
    self.backBtnHeightConstraint.constant = 0.05 * viewH;
    
    self.resumeBtnWidthConstraint.constant = 0.2 * viewH;
    self.resumeBtnHeightConstraint.constant = self.resumeBtnWidthConstraint.constant;
    self.resumeBtnBottomConstraint.constant = 0.07 * viewH;
    
    self.playBtnWidthConstraint.constant = 0.09 * viewW;
    self.playBtnHeightConstraint.constant = self.playBtnWidthConstraint.constant;
    self.playBtnLeftConstraint.constant = 0.13 * viewW;
    
    self.elapsedLblWidthConstraint.constant = 0.12 * viewW;
    self.elapsedLblHeightConstraint.constant = 0.03 * viewH;
    
    [self.view setNeedsLayout];
}

-(void)setLocalAudioFilePath:(NSString *)audioPath{
    
    _audioPath = audioPath;
//    _audioPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], @"jazz.mp3"];  //测试数据
}

#pragma mark - 响应方法

//开始播放
- (IBAction)playAction:(UIButton *)sender {
    
    [self.soundManager startPlayingLocalFileWithPath:self.audioPath andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"mm:ss";
        NSDate *elapsedTimeDate = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
        _elapsedTimeLabel.text = [formatter stringFromDate:elapsedTimeDate];
        NSDate *timeRemainingDate = [NSDate dateWithTimeIntervalSince1970:timeRemaining];;
        _remainTimeLabel.text = [formatter stringFromDate:timeRemainingDate];
        _slider.value = percentage * 0.01;
        //主按钮这样处理，是避免计时器循环过程中不断刷新按钮状态
//        if (finished) {
            self.resumeOrPauseBtn.selected = !finished;
//        }
    }];
    //设置主按钮样
//    self.resumeOrPauseBtn.selected = YES;
}

//调节播放进度
- (IBAction)backOrForwardAudio:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    [self.soundManager moveToSection:slider.value];
}


- (IBAction)backAction:(id)sender {
    //关闭播放器
    [self.soundManager stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resumeOrPauseAction:(UIButton *)sender {
    
    if (sender.selected) {
        //pause
        [self.soundManager pause];
    }else{
        //resume
        [self.soundManager resume];
    }
    sender.selected = !sender.selected;
}


@end
