//
//  SZYDetailNaviView.m
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYDetailNaviView.h"

#define kBackBtnX      16
#define kBackBtnY      32
#define kBackBtnWidth  20
#define kBackBtnHeight 20

@interface SZYDetailNaviView ()

@property (nonatomic, strong) UIButton          *doneBtn;
@property (nonatomic, strong) UIButton          *moreBtn;
@property (nonatomic, strong) UIButton          *backBtn;
@property (nonatomic, strong) UIImageView       *backgroundImageView;

@end

@implementation SZYDetailNaviView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置底色
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.backgroundColor = ThemeColor;
        self.backgroundImageView.image = [UIImage imageNamed:@"recomend_btn_gone"];
        [self addSubview:self.backgroundImageView];
        
        //添加左侧back按钮
        self.backBtn = [[UIButton alloc]init];
        [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        //添加更多按钮
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreBtn];
        
        //完成按钮
        self.doneBtn = [[UIButton alloc]init];
        [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.doneBtn.hidden = YES;
        [self addSubview:self.doneBtn];
    
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    
    self.backgroundImageView.frame = self.bounds;
    
    //两侧按钮
    self.backBtn.frame = CGRectMake(kBackBtnX, kBackBtnY, kBackBtnWidth, kBackBtnHeight);
    self.moreBtn.frame = CGRectMake(w - 43, 27.5, 27, 27);
    self.doneBtn.frame = CGRectMake(w - 56, 22, 40, 40);
    
}

#pragma mark - 点击事件

-(void)backClick:(UIButton *)sender{
    
    [self.delegate customNaviViewLeftMenuClick:sender];
}

-(void)moreClick{
    
    if ([self.delegate respondsToSelector:@selector(moreBtnDidclick)]) {
        [self.delegate moreBtnDidclick];
    }
    
}
-(void)doneBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(doneBtnDidClick)]) {
        [self.delegate doneBtnDidClick];
    }
}

#pragma mark - 公开方法
-(void)enterEditingState{
    //隐藏“更多”
    self.moreBtn.hidden = YES;
    self.moreBtn.enabled= NO;
    //显示“完成”
    self.doneBtn.hidden = NO;
    self.doneBtn.enabled = YES;
}

-(void)exitEditingState{
    //显示“更多”
    self.moreBtn.hidden = NO;
    self.moreBtn.enabled = YES;
    //隐藏“完成”
    self.doneBtn.hidden = YES;
    self.doneBtn.enabled = NO;
}

-(void)hideBarButton{
    [self.doneBtn removeFromSuperview];
    [self.moreBtn removeFromSuperview];
}

-(void)removeMoreBtn{
    [self.moreBtn removeFromSuperview];
}

@end
