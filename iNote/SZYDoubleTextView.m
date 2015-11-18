//
//  SZYDoubleTextView.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//   导航条上的自定义上下title

#import "SZYDoubleTextView.h"

@interface SZYDoubleTextView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation SZYDoubleTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUP];
    }
    return self;
}

-(void)setUP{
    //初始化组件
    self.titleLabel = [[UILabel alloc]init];
    [self addTitleLabelWith:self.titleLabel font:[UIFont boldSystemFontOfSize:16]];
    self.subTitleLabel = [[UILabel alloc]init];
    [self addTitleLabelWith:self.subTitleLabel font:[UIFont boldSystemFontOfSize:13]];
    
}

//重新布局view的子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    self.titleLabel.frame = CGRectMake(0, 2, w, 20);
    self.subTitleLabel.frame = CGRectMake(0, 22 , w, 20);
    
}

-(void)setTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

-(void)addTitleLabelWith:(UILabel *)label font:(UIFont *)font
{
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    [self addSubview:label];
}

@end
