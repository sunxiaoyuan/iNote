//
//  SZYPCViewController.m
//  iNote
//
//  Created by Develop on 16/3/2.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYPCViewController.h"
#import "SZYPersonalCenterTableViewCell.h"
#import "UIAlertController+SZYKit.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SZYDatePickView.h"
#import "UIImage+Size.h"


@interface SZYPCViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,SZYDatePickViewDelegate>

@property (nonatomic ,strong) UITableView                 *mainTableView;
@property (nonatomic ,strong) SZYBaseInfoTableViewCell    *baseInfoCell;
@property (nonatomic ,strong) SZYInnerStatusTableViewCell *innerStatusCell;
@property (nonatomic ,strong) UIView                      *headerView;
@property (nonatomic ,strong) UIImageView                 *blurImageView;
@property (nonatomic ,strong) UIButton                    *avaterBtn;
@property (nonatomic ,strong) UIButton                    *rightBtn;
@property (nonatomic ,strong) SZYDatePickView             *datePickView;
@property (nonatomic ,assign) BOOL                        isMan;
@property (nonatomic ,strong) UIImage                     *finalAvater;
@property (nonatomic ,strong) UIVisualEffectView          *blurView;

@end

@implementation SZYPCViewController
{
    CGRect initFrame;
    CGFloat defaultViewHeight;
    CGPoint headImageCenter;
    NSString *defaultInnerStatus;
    NSString *selectBirthDay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaultInnerStatus = @"这家伙很懒,什么都不想说";
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.mainTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mainTableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-64);
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, UIScreenWidth, 35);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = FONT_13;
    titleLabel.frame = CGRectMake(10, 5, 75, bgView.height-10);
    titleLabel.textColor = ThemeColor;
    [bgView addSubview:titleLabel];
    switch (section) {
        case 0:
            titleLabel.text = @"基本资料";
            break;
        case 1:
            titleLabel.text = @"个性签名";
            break;
        default:
            break;
    }
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"SZYBaseInfoTableViewCell";
            self.baseInfoCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!self.baseInfoCell) {
                self.baseInfoCell = [[SZYBaseInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                self.baseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.baseInfoCell.backgroundColor = [UIColor whiteColor];
                self.baseInfoCell.nickNameTF.delegate = self;
                [self.baseInfoCell.nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.baseInfoCell.selectBirthBtn addTarget:self action:@selector(selectBirthClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.baseInfoCell.manBtn addTarget:self action:@selector(chooseGenderClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.baseInfoCell.womanBtn addTarget:self action:@selector(chooseGenderClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return self.baseInfoCell;
            break;
        }
        case 1:
        {
            static NSString *cellIdentifier = @"SZYInnerStatusTableViewCell";
            self.innerStatusCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!self.innerStatusCell) {
                self.innerStatusCell = [[SZYInnerStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                self.innerStatusCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.innerStatusCell.backgroundColor = [UIColor whiteColor];
                self.innerStatusCell.internalTextView.delegate = self;
            }
            return self.innerStatusCell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    switch (indexPath.section) {
        case 0:
            cellHeight = 150;
            break;
        case 1:
            cellHeight = 100;
            break;
        default:
            break;
    }
    return cellHeight;
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]){
        
        UIImage *imge = [info objectForKey:UIImagePickerControllerEditedImage];
        self.finalAvater = imge;
        //改变界面头像图片
        self.blurImageView.image = [self.finalAvater compressToSize:CGSizeMake(UIScreenWidth, 168)];
        [self.avaterBtn setBackgroundImage:imge forState:UIControlStateNormal];
        [self.avaterBtn setBackgroundImage:imge forState:UIControlStateDisabled];
        [picker dismissViewControllerAnimated:YES completion:nil];
            
    }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        //截取20个字符长度
        textField.text = [textField.text substringToIndex:20];
        //弹出提示框
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"昵称不能超过20个字" cancelTitle:@"好的" cancelHandler:^{
            
        }];
        
    }else{
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／/：:;<>!'""?|；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        NSRange range = [textField.text rangeOfCharacterFromSet:set];
        if (range.location != NSNotFound) {
            
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
            
            [UIAlertController showAlertAtViewController:self title:@"提示" message:@"您的昵称中不能包含特殊字符哦！" cancelTitle:@"好的" cancelHandler:^{
                
            }];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length < 1) {
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"您还没有昵称哦！" cancelTitle:@"好的" cancelHandler:^{
            
        }];
        return NO;
    }
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

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //获得光标，立即清除默认内容
    if ([textView.text isEqualToString:defaultInnerStatus]) {
        textView.text = @"";
    }
    [self moveView:YES WithFloat:100];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //结束输入后，检测如果没有输入，那么给一个默认字符串
    if ([textView.text isEqualToString:@""]) {
        textView.text = defaultInnerStatus;
    }
    if (textView.text == nil || [textView.text isEqualToString:@""] || [textView.text isEqualToString:defaultInnerStatus]) {
        [self moveView:NO WithFloat:0];
        return;
    }
    [self moveView:NO WithFloat:0];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = defaultInnerStatus;
        }
        [textView resignFirstResponder];
    }
    if (textView.text.length > 50) {
        
        textView.text = [textView.text substringToIndex:49];
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"发表的内容要少于50字" cancelTitle:@"好的" cancelHandler:^{
        }];
    }
    return YES;
}

#pragma mark - SZYDatePickViewDelegate

-(void)cancelBtnDidClick
{
    self.baseInfoCell.selectBirthBtn.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.datePickView removeFromSuperview];
        self.datePickView = nil;
    }];
}

-(void)sureBtnDidClick:(NSString *)selectedDate
{
    selectBirthDay = selectedDate;
    [self.baseInfoCell.selectBirthBtn setTitle:selectBirthDay forState:UIControlStateNormal];
    [self cancelBtnDidClick];
}

#pragma mark - 移动界面
- (void)moveView:(BOOL)isUp WithFloat:(float)distance {
    if (isUp) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.mainTableView.contentOffset = CGPointMake(0, SIZ(distance));
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.mainTableView.contentOffset = CGPointMake(0, 0);
        }];
    }
}

#pragma mark - 顶部动画
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
    if (scrollView.contentOffset.y < 0) {
        initFrame.origin.x = - offset/2;
        initFrame.origin.y = - offset;
        initFrame.size.width = _mainTableView.frame.size.width+offset;
        initFrame.size.height = defaultViewHeight+offset;
        _blurImageView.frame = initFrame;
        _blurView.frame = initFrame;
        
        _avaterBtn.frame = CGRectMake(0, 0, 110+offset/5, 110+offset/5);
        _avaterBtn.center = CGPointMake(headImageCenter.x, headImageCenter.y);
        // 保证动画过程中，不会发生形变
        _avaterBtn.layer.cornerRadius = _avaterBtn.width/2;
    }
}

#pragma mark - 右上角编辑/保存按钮点击事件
-(void)rightBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //点击“编辑”
        [self enterEditing:YES];
    }
    else{
        //点击“保存”
        
        ApplicationDelegate.userSession.user_nickname = self.baseInfoCell.nickNameTF.text;
        ApplicationDelegate.userSession.user_sex = self.isMan ? @"男" : @"女";
        ApplicationDelegate.userSession.user_status = self.innerStatusCell.internalTextView.text;
        ApplicationDelegate.userSession.user_birth = self.baseInfoCell.selectBirthBtn.titleLabel.text;
        [ApplicationDelegate.userSession saveAvater:self.finalAvater];
        //固化
        [ApplicationDelegate.userSession solidateDataWithKey:UDUserSession];
        
        //刷新侧边栏头像
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveSetAvater" object:nil];
        
        [self enterEditing:NO];
    }
}

-(void)enterEditing:(BOOL)isEnter
{
    //头像
    self.avaterBtn.enabled = isEnter;
    //昵称
    self.baseInfoCell.nickNameTF.enabled = isEnter;
    //生日
    self.baseInfoCell.selectBirthBtn.enabled = isEnter;
    //性别
    self.baseInfoCell.genderShowBtn.hidden = isEnter;
    [self.baseInfoCell.genderShowBtn setTitle:ApplicationDelegate.userSession.user_sex forState:UIControlStateNormal];

    self.baseInfoCell.womanBtn.hidden = !isEnter;
    self.baseInfoCell.manBtn.hidden = !isEnter;
    if ([ApplicationDelegate.userSession.user_sex isEqualToString:@"男"]) {
        self.baseInfoCell.manBtn.selected = YES;
        self.baseInfoCell.womanBtn.selected = NO;
    }
    else{
        self.baseInfoCell.manBtn.selected = NO;
        self.baseInfoCell.womanBtn.selected = YES;
    }
    //个性签名
    self.innerStatusCell.internalTextView.editable = isEnter;
}

#pragma mark - 收起键盘
-(void)hideKeyboard
{
    [self.baseInfoCell.nickNameTF resignFirstResponder];
    [self.innerStatusCell.internalTextView resignFirstResponder];
}

#pragma mark - 点击头像事件
-(void)avaterBtnClick
{
    [self showActionSheet:YES];
}

#pragma mark - 弹出图片选择视图
-(void)showActionSheet:(BOOL)isAvater
{
    [UIAlertController showAlertSheetAtViewController:self cancelHandler:^{
        // do nothing
    } cameraHandler:^{
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } alburmHandler:^{
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        [imagePicker.navigationBar setBarTintColor:ThemeColor];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
}

#pragma mark - 选择生日点击事件
-(void)selectBirthClick:(UIButton *)sender
{
    self.baseInfoCell.selectBirthBtn.enabled = NO;
    [self.mainTableView addSubview:self.datePickView];
    self.datePickView.frame = CGRectMake(0, UIScreenHeight-64, UIScreenWidth, 180);
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickView.transform = CGAffineTransformMakeTranslation(0, -175);
    }];
}

#pragma mark - 选择性别按钮
-(void)chooseGenderClick:(UIButton *)sender
{
    if (sender == self.baseInfoCell.manBtn) {
        self.baseInfoCell.manBtn.selected = YES;
        self.baseInfoCell.womanBtn.selected = NO;
        self.isMan = YES;
    }
    else if (sender == self.baseInfoCell.womanBtn){
        self.baseInfoCell.manBtn.selected = NO;
        self.baseInfoCell.womanBtn.selected = YES;
        self.isMan = NO;
    }
}

#pragma mark - getters

-(UITableView *)mainTableView{
    if (!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
        [_mainTableView addGestureRecognizer:tap];
        
        _headerView = [[UIView alloc]init];
        _headerView.clipsToBounds = NO;
        _headerView.frame = CGRectMake(0, 0, UIScreenWidth, 168);
        
        //模糊视图层
        _blurImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, _headerView.height)];
        _blurImageView.image = [UIImage imageNamed:@"personal_center_bg"];
        _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurImageView.userInteractionEnabled = NO;
        [_headerView addSubview:_blurImageView];
        initFrame = _blurImageView.frame;
        defaultViewHeight = initFrame.size.height;
        
        //磨砂图层
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _blurView.frame = CGRectMake(0, 0, UIScreenWidth, _headerView.height);
        _blurView.alpha = 0.9;
        [_headerView addSubview:_blurView];
        
        //头像
        _avaterBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _avaterBtn.centerX = _headerView.centerX;
        _avaterBtn.centerY = _headerView.centerY;
        _avaterBtn.enabled = NO;
        
        //注意这里要设置两种状态下的图片
        if (!ApplicationDelegate.userSession.head_portrait_url || [ApplicationDelegate.userSession.head_portrait_url isEqualToString:@""]) {
            [_avaterBtn setBackgroundImage:[UIImage imageNamed:@"icon_default_head"] forState:UIControlStateDisabled];
            [_avaterBtn setBackgroundImage:[UIImage imageNamed:@"icon_default_head"] forState:UIControlStateNormal];
            [_blurImageView setImage:[[UIImage imageNamed:@"icon_default_head"] compressToSize:CGSizeMake(UIScreenWidth, 168)]];
        }
        else{
            [_avaterBtn setBackgroundImage:[ApplicationDelegate.userSession avaterAtLocal] forState:UIControlStateDisabled];
            [_avaterBtn setBackgroundImage:[ApplicationDelegate.userSession avaterAtLocal] forState:UIControlStateNormal];
            [_blurImageView setImage:[[ApplicationDelegate.userSession avaterAtLocal] compressToSize:CGSizeMake(UIScreenWidth, 168)]];
        }
        [_avaterBtn addTarget:self action:@selector(avaterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _avaterBtn.layer.masksToBounds = YES;
        _avaterBtn.clipsToBounds = YES;
        _avaterBtn.layer.cornerRadius = _avaterBtn.width/2;
        _avaterBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
        _avaterBtn.layer.borderWidth = 1.2f;
        [_headerView addSubview:_avaterBtn];
        headImageCenter = CGPointMake(_avaterBtn.centerX, _avaterBtn.centerY);
        
        _mainTableView.tableHeaderView = _headerView;
    }
    return _mainTableView;
}

-(UIButton *)rightBtn{
    if (!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 40, 40);
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"保存" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(SZYDatePickView *)datePickView{
    if (_datePickView == nil){
        _datePickView = [[SZYDatePickView alloc]init];
        _datePickView.delegate = self;
    }
    return _datePickView;
}

@end
