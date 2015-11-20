//
//  SZYPersonalCenterViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/14.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYPersonalCenterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PZPhotoView.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "SZYPhotoScrollView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "RSKImageCropViewController.h"
#import "SZYDatePickView.h"
#import "SZYSwitch.h"
#import "UIImage+Size.h"
#import "SZYUser.h"

@interface SZYPersonalCenterViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SZYPhotoScrollViewClickDelegate,MJPhotoBrowserDelegate,RSKImageCropViewControllerDelegate,SZYDatePickViewDelegate,UITextViewDelegate>

@end

@implementation SZYPersonalCenterViewController


#pragma mark - life cycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    //初始化工具
    self.commTools = [[SZYCommonToolClass alloc]init];
    //初始化属性
    self.photoArray = [[NSMutableArray alloc]init];
    self.alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    self.birthDay = [NSString string];
    self.defaultMsg = @"这家伙很懒,什么都不想说";
    self.currentUser = ApplicationDelegate.userSession;
    
    //添加界面组件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.backgruondView];
    [self.mainScrollView addSubview:self.blurImageView];
    [self.mainScrollView addSubview:self.avaterBottomView];
    [self.mainScrollView addSubview:self.avaterImageView];
    [self.mainScrollView addSubview:self.avaterBtn];
    [self.mainScrollView addSubview:self.nickNameLabel];
    
    [self.photoBGView addSubview:self.photoTitleLabel];
    [self.photoBGView addSubview:self.photoNumberLabel];
    [self.photoBGView addSubview:self.photoScrollView];
    [self.mainScrollView addSubview:self.photoBGView];
    
    [self.baseInfoBGView addSubview:self.infoTitleLabel];
    [self.baseInfoWhiteView addSubview:self.infoNickLabel];
    [self.baseInfoWhiteView addSubview:self.infoNickTextField];
    [self.baseInfoWhiteView addSubview:self.infoBirthLabel];
    [self.baseInfoWhiteView addSubview:self.selectBirthBtn];
    [self.baseInfoWhiteView addSubview:self.infoSexLabel];
    [self.baseInfoWhiteView addSubview:self.sexShowLabel];
    [self.baseInfoWhiteView addSubview:self.sexSwitch];
    [self.baseInfoWhiteView addSubview:self.infoLine2];
    [self.baseInfoWhiteView addSubview:self.infoLine3];
    [self.baseInfoBGView addSubview:self.baseInfoWhiteView];
    [self.mainScrollView addSubview:self.baseInfoBGView];

    [self.internalBGView addSubview:self.internalTitleLabel];
    [self.internalBGView addSubview:self.internalTextView];
    [self.mainScrollView addSubview:self.internalBGView];
    
    [self.mainScrollView addSubview:self.datePickView];
    
    //装载数据
    
    [self initData];

}

-(void)initData{
    //头像
    self.avaterImageView.image = [self.currentUser avaterAtLocal];
    //“我的照片”
    [self.photoScrollView setPhoto:[self.currentUser photosAtLocal]];
    NSUInteger photoNumber = self.currentUser.image_url_list.count;
    self.photoNumberLabel.text = [NSString stringWithFormat:@"（%lu/8）",photoNumber];
    //内心独白
    if (self.internalTextView.text.length == 0) {
        self.internalTextView.text = self.defaultMsg;
    }else{
        self.internalTextView.text = self.currentUser.user_status;
    }
    //性别
    self.sexSwitch.on = [self.currentUser.user_sex isEqualToString:@"Man"] ? YES : NO;
    //昵称
    self.infoNickTextField.text = self.currentUser.user_nickname;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏按钮
    self.backBtn.frame = CGRectMake(0, 0, SIZ(20), SIZ(20));
    self.rightBtn.frame = CGRectMake(0, 0, SIZ(40), SIZ(40));
    
    self.mainScrollView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    //上方面板
    self.backgruondView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight * 0.25);
    self.blurImageView.frame = self.backgroundView.frame;
    self.avaterBottomView.frame = CGRectMake((UIScreenWidth - SIZ(85))/2, SIZ(15), SIZ(85), SIZ(85));
    self.avaterBottomView.layer.cornerRadius = CGRectGetHeight([self.avaterBottomView bounds])/2;
    self.avaterImageView.frame = CGRectMake((UIScreenWidth - SIZ(82))/2, SIZ(16.5), SIZ(82), SIZ(82));
    self.avaterImageView.layer.cornerRadius = CGRectGetHeight([self.avaterImageView bounds])/2;
    self.avaterBtn.frame = self.avaterImageView.frame;
    CGSize nickNameSize = [[[SZYCommonToolClass alloc]init] newLabelSizeWithContent:self.nickNameLabel.text Font:FONT_15 IsSngle:YES Width:0];
    self.nickNameLabel.frame = CGRectMake((UIScreenWidth-nickNameSize.width)/2, CGRectGetMaxY(self.avaterImageView.frame)+SIZ(13), nickNameSize.width, SIZ(20));
    
    //我的照片
    self.photoBGView.frame = CGRectMake(0, CGRectGetMaxY(self.backgroundView.frame)+SIZ(5), UIScreenWidth, UIScreenHeight*0.13);
    self.photoTitleLabel.frame = CGRectMake(SIZ(5), 0, SIZ(80), self.photoBGView.frame.size.height*1/3);
    self.photoNumberLabel.frame = CGRectMake(UIScreenWidth-SIZ(80), 0, SIZ(80), self.photoBGView.frame.size.height*1/3);
    self.photoScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.photoTitleLabel.frame), UIScreenWidth, self.photoBGView.frame.size.height*2/3);
    
    //基本资料
    self.baseInfoBGView.frame = CGRectMake(0, CGRectGetMaxY(self.photoBGView.frame), UIScreenWidth, UIScreenHeight*0.23);
    CGFloat baseInfoLaeblH = self.baseInfoBGView.frame.size.height*0.25;
    self.infoTitleLabel.frame = CGRectMake(SIZ(5), 0, SIZ(100), baseInfoLaeblH);
    self.baseInfoWhiteView.frame = CGRectMake(0, CGRectGetMaxY(self.infoTitleLabel.frame), UIScreenWidth, self.baseInfoBGView.frame.size.height*3/4);
    self.infoNickLabel.frame = CGRectMake(SIZ(5),0,SIZ(43),baseInfoLaeblH);
    self.infoNickTextField.frame = CGRectMake(SIZ(53), 0, UIScreenWidth-SIZ(60), baseInfoLaeblH);
    self.infoLine2.frame = CGRectMake(0, CGRectGetMaxY(self.infoNickLabel.frame), UIScreenWidth, 0.5);
    self.infoBirthLabel.frame = CGRectMake(SIZ(5), CGRectGetMaxY(self.infoNickLabel.frame), SIZ(43), baseInfoLaeblH);
    self.selectBirthBtn.frame = CGRectMake(SIZ(53), CGRectGetMaxY(self.infoNickLabel.frame), UIScreenWidth-SIZ(60), baseInfoLaeblH);
    self.infoLine3.frame = CGRectMake(0, CGRectGetMaxY(self.infoBirthLabel.frame), UIScreenWidth, 0.5);
    self.infoSexLabel.frame = CGRectMake(SIZ(5), CGRectGetMaxY(self.infoBirthLabel.frame), SIZ(43), baseInfoLaeblH);
    self.sexShowLabel.frame = CGRectMake(SIZ(53), CGRectGetMaxY(self.infoBirthLabel.frame), UIScreenWidth-SIZ(60), baseInfoLaeblH);
    self.sexSwitch.frame = CGRectMake(UIScreenWidth-SIZ(45), CGRectGetMaxY(self.infoBirthLabel.frame)+((baseInfoLaeblH-SIZ(20))/2), SIZ(40), SIZ(20));

    
    //内心独白
    self.internalBGView.frame = CGRectMake(0, CGRectGetMaxY(self.baseInfoBGView.frame), UIScreenWidth, UIScreenHeight*0.23);
    self.internalTitleLabel.frame = CGRectMake(SIZ(5), 0, UIScreenWidth, self.internalBGView.frame.size.height*1/4);
    self.internalTextView.frame = CGRectMake(0, CGRectGetMaxY(self.internalTitleLabel.frame), UIScreenWidth, self.internalBGView.frame.size.height*3/4);
    
    //生日选择层
    self.datePickView.frame  = CGRectMake(0, UIScreenHeight, UIScreenWidth, SIZ(180));
    
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://照相机
        {
            self.isCamera = YES;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = self.isAvater;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://本地相薄
        {
            self.isCamera = NO;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            [imagePicker.navigationBar setBarTintColor:ThemeColor];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = self.isAvater;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]){
        if (self.isAvater) {
            
            UIImage *imge = [info objectForKey:UIImagePickerControllerEditedImage];
            //存储图片到本地
            self.finalAvater = imge;
            [self.currentUser saveAvater:imge IsFake:YES];
            
            //改变界面头像图片
//            self.blurImageView.image = [self.commTools blurImageWithImage:imge];
            self.avaterImageView.image = imge;
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            UIImage *imge = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (self.isCamera) {
                
                //修正方向
                UIImage *fixedImage = [self.commTools fixOrientation:imge];
                //保存到本地
                [self.photoArray addObject:fixedImage];
                [picker dismissViewControllerAnimated:YES completion:nil];

            }else{
                
                self.imagePickerVC = picker;
                self.tempImage = [self.commTools fixOrientation:imge];
                if (self.tempView == nil) {
                    
                    self.tempView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, UIScreenHeight)];
                    self.tempView.backgroundColor = UIColorFromRGB(0xc333333);
                    PZPhotoView *imageView = [[PZPhotoView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SIZ(44))];
                    imageView.tag = 22;
                    [imageView displayImage:imge];
                    
                    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tempView.frame.size.height - SIZ(44), UIScreenWidth, SIZ(44))];
                    bottomView.backgroundColor = ThemeColor;
                    //确定按钮
                    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    enterButton.tag = 100;
                    enterButton.frame = CGRectMake(UIScreenWidth - SIZ(50), 0, SIZ(50), SIZ(44));
                    [enterButton setTitle:@"确定" forState:UIControlStateNormal];
                    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [enterButton addTarget:self action:@selector(selectImageClick:) forControlEvents:UIControlEventTouchUpInside];
                    //取消按钮
                    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancelButton.tag = 101;
                    cancelButton.frame = CGRectMake(0, 0, SIZ(50), SIZ(44));
                    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cancelButton addTarget:self action:@selector(selectImageClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.tempView addSubview:imageView];
                    [self.tempView addSubview:bottomView];
                    [bottomView addSubview:enterButton];
                    [bottomView addSubview:cancelButton];

                    [UIView animateWithDuration:0.3 animations:^{
                        self.tempView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
                    }];
                }else{
                    UIView *view = [self.tempView viewWithTag:22];
                    if ([view isKindOfClass:[PZPhotoView class]]) {
                        PZPhotoView *image = (PZPhotoView *)view;
                        [image displayImage:imge];
                    }
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tempView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
                    }];
                }
                [picker.view addSubview:self.tempView];
            }

        }
    }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.videoFile = [NSData dataWithContentsOfFile:videoPath];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
  
}
#pragma mark - SZYPhotoScrollViewClickDelegate

-(void)addPhotoBtnDidClick:(UIButton *)sender{
    [self takePictureClick:sender];
}

-(void)selectPhotoDidClick:(UIButton *)sender{
    UIButton *btn = (UIButton *) sender;
    //1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.photoArray.count];
    for (int i = 0; i < self.photoArray.count; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile:self.photoArray[i]];
        MJPhoto *photo = [[MJPhoto alloc]init];
        photo.image = image;
        [photos addObject:photo];
    }
    //2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]initWithisZQ:YES ToolBarTitle:@"设为头像"];
    browser.currentPhotoIndex = btn.tag;
    browser.photos = photos;
    browser.delegate = self;
    [browser show];
 
}
#pragma mark - MJPhotoBrowserDelegate
- (void)selectImage:(UIImage *)image {
    
    self.imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    self.imageCropVC.delegate = self;
    self.imageCropVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:self.imageCropVC animated:YES completion:nil];
    
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    [self.currentUser saveAvater:croppedImage IsFake:YES];
    self.finalAvater = croppedImage;
    self.avaterImageView.image = croppedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == self.infoNickTextField) {
        if (textField.text.length > 20) {
            //截取20个字符长度
            textField.text = [textField.text substringToIndex:20];
            //弹出提示框
            [self showAlertViewWithTitle:@"提示" WithMessage:@"昵称不能超过20个字"];
            
        }else{
            
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／/：:;<>!'""?|；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
            NSRange range = [textField.text rangeOfCharacterFromSet:set];
            if (range.location != NSNotFound) {
                [self showAlertViewWithTitle:@"提示" WithMessage:@"您的昵称中不能包含特殊字符哦！"];
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
                
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.infoNickTextField) {
        if (textField.text.length < 1) {
            [self showAlertViewWithTitle:@"提示" WithMessage:@"您还没有昵称哦！"];
            return NO;
        }
    }
    //
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self moveView:YES WithFloat:100];  //界面整个上移
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self moveView:NO WithFloat:0];   //界面下移
    return YES;
}

#pragma mark - SZYDatePickViewDelegate

-(void)cancelBtnDidClick{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickView.hidden = YES;
        self.datePickView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, SIZ(180));
    }];
}

-(void)sureBtnDidClick:(NSString *)selectedDate{
    self.birthDay = selectedDate;
    [self.selectBirthBtn setTitle:self.birthDay forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickView.hidden = YES;
        self.datePickView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, SIZ(180));
    }];
}

#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:self.defaultMsg]) {
        textView.text = @"";
    }
    [self moveView:YES WithFloat:180];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.defaultMsg;
    }
    if (textView.text == nil || [textView.text isEqualToString:@""] || [textView.text isEqualToString:self.defaultMsg]) {
        [self moveView:NO WithFloat:0];
        return;
    }
    [self moveView:NO WithFloat:0];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = self.defaultMsg;
        }
        
        [textView resignFirstResponder];
        
    }
    
    
    if (textView.text.length > 180) {
        
        textView.text = [textView.text substringToIndex:179];
        [self showAlertViewWithTitle:@"提示" WithMessage:@"发表的内容要少于180字"];
    }
    return YES;
}

#pragma mark - 响应事件

-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick:(UIButton *)sender{
    
    if (sender.selected) {//点击保
        
        [self enterEditing:NO];
        
        //保存数据
        self.currentUser.user_nickname = self.infoNickTextField.text;
        self.currentUser.user_sex = self.sexSwitch.on ? @"Man":@"Woman";
        [self.currentUser saveAvater:self.finalAvater IsFake:NO];
        [self.currentUser saveImages:self.photoArray IsFake:NO];
        self.currentUser.user_status = self.internalTextView.text;

        ApplicationDelegate.userSession = self.currentUser;
        //固化
        [ApplicationDelegate.userSession solidateDataWithKey:@"user_session"];
        
        [self initData];
        
    }else{ //点击编辑
        [self enterEditing:YES];
        
        [self initData];
    }
    
    
    sender.selected = !sender.selected;
    
}

-(void)enterEditing:(BOOL)isEner{
    //头像
    self.avaterBtn.enabled = isEner;
    //昵称
    self.infoNickTextField.enabled = isEner;
    //生日
    self.selectBirthBtn.enabled = isEner;
    //性别信息
    self.sexSwitch.hidden = !isEner;
    self.sexShowLabel.hidden = isEner;
    //内心独白
    self.internalTextView.editable = isEner;
    self.photoScrollView.addPhotoBtn.hidden = !isEner;
}


-(void)takePictureClick:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 111) {
        self.isAvater = YES;
    }else{
        self.isAvater = NO;
    }
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    
    [actionSheet showInView:self.view];
    
}

-(void)selectImageClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {  //确定
        if (self.tempImage != nil && self.imagePickerVC != nil) {

            [self.photoArray addObject:self.tempImage];
            [self.photoScrollView setPhoto:self.photoArray];
            self.photoNumberLabel.text = [NSString stringWithFormat:@"（%lu/8）",self.photoArray.count];
            
            [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
            [UIView animateWithDuration:0.3 animations:^{
                self.tempView.frame = CGRectMake(0, UIScreenHeight, self.tempView.frame.size.width, self.tempView.frame.size.height);
                [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3];
            }];
        }
    } else {  //取消
        [UIView animateWithDuration:0.2 animations:^{
            self.tempView.frame = CGRectMake(0, UIScreenHeight, self.tempView.frame.size.width, self.tempView.frame.size.height);
            [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3];
        }];
    }
}

- (void)removeView {
    [self.tempView removeFromSuperview];
}

-(void)selectBirthClick:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickView.hidden = NO;
        self.datePickView.frame = CGRectMake(0, UIScreenHeight-SIZ(230), UIScreenWidth, SIZ(180));
    }];
}

-(void)chooseSexClick:(SZYSwitch *)sender{
    
    SZYSwitch *sexSwitch = (SZYSwitch *)sender;
    self.isMan = sexSwitch.on;
    self.isMan ? (self.sexShowLabel.text = @"男") : (self.sexShowLabel.text = @"女");
}

#pragma mark - 私有方法
//移动界面
- (void)moveView:(BOOL)isUp WithFloat:(float)distance {
    if (isUp) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.mainScrollView.contentOffset = CGPointMake(0, SIZ(distance));
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}
//提示框
- (void)showAlertViewWithTitle:(NSString *)alertTitle WithMessage:(NSString *)message {
    
    self.alertView.title = alertTitle ;
    self.alertView.message = message;
    [self.alertView show];
}

#pragma mark - getters and setters

-(UIScrollView *)mainScrollView{
    
    if (_mainScrollView == nil){
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(UIScreenWidth, UIScreenHeight + SIZ(200));
        _mainScrollView.showsVerticalScrollIndicator = NO;
        self.mainScrollView.scrollEnabled = NO;
    }
    return _mainScrollView;
}

#pragma mark  上方面板
-(UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIButton *)rightBtn{
    if (_rightBtn == nil){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"保存" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UIImageView *)backgruondView{
    if (_backgroundView == nil){
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"personal_mengBan@2x"];
        _backgroundView.alpha = 0.4;
    }
    return _backgroundView;
}

-(UIImageView *)blurImageView{
    if (_blurImageView == nil){
        //玻璃图层
        _blurImageView = [[UIImageView alloc]init];
//        _blurImageView.clipsToBounds = YES;
//        [_blurImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _blurImageView;
}

-(UIView *)avaterBottomView{
    if (_avaterBottomView == nil){
        //头像底层
        _avaterBottomView = [[UIView alloc]init];
        _avaterBottomView.backgroundColor = [UIColor whiteColor];
        _avaterBottomView.layer.masksToBounds = YES;
    }
    return _avaterBottomView;
}

-(UIImageView *)avaterImageView{
    if (_avaterImageView == nil){
        //头像
        _avaterImageView = [[UIImageView alloc]init];
        _avaterImageView.layer.masksToBounds = YES;
        _avaterImageView.clipsToBounds = YES;
        _avaterImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avaterImageView;
}
-(UIButton *)avaterBtn{
    if (_avaterBtn == nil){
        _avaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avaterBtn.tag = 111;
        [_avaterBtn addTarget:self action:@selector(takePictureClick:) forControlEvents:UIControlEventTouchUpInside];
        _avaterBtn.enabled = NO;
    }
    return _avaterBtn;
}
-(UILabel *)nickNameLabel{
    if (_nickNameLabel == nil){
        //昵称
        _nickNameLabel = [[UILabel alloc]init];
        /**
         *  1.查看NSUserDefaults中是否有昵称，若有则用偏好中的
         *  2.否则从数据源取
         */
        _nickNameLabel.text = @"孙小原";
        _nickNameLabel.font = FONT_15;
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameLabel;
}
#pragma mark  我的照片
-(UIView *)photoBGView{
    if (_photoBGView == nil){
        _photoBGView = [[UIView alloc]init];
    }
    return _photoBGView;
}
-(UILabel *)photoTitleLabel{
    if (_photoTitleLabel == nil){
        _photoTitleLabel = [[UILabel alloc]init];
        _photoTitleLabel.text = @"我的照片";
        _photoTitleLabel.font = FONT_15;
        _photoTitleLabel.textColor = ThemeColor;
    }
    return _photoTitleLabel;
}
-(UILabel *)photoNumberLabel{
    if (_photoNumberLabel == nil){
        _photoNumberLabel = [[UILabel alloc]init];
        _photoNumberLabel.text = @"（0/8）";
        _photoNumberLabel.textColor = ThemeColor;
        _photoNumberLabel.font = FONT_15;
        _photoNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _photoNumberLabel;
}
-(SZYPhotoScrollView *)photoScrollView{
    if (_photoScrollView == nil){
        _photoScrollView = [[SZYPhotoScrollView alloc]init];
        _photoScrollView.backgroundColor = [UIColor whiteColor];
        _photoScrollView.userInteractionEnabled = YES;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.tag = 100;
        _photoScrollView.aDelegate = self;
        _photoScrollView.addPhotoBtn.hidden = YES;
    }
    return _photoScrollView;
}


#pragma mark  基本信息
-(UIView *)baseInfoBGView{
    if (_baseInfoBGView == nil){
        _baseInfoBGView = [[UIView alloc]init];
    }
    return _baseInfoBGView;
}
-(UIView *)baseInfoWhiteView{
    if (_baseInfoWhiteView == nil){
        _baseInfoWhiteView = [[UIView alloc]init];
        _baseInfoWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _baseInfoWhiteView;
}
-(UILabel *)infoTitleLabel{
    if (_infoTitleLabel == nil){
        _infoTitleLabel = [[UILabel alloc]init];
        _infoTitleLabel.text = @"基本资料";
        _infoTitleLabel.font = FONT_15;
        _infoTitleLabel.textColor = ThemeColor;
    }
    return _infoTitleLabel;
}
-(UILabel *)infoNickLabel{
    if (_infoNickLabel == nil){
        _infoNickLabel = [[UILabel alloc]init];
        _infoNickLabel.font = FONT_14;
        _infoNickLabel.textColor = UIColorFromRGB(0x888888);
        _infoNickLabel.text = @"昵称";
        _infoNickLabel.backgroundColor = [UIColor whiteColor];
    }
    return _infoNickLabel;
}
-(UITextField *)infoNickTextField{
    if (_infoNickTextField == nil){
        _infoNickTextField = [[UITextField alloc]init];
        _infoNickTextField.font = FONT_14;
        _infoNickTextField.textAlignment = NSTextAlignmentRight;
        _infoNickTextField.returnKeyType = UIReturnKeyDone;
        _infoNickTextField.delegate = self;
        _infoNickTextField.tintColor = UIColorFromRGB(0xdddddd);
        _infoNickTextField.textColor = UIColorFromRGB(0x888888);
        [_infoNickTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _infoNickTextField.enabled = NO;
    }
    return _infoNickTextField;
}
-(UILabel *)infoBirthLabel{
    if (_infoBirthLabel == nil){
        _infoBirthLabel = [[UILabel alloc]init];
        _infoBirthLabel.font = FONT_14;
        _infoBirthLabel.textColor = UIColorFromRGB(0x888888);
        _infoBirthLabel.text = @"生日";
        _infoBirthLabel.backgroundColor = [UIColor whiteColor];
    }
    return _infoBirthLabel;
}
-(UIButton *)selectBirthBtn{
    if (_selectBirthBtn == nil){
        _selectBirthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBirthBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        _selectBirthBtn.titleLabel.font = FONT_14;
        _selectBirthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_selectBirthBtn addTarget:self action:@selector(selectBirthClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBirthBtn.enabled = NO;
    }
    return _selectBirthBtn;
}
-(UILabel *)infoSexLabel{
    if (_infoSexLabel == nil){
        _infoSexLabel = [[UILabel alloc]init];
        _infoSexLabel.font = FONT_14;
        _infoSexLabel.textColor = UIColorFromRGB(0x888888);
        _infoSexLabel.text = @"性别";
        _infoSexLabel.backgroundColor = [UIColor whiteColor];
    }
    return _infoSexLabel;
}
-(UILabel *)sexShowLabel{
    if (_sexShowLabel == nil){
        _sexShowLabel = [[UILabel alloc]init];
        _sexShowLabel.textAlignment = NSTextAlignmentRight;
        _sexShowLabel.textColor = UIColorFromRGB(0x888888);
        _sexShowLabel.font = FONT_14;
    }
    return _sexShowLabel;
}
-(SZYSwitch *)sexSwitch{
    if (_sexSwitch == nil){
        _sexSwitch = [[SZYSwitch alloc]init];
        
        UIImage *manImage = [[UIImage imageNamed:@"personal_sex_man"]compressToSize:CGSizeMake(SIZ(16), SIZ(16))];
        _sexSwitch.onImage = manImage;
        UIImage *womanImage = [[UIImage imageNamed:@"personal_sex_woman"] compressToSize:CGSizeMake(SIZ(18.5), SIZ(18.5))];
        _sexSwitch.offImage = womanImage;
        _sexSwitch.isRounded = NO;
        [_sexSwitch addTarget:self action:@selector(chooseSexClick:) forControlEvents:UIControlEventValueChanged];
        _sexSwitch.hidden = YES;
    }
    return _sexSwitch;
}
-(UIView *)infoLine2{
    if (_infoLine2 == nil){
        _infoLine2 = [[UIView alloc]init];
        _infoLine2.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _infoLine2;
}
-(UIView *)infoLine3{
    if (_infoLine3 == nil){
        _infoLine3 = [[UIView alloc]init];
        _infoLine3.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _infoLine3;
}
-(SZYDatePickView *)datePickView{
    if (_datePickView == nil){
        _datePickView = [[SZYDatePickView alloc]init];
        _datePickView.delegate = self;
        _datePickView.hidden = YES;
    }
    return _datePickView;
}
#pragma mark  内心独白
-(UIView *)internalBGView{
    if (_internalBGView == nil){
        _internalBGView = [[UIView alloc]init];
//        _internalBGView.backgroundColor = [UIColor greenColor];
    }
    return _internalBGView;
}

-(UILabel *)internalTitleLabel{
    if (_internalTitleLabel == nil){
        _internalTitleLabel = [[UILabel alloc]init];
        _internalTitleLabel.text = @"内心独白";
        _internalTitleLabel.font = FONT_15;
        _internalTitleLabel.textColor = ThemeColor;
    }
    return _internalTitleLabel;
}

-(UITextView *)internalTextView{
    if (_internalTextView == nil){
        _internalTextView = [[UITextView alloc]init];
        _internalTextView.textColor = UIColorFromRGB(0x888888);
        _internalTextView.backgroundColor = [UIColor whiteColor];
        _internalTextView.font = FONT_14;
        _internalTextView.delegate = self;
        _internalTextView.scrollEnabled = YES;
        _internalTextView.returnKeyType = UIReturnKeyDone;
        _internalTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _internalTextView.editable = NO;
    }
    return _internalTextView;
}



@end
