//
//  SZYPhotoChooseView.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/30.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYPhotoChooseView.h"
#import "PZPhotoView.h"

@interface SZYPhotoChooseView ()

@property (nonatomic, strong) PZPhotoView *photoView;
@property (nonatomic, strong) UIView      *topView;
@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UIButton    *enterBtn;
@property (nonatomic, strong) UIButton    *cancelBtn;
@property (nonatomic, strong) UIImage     *showImage;

@end

@implementation SZYPhotoChooseView

- (instancetype)initWithFrame:(CGRect)frame AndImage:(UIImage *)image
{
    _showImage = image;
    
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.photoView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.enterBtn];
        [self.bottomView addSubview:self.cancelBtn];
        
        self.backgroundColor = UIColorFromRGB(0xc333333);
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    
    self.topView.frame = CGRectMake(0, 0, viewW, 64);
    self.photoView.frame = CGRectMake(0, self.topView.bottom, viewW, viewH-108);
    self.bottomView.frame = CGRectMake(0, self.photoView.bottom, viewW, 44);
    self.enterBtn.frame = CGRectMake(viewW-50, 0, 50, 44);
    self.cancelBtn.frame = CGRectMake(0, 0, 50, 44);
    
}

#pragma mark - 响应事件

-(void)selectImageclick:(UIButton *)sender{
    //通知代理
    [self.delegate chooseBtnDidClick:sender];
}


#pragma mark - getters
-(PZPhotoView *)photoView{
    if (!_photoView){
        _photoView = [[PZPhotoView alloc]init];
        [_photoView displayImage:self.showImage];
    }
    return _photoView;
}
-(UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = ThemeColor;
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = ThemeColor;
    }
    return _bottomView;
}
-(UIButton *)enterBtn{
    if (!_enterBtn){
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.tag = 100;
        [_enterBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(selectImageclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 101;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(selectImageclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
