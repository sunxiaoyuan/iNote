//
//  SZYPersonalCenterTableViewCell.m
//  iNote
//
//  Created by Develop on 16/3/2.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYPersonalCenterTableViewCell.h"
#import "UIImage+Size.h"
#import "UIAlertController+SZYKit.h"

#define kLeadingSpacing 10

@implementation SZYPersonalCenterTableViewCell

@end

//#pragma mark - 我的相册
//
//@implementation SZYMyPhotoTableViewCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        _photoScrollView = [[SZYPhotoScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
//        _photoScrollView.backgroundColor = [UIColor whiteColor];
//        _photoScrollView.userInteractionEnabled = YES;
//        _photoScrollView.pagingEnabled = YES;
//        _photoScrollView.showsHorizontalScrollIndicator = NO;
//        _photoScrollView.tag = 100;
//        _photoScrollView.addPhotoBtn.hidden = YES;
//        [_photoScrollView setPhoto:[ApplicationDelegate.userSession photosAtLocal]];
//        [self.contentView addSubview:_photoScrollView];
//    }
//    return self;
//}
//
//@end

#pragma mark - 基本资料

@implementation SZYBaseInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.nickNameTF];
        [self.contentView addSubview:self.seplineView1];
        [self.contentView addSubview:self.birthDayLabel];
        [self.contentView addSubview:self.selectBirthBtn];
        [self.contentView addSubview:self.seplineView2];
        [self.contentView addSubview:self.genderLabel];
        [self.contentView addSubview:self.genderShowBtn];
        [self.contentView addSubview:self.womanBtn];
        [self.contentView addSubview:self.manBtn];
        
    }
    return self;
}

#pragma mark - getters
-(UIView *)seplineView1{
    if (_seplineView1 == nil){
        _seplineView1 = [[UIView alloc]initWithFrame:CGRectMake(kLeadingSpacing, 50, UIScreenWidth-2*kLeadingSpacing, 0.5)];
        _seplineView1.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _seplineView1;
}
-(UIView *)seplineView2{
    if (_seplineView2 == nil){
        _seplineView2 = [[UIView alloc]initWithFrame:CGRectMake(kLeadingSpacing, 100, UIScreenWidth-2*kLeadingSpacing, 0.5)];
        _seplineView2.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _seplineView2;
}
-(UILabel *)nickNameLabel{
    if (!_nickNameLabel){
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeadingSpacing, 12.5, 45, 25)];
        _nickNameLabel.font = FONT_14;
        _nickNameLabel.textColor = UIColorFromRGB(0x333333);
        _nickNameLabel.text = @"昵称";
        _nickNameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nickNameLabel;
}
-(UITextField *)nickNameTF{
    if (!_nickNameTF){
        _nickNameTF = [[UITextField alloc]initWithFrame:CGRectMake(UIScreenWidth-220-kLeadingSpacing, 12.5, 220, 25)];
        _nickNameTF.font = FONT_14;
        _nickNameTF.textAlignment = NSTextAlignmentRight;
        _nickNameTF.returnKeyType = UIReturnKeyDone;
        _nickNameTF.tintColor = UIColorFromRGB(0xdddddd);
        _nickNameTF.textColor = UIColorFromRGB(0x888888);
        _nickNameTF.enabled = NO;
        _nickNameTF.backgroundColor = [UIColor whiteColor];
        _nickNameTF.text = ApplicationDelegate.userSession.user_nickname;
    }
    return _nickNameTF;
}
-(UILabel *)birthDayLabel{
    if (!_birthDayLabel){
        _birthDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeadingSpacing, _seplineView1.bottom+12.5, 45, 25)];
        _birthDayLabel.font = FONT_14;
        _birthDayLabel.textColor = UIColorFromRGB(0x333333);
        _birthDayLabel.text = @"生日";
        _birthDayLabel.backgroundColor = [UIColor whiteColor];
    }
    return _birthDayLabel;
}
-(UIButton *)selectBirthBtn{
    if (_selectBirthBtn == nil){
        _selectBirthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBirthBtn.frame = CGRectMake(UIScreenWidth-kLeadingSpacing-130, _birthDayLabel.top, 130, 25);
        [_selectBirthBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _selectBirthBtn.titleLabel.font = FONT_14;
        _selectBirthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _selectBirthBtn.enabled = NO;
        _selectBirthBtn.backgroundColor = [UIColor whiteColor];
        [_selectBirthBtn setTitle:ApplicationDelegate.userSession.user_birth forState:UIControlStateNormal];
    }
    return _selectBirthBtn;
}
-(UILabel *)genderLabel{
    if (_genderLabel == nil){
        _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeadingSpacing, _seplineView2.bottom+12.5, 45, 25)];
        _genderLabel.font = FONT_14;
        _genderLabel.textColor = UIColorFromRGB(0x333333);
        _genderLabel.text = @"性别";
        _genderLabel.backgroundColor = [UIColor whiteColor];
    }
    return _genderLabel;
}
-(UIButton *)genderShowBtn{
    if (_genderShowBtn == nil){
        _genderShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenWidth-kLeadingSpacing-50, _genderLabel.top, 50, 25)];
        _genderShowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_genderShowBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _genderShowBtn.titleLabel.font = FONT_14;
        _genderShowBtn.backgroundColor = [UIColor whiteColor];
        _genderShowBtn.enabled = NO;
        [_genderShowBtn setTitle:ApplicationDelegate.userSession.user_sex forState:UIControlStateNormal];
    }
    return _genderShowBtn;
}
-(UIButton *)womanBtn{
    if (!_womanBtn){
        _womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _womanBtn.frame = CGRectMake(UIScreenWidth-kLeadingSpacing-50, _genderLabel.top, 50, 25);
        _womanBtn.titleLabel.font = FONT_14;
        _womanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
        [_womanBtn setTitle:@"女" forState:UIControlStateSelected];
        [_womanBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        [_womanBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _womanBtn.hidden = YES;
    }
    return _womanBtn;
}

-(UIButton *)manBtn{
    if (!_manBtn){
        _manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _manBtn.frame = CGRectMake(_womanBtn.left-50, _genderLabel.top, 50, 25);
        _manBtn.titleLabel.font = FONT_14;
        _manBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_manBtn setTitle:@"男" forState:UIControlStateNormal];
        [_manBtn setTitle:@"男" forState:UIControlStateSelected];
        [_manBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        [_manBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _manBtn.hidden = YES;
    }
    return _manBtn;
}

@end

#pragma mark - 个性签名

@implementation SZYInnerStatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.internalTextView];
    }
    return self;
}

-(UITextView *)internalTextView{
    if (_internalTextView == nil){
        _internalTextView = [[UITextView alloc]initWithFrame:CGRectMake(kLeadingSpacing, 12.5, UIScreenWidth-2*kLeadingSpacing, 75)];
        _internalTextView.textColor = UIColorFromRGB(0x888888);
        _internalTextView.backgroundColor = [UIColor whiteColor];
        _internalTextView.font = FONT_14;
        _internalTextView.scrollEnabled = YES;
        _internalTextView.returnKeyType = UIReturnKeyDone;
        _internalTextView.editable = NO;
        _internalTextView.text = [ApplicationDelegate.userSession.user_status isEqualToString:@""] ? @"这家伙很懒,什么都不想说" : ApplicationDelegate.userSession.user_status;
    }
    return _internalTextView;
}

@end



