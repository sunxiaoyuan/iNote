//
//  SZYSoundWaveView.m
//  iNote
//
//  Created by sunxiaoyuan on 16/1/4.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYSoundWaveView.h"

@interface SZYSoundWaveView ()

@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;

@end

@implementation SZYSoundWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

-(void)setUp{
    
    //属性默认值
    _frequency = 1.5f;
    _amplitude = 1.0f;
    _idleAmplitude = 0.01f;
    _numberOfWaves = 5;
    _phaseShift = -0.15f;
    _density = 5.0f;
    _waveColor = [UIColor whiteColor];
    _primaryWaveLineWidth = 3.0f;
    _secondaryWaveLineWidth = 1.0f;
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)updateWithLevel:(CGFloat)level{
    self.phase += self.phaseShift;
    self.amplitude = fmax( level, self.idleAmplitude);
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将显示区域填充为透明背景
    CGContextClearRect(context, self.bounds);
    //设置颜色
    [self.backgroundColor set];
    //补充当前填充颜色的rect
    CGContextFillRect(context, rect);
    
    for(int i = 0; i < self.numberOfWaves; i++) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线的宽度
        CGContextSetLineWidth(context, (i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth));
        
        CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat mid = width / 2.0f;
        
        //最大振幅
        const CGFloat maxAmplitude = halfHeight - 4.0f;
        
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - 0.5f) * self.amplitude;
        
        //根据声音强度 ，设置透明度
        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
        [[self.waveColor colorWithAlphaComponent:multiplier * CGColorGetAlpha(self.waveColor.CGColor)] set];
        
        for(CGFloat x = 0; x < width + self.density; x += self.density) {
            
            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
            
            CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
            
            if (x==0) {
                //x,y为开始点坐标
                CGContextMoveToPoint(context, x, y);
            }
            else {//x,y为结束点坐标
                CGContextAddLineToPoint(context, x, y);
            }
        }
        //画线
        CGContextStrokePath(context);
    }
}


@end
