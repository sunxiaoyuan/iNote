//
//  SZYToolView.m
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYToolView.h"

@interface SZYToolView ()

@property (nonatomic, strong) UIButton *pictureBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *fontBtn;
@property (nonatomic, strong) UIView   *sepLine;
@property (nonatomic, strong) UIButton *hideKeyBoardBtn;
@property (nonatomic, strong) UIView   *edgeLine1;
@property (nonatomic, strong) UIView   *edgeLine2;

@end

@implementation SZYToolView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //底色
        self.backgroundColor = [UIColor whiteColor];
        //添加组件
        self.pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pictureBtn setBackgroundImage:[UIImage imageNamed:@"detail_picture"] forState:UIControlStateNormal];
        [self.pictureBtn addTarget:self action:@selector(pictureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pictureBtn];
        
        self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.videoBtn setBackgroundImage:[UIImage imageNamed:@"detail_video"] forState:UIControlStateNormal];
        [self.videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.videoBtn];
        
        self.fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fontBtn setBackgroundImage:[UIImage imageNamed:@"detail_font"] forState:UIControlStateNormal];
        [self.fontBtn addTarget:self action:@selector(fontBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fontBtn];
        
        self.hideKeyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.hideKeyBoardBtn setBackgroundImage:[UIImage imageNamed:@"detail_keyboard"] forState:UIControlStateNormal];
        [self.hideKeyBoardBtn addTarget:self action:@selector(hideKeyBoardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hideKeyBoardBtn];
        
        //分割线
        self.sepLine = [[UIView alloc]init];
        self.sepLine.backgroundColor = UIColorFromRGB(0xdddddd);
        [self addSubview:self.sepLine];
        //轮廓线
        self.edgeLine1 = [[UIView alloc]init];
        self.edgeLine1.backgroundColor = UIColorFromRGB(0xdddddd);
        [self addSubview:self.edgeLine1];
        self.edgeLine2 = [[UIView alloc]init];
        self.edgeLine2.backgroundColor = UIColorFromRGB(0xdddddd);
        [self addSubview:self.edgeLine2];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;

    CGFloat btnW = SIZ(25);
    CGFloat btnH = SIZ(25);
    CGFloat btnY = (h - btnH)/2;
    CGFloat btnX = (w - 4 * btnW)/5;
    
    self.edgeLine1.frame = CGRectMake(0, 0, w, SIZ(0.5));
    self.edgeLine2.frame = CGRectMake(0, h - SIZ(1), w, SIZ(0.5));
    self.pictureBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    self.videoBtn.frame = CGRectMake(CGRectGetMaxX(self.pictureBtn.frame)+btnX, btnY, btnW, btnH);
    self.fontBtn.frame = CGRectMake(CGRectGetMaxX(self.videoBtn.frame)+btnX, btnY, btnW, btnH);
    self.hideKeyBoardBtn.frame = CGRectMake(CGRectGetMaxX(self.fontBtn.frame)+1.5*btnX, (h-SIZ(30))/2, SIZ(30), SIZ(30));
    self.sepLine.frame = CGRectMake(CGRectGetMaxX(self.fontBtn.frame)+btnX , SIZ(4), SIZ(0.5), h-SIZ(8));
    
}

#pragma mark - 点击响应事件

-(void)pictureBtnClick:(UIButton *)sender{
    [self.delegate addPictureClick:sender];
}

-(void)videoBtnClick:(UIButton *)sender{
    [self.delegate addVideoClick:sender];
}

-(void)fontBtnClick:(UIButton *)sender{
    [self.delegate adjustFontClick:sender];
}

-(void)hideKeyBoardBtnClick{
    
    //通知代理收起键盘，调整自身的frame
    [self.delegate hideKeyBoardClick];
}


@end
