//
//  SZYSettingView.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSettingView.h"
#import "SZYMenuButton.h"

@interface SZYSettingView ()

@property (nonatomic, strong) UILabel     *leftLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation SZYSettingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


+(instancetype)settingViewWithTitle:(NSString *)title{
    
    SZYSettingView *settingView = [[SZYSettingView alloc]init];
    settingView.leftLabel.text = title;
    return settingView;
}

-(void)setUp{
    
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.masksToBounds = YES;

    _leftLabel = [[UILabel alloc]init];
    _leftLabel.font = FONT_20;
    _leftLabel.textColor = UIColorFromRGB(0x888888);
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_leftLabel];
    
    _rightImageView = [[UIImageView alloc]init];
    _rightImageView.image = [UIImage imageNamed:@"right_arrow_grey"];
    [self addSubview:_rightImageView];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
//    self.layer.cornerRadius = (W > H ? H : W) * 0.15;
    _leftLabel.frame = CGRectMake(SIZ(10), H * 0.2, W * 0.5, H * 0.6);
    
    CGFloat imageH = H * 0.4;
    CGFloat imageW = imageH;
    CGFloat imageX = W - SIZ(20);
    CGFloat imageY = (H - imageH)/2;
    _rightImageView.frame = CGRectMake(imageX, imageY, imageW * 0.3, imageH);
    
}

@end
