//
//  SZYSettingView.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSettingView.h"
#import "SZYMenuButton.h"

#define kItemLeadingSpacing 10

@interface SZYSettingView ()

@property (nonatomic, strong) UILabel     *leftLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation SZYSettingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightImageView];
    }
    return self;
}


+(instancetype)settingViewWithTitle:(NSString *)title{
    
    SZYSettingView *settingView = [[SZYSettingView alloc]init];
    settingView.leftLabel.text = title;
    return settingView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    
    CGFloat labelW = viewW * 0.5;
    CGFloat labelH = viewH * 0.6;
    CGFloat labelY = (viewH - labelH) / 2;
    _leftLabel.frame = CGRectMake(kItemLeadingSpacing, labelY, labelW, labelH);
    
    CGFloat imageH = viewH * 0.4;
    CGFloat imageW = imageH * 0.3;
    CGFloat imageX = viewW - kItemLeadingSpacing - imageW;
    CGFloat imageY = (viewH - imageH) / 2;
    _rightImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
}

#pragma mark - getters

-(UILabel *)leftLabel{
    if (!_leftLabel){
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = FONT_20;
        _leftLabel.textColor = UIColorFromRGB(0x888888);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView){
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [UIImage imageNamed:@"right_arrow_grey"];;
    }
    return _rightImageView;
}

@end
