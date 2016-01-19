//
//  SZYSoundWaveView.h
//  iNote
//
//  Created by sunxiaoyuan on 16/1/4.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZYSoundWaveView : UIView

//更新声波
-(void)updateWithLevel:(CGFloat)level;

//声波数量
@property (nonatomic, assign) NSUInteger numberOfWaves;

//声波颜色
@property (nonatomic, strong) UIColor *waveColor;

//主声波宽度
@property (nonatomic, assign) CGFloat primaryWaveLineWidth;

//次声波宽度
@property (nonatomic, assign) CGFloat secondaryWaveLineWidth;

//默认振幅
@property (nonatomic, assign) CGFloat idleAmplitude;

//震动频率
@property (nonatomic, assign) CGFloat frequency;

//当前振幅
@property (nonatomic, assign, readonly) CGFloat amplitude;

//密度
@property (nonatomic, assign) CGFloat density;

//相位定向
@property (nonatomic, assign) CGFloat phaseShift;

@end
