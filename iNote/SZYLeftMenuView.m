//
//  SZYLeftMenuView.m
//  iNote
//
//  Created by 孙中原 on 15/10/8.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYLeftMenuView.h"
#import "SZYMenuButton.h"

#define SZYBtnScaleForWidth         0.52
#define SZYBtnScaleForHeight        0.07
#define SZYBtnScaleForLeft          0.14
#define SZYBtnScaleForBottom        0.25
#define SZYVerticalScaleForBtn      0.025
#define SZYVerticalScaleForImageBtn 0.12

@interface SZYLeftMenuView ()
//按钮输出口
@property (weak, nonatomic  ) IBOutlet UIButton           *loginBtn;
@property (weak, nonatomic  ) IBOutlet SZYMenuButton      *homeBtn;
@property (weak, nonatomic  ) IBOutlet SZYMenuButton      *notesBtn;
@property (weak, nonatomic  ) IBOutlet SZYMenuButton      *favoriteBtn;
@property (weak, nonatomic  ) IBOutlet SZYMenuButton      *settingBtn;
//选中的按钮
@property (nonatomic,strong ) UIButton                    *selectedBtn;
//约束
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *btnLeftConstraint;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *btnWidthConstraint;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *btnBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnImageVerticalConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnVerticalConstraint;
//左侧按钮动作
- (IBAction)leftBtnClick:(id)sender;

@end

@implementation SZYLeftMenuView

-(void)awakeFromNib{
    
    //给按钮添加tag值
    self.homeBtn.tag = SZYleftButtonTypeHome;
    self.notesBtn.tag = SZYleftButtonTypeNotes;
    self.favoriteBtn.tag = SZYleftButtonTypeFavorite;
    self.settingBtn.tag = SZYleftButtonTypeSeting;
    self.loginBtn.tag = SZYleftButtonTypeLogin;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //在此处适配
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    
    CGFloat btnW = viewWidth * SZYBtnScaleForWidth;
    CGFloat btnH = viewHeight * SZYBtnScaleForHeight;
    CGFloat btnX = viewWidth * SZYBtnScaleForLeft;
    CGFloat btnbottom = viewHeight * SZYBtnScaleForBottom;
    CGFloat btnVertical = viewHeight *SZYVerticalScaleForBtn;
    CGFloat imageBtnVertical = viewHeight * SZYVerticalScaleForImageBtn;
    
    self.btnHeightConstraint.constant = btnH;
    self.btnWidthConstraint.constant = btnW;
    self.btnLeftConstraint.constant = btnX;
    self.btnBottomConstraint.constant = btnbottom;
    self.btnVerticalConstraint.constant = btnVertical;
    self.btnImageVerticalConstraint.constant = imageBtnVertical;
    
    //强制进行子视图的重绘
    [self.settingBtn layoutIfNeeded];
    
}

#pragma mark - 响应事件

- (IBAction)leftBtnClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    //通知代理
    [self.delegate switchViewControllerFrom:(SZYleftButtonType)self.selectedBtn.tag To:(SZYleftButtonType)btn.tag];
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = sender;
}

#pragma mark - setters

- (void)setDelegate:(id<SZYLeftMenuViewDelegate>)delegate
{
    _delegate = delegate;
    [self leftBtnClick:self.homeBtn];
}

@end
