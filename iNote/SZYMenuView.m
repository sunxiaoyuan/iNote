//
//  SZYMenuView.m
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYMenuView.h"

@interface SZYMenuView ()

@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *deleteImageView;
@property (nonatomic, strong) UIButton    *satrBtn;
@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) UIView      *sepLine;

@end

@implementation SZYMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //底色
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        
        //添加组件
        self.bottomView = [[UIView alloc]init];
        self.bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self addSubview:self.bottomView];
        
        self.starImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_favorite"]];
        [self.bottomView addSubview:self.starImageView];
        
        self.deleteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_delete"]];
        [self.bottomView addSubview:self.deleteImageView];
        
        self.satrBtn = [[UIButton alloc]init];
        self.satrBtn.tag = 101;
        [self.satrBtn setTitle:@"收 藏" forState:UIControlStateNormal];
        [self.satrBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [self.satrBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.satrBtn];
        
        self.deleteBtn  = [[UIButton alloc]init];
        self.deleteBtn.tag = 102;
        [self.deleteBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.deleteBtn];
        
        self.sepLine = [[UIView alloc]init];
        self.sepLine.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:self.sepLine];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    CGFloat leadingSpacing = (w - SIZ(65))/2;
    CGFloat topSpacing = ( h - SIZ(50) )/3;
    
    self.bottomView.frame = CGRectMake(0, 0, w, h);
    
    self.starImageView.frame = CGRectMake(leadingSpacing, topSpacing+SIZ(5), SIZ(15), SIZ(15));
    self.satrBtn.frame = CGRectMake(CGRectGetMaxX(self.starImageView.frame), topSpacing, SIZ(50), SIZ(25));
    self.deleteImageView.frame = CGRectMake(leadingSpacing, CGRectGetMaxY(self.satrBtn.frame)+topSpacing+SIZ(5), SIZ(15), SIZ(15));
    self.deleteBtn.frame = CGRectMake(CGRectGetMaxX(self.deleteImageView.frame), CGRectGetMaxY(self.satrBtn.frame)+topSpacing, SIZ(50), SIZ(25));
    
    self.sepLine.frame = CGRectMake(leadingSpacing, CGRectGetMaxY(self.satrBtn.frame)+topSpacing/2, SIZ(75), SIZ(0.5));
    
}   

#pragma mark - 响应事件

-(void)btnClick:(UIButton *)sender{
    
    [self.delegate menuBtnDidClick:sender];
    
}

@end
