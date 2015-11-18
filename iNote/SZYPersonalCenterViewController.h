//
//  SZYPersonalCenterViewController.h
//  iNote
//
//  Created by 孙中原 on 15/10/14.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXBlurView;
@class SZYPhotoScrollView;
@class RSKImageCropViewController;
@class SZYDatePickView;
@class SZYSwitch;
@class SZYUser;

@interface SZYPersonalCenterViewController : UIViewController

//最底层scrollview
@property (nonatomic, strong) UIScrollView            *mainScrollView;
//导航栏按钮
@property (nonatomic, strong) UIButton                *backBtn;
@property (nonatomic, strong) UIButton                *rightBtn;
//玻璃底层
@property (nonatomic, strong) UIImageView             *backgroundView;
//头像图片层
@property (nonatomic, strong) UIImageView             *blurImageView;
//头像下图层
@property (nonatomic, strong) UIView                  *avaterBottomView;
//头像
@property (nonatomic, strong) UIImageView             *avaterImageView;
@property (nonatomic, strong) UIButton                *avaterBtn;
//昵称
@property (nonatomic, strong) UILabel                 *nickNameLabel;

//三个资料区域
//“我的照片”
@property (nonatomic, strong) UIView                  *photoBGView;
@property (nonatomic, strong) UILabel                 *photoTitleLabel;
@property (nonatomic, strong) UILabel                 *photoNumberLabel;
@property (nonatomic, strong) SZYPhotoScrollView      *photoScrollView;

//“基本资料”
@property (nonatomic, strong) UIView                  *baseInfoBGView;
@property (nonatomic, strong) UIView                  *baseInfoWhiteView;
@property (nonatomic, strong) UILabel                 *infoTitleLabel;
@property (nonatomic, strong) UILabel                 *infoNickLabel;
@property (nonatomic, strong) UITextField             *infoNickTextField;
@property (nonatomic, strong) UILabel                 *infoBirthLabel;
@property (nonatomic, strong) UIButton                *selectBirthBtn;
@property (nonatomic, strong) UILabel                 *infoSexLabel;
@property (nonatomic, strong) UITextField             *infoNickTF;
@property (nonatomic, strong) UILabel                 *infoBirthResultLabel;
@property (nonatomic, strong) UILabel                 *infoSexResultLabel;
@property (nonatomic, strong) UILabel                 *sexShowLabel;
@property (nonatomic, strong) SZYSwitch               *sexSwitch;
@property (nonatomic, strong) UIView                  *infoLine2;
@property (nonatomic, strong) UIView                  *infoLine3;
@property (nonatomic, strong) SZYDatePickView         *datePickView;

//“内心独白”
@property (nonatomic, strong) UIView                     *internalBGView;
@property (nonatomic, strong) UILabel                    *internalTitleLabel;
@property (nonatomic, strong) UITextView                 *internalTextView;

@property (nonatomic, strong) SZYCommonToolClass         *commTools;
@property (nonatomic, strong) UIImage                    *finalAvater;
@property (nonatomic, assign) BOOL                       isAvater;
@property (nonatomic, assign) BOOL                       isCamera;
@property (nonatomic, strong) UIImagePickerController    *imagePickerVC;
@property (nonatomic, strong) UIImage                    *tempImage;
@property (nonatomic, strong) UIView                     *tempView;
@property (nonatomic, strong) NSData                     *videoFile;
@property (nonatomic, strong) NSMutableArray             *photoArray;
@property (strong, nonatomic) RSKImageCropViewController *imageCropVC;
@property (nonatomic, strong) UIAlertView                *alertView;
@property (nonatomic, strong) NSString                   *birthDay;
@property (nonatomic, assign) BOOL                       isMan;
@property (nonatomic, strong) NSString                   *defaultMsg;
@property (nonatomic, strong) SZYUser                    *currentUser;

@end
