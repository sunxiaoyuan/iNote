//
//  SZYPersonalCenterTableViewCell.h
//  iNote
//
//  Created by Develop on 16/3/2.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYPhotoScrollView.h"

@interface SZYPersonalCenterTableViewCell : UITableViewCell
@end

//@interface SZYMyPhotoTableViewCell : UITableViewCell
//@property (nonatomic ,strong) SZYPhotoScrollView  *photoScrollView;
//@end

@interface SZYBaseInfoTableViewCell : UITableViewCell
//姓名
@property (nonatomic ,strong) UILabel     *nickNameLabel;
@property (nonatomic ,strong) UITextField *nickNameTF;
//生日
@property (nonatomic ,strong) UILabel     *birthDayLabel;
@property (nonatomic ,strong) UIButton    *selectBirthBtn;
//性别
@property (nonatomic ,strong) UILabel     *genderLabel;
@property (nonatomic ,strong) UIButton    *genderShowBtn;
@property (nonatomic ,strong) UIButton    *manBtn;
@property (nonatomic ,strong) UIButton    *womanBtn;
//分割线
@property (nonatomic ,strong) UIView *seplineView1;
@property (nonatomic ,strong) UIView *seplineView2;
@end

@interface SZYInnerStatusTableViewCell : UITableViewCell
@property (nonatomic ,strong) UITextView *internalTextView;
@end


