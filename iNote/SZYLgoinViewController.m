//
//  SZYLgoinViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/13.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYLgoinViewController.h"
#import "SZYMenuButton.h"
#import "UITextField+Validator.h"
#import "AFViewShaker.h"
#import "SZYRegViewController.h"
#import "SZYHomeViewController.h"
#import "SZYUser.h"
#import "NSString+SZYKit.h"
#import "SZYLocalFileManager.h"
#import "SZYNoteBookSolidater.h"
#import "SZYNoteBookModel.h"

static CGFloat const kOffsetLeftHand = 60;

@interface SZYLgoinViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UIImageView  *leftHandImageView;
@property (nonatomic, strong) UIImageView  *rightHandImageView;
@property (nonatomic, strong) UIView       *loginView;
@property (nonatomic, strong) UIImageView  *leftHandGoneImageView;
@property (nonatomic, strong) UIImageView  *rightHandGoneImageView;
@property (nonatomic, strong) UIImageView  *userView;
@property (nonatomic, strong) UIImageView  *pswView;
@property (nonatomic, strong) UITextField  *userTextField;
@property (nonatomic, strong) UITextField  *pswTextField;
@property (nonatomic, strong) UIButton     *loginBtn;
@property (nonatomic, strong) UIButton     *registerBtn;
@property (nonatomic, strong) UIButton     *findPswBtn;
@property (nonatomic, strong) AFViewShaker *userShaker;
@property (nonatomic, strong) AFViewShaker *pswShaker;

@end

@implementation SZYLgoinViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    //设置底色
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.navigationItem.rightBarButtonItem = nil;
    
    //加载组件
    [self.view addSubview:self.headImageView];
    [self.headImageView addSubview:self.leftHandImageView];
    [self.headImageView addSubview:self.rightHandImageView];
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.leftHandGoneImageView];
    [self.view addSubview:self.rightHandGoneImageView];
    [self.loginView addSubview:self.userView];
    [self.loginView addSubview:self.pswView];
    [self.loginView addSubview:self.userTextField];
    [self.loginView addSubview:self.pswTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.findPswBtn];
    
    //加载工具
    self.userShaker = [[AFViewShaker alloc]initWithView:self.userTextField];
    self.pswShaker = [[AFViewShaker alloc]initWithView:self.pswTextField];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //渲染组件
    //猫头鹰视图
    CGFloat imgLoginW = SIZ(211);
    CGFloat imgLoginH = SIZ(109);
    CGFloat imgLoginX = (UIScreenWidth - imgLoginW)/2;
    CGFloat imgLoginY = SIZ(15);
    self.headImageView.frame = CGRectMake(imgLoginX, imgLoginY, imgLoginW, imgLoginH);
    //左手，右手
    CGFloat handW = SIZ(40);
    CGFloat handH = SIZ(65);
    CGFloat handY = SIZ(90);
    self.leftHandImageView.frame = CGRectMake(self.headImageView.frame.size.width/2-kOffsetLeftHand-handW, handY, handW, handH);
    self.rightHandImageView.frame = CGRectMake(self.headImageView.frame.size.width/2+kOffsetLeftHand, handY, handW, handH);
    //登录视图
    self.loginView.frame = CGRectMake(SIZ(15), SIZ(115), UIScreenWidth - SIZ(30), SIZ(110));
    //消失左右手
    CGFloat handGoneW = SIZ(40);
    CGFloat handGoneH = SIZ(40);
    CGFloat handGoneY = self.loginView.frame.origin.y - SIZ(22);
    self.leftHandGoneImageView.frame = CGRectMake(UIScreenWidth/2-kOffsetLeftHand-handGoneW, handGoneY, handGoneW, handGoneH);
    self.rightHandGoneImageView.frame = CGRectMake(UIScreenWidth/2+kOffsetLeftHand, handGoneY, handGoneW, handGoneH);
    //输入框图层
    CGFloat inputViewX = SIZ(15);
    CGFloat inputViewW = self.loginView.frame.size.width - 2 * inputViewX;
    CGFloat inputViewH = SIZ(44);
    self.userView.frame = CGRectMake(inputViewX, 0, inputViewW, inputViewH);
    self.pswView.frame = CGRectMake(inputViewX, CGRectGetMaxY(self.userView.frame)+SIZ(10), inputViewW, inputViewH);
    //输入框
    CGFloat textFieldX = SIZ(20);
    CGFloat textFieldW = self.loginView.frame.size.width - 2*textFieldX;
    CGFloat textFieldMarginY = SIZ(2);
    CGFloat textFieldH = inputViewH - 2 *textFieldMarginY;
    self.userTextField.frame = CGRectMake(textFieldX, textFieldMarginY, textFieldW, textFieldH);
    self.pswTextField.frame = CGRectMake(textFieldX, self.pswView.frame.origin.y+textFieldMarginY, textFieldW, textFieldH);
    //登录按钮
    self.loginBtn.frame = CGRectMake(SIZ(30), CGRectGetMaxY(self.loginView.frame)+SIZ(5), UIScreenWidth-SIZ(60), SIZ(44));
    //注册按钮
    self.registerBtn.frame = CGRectMake(SIZ(35), CGRectGetMaxY(self.loginBtn.frame) + SIZ(8), SIZ(60), SIZ(30));
    //找回密码按钮
    self.findPswBtn.frame = CGRectMake(UIScreenWidth - SIZ(95), CGRectGetMaxY(self.loginBtn.frame) + SIZ(8), SIZ(60), SIZ(30));
}

#pragma mark - TextFielDgelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.pswTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.pswTextField) {
        [self oweShyStatus];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.pswTextField) {
        [self oweLookStatus];
    }
}

#pragma mark - 私有方法

-(void)leftMenuClick{
    [super leftMenuClick];
    
    [self.pswTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    
}

-(void)oweLookStatus{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.leftHandImageView.transform = CGAffineTransformIdentity;
        self.rightHandImageView.transform = CGAffineTransformIdentity;
        self.leftHandGoneImageView.transform = CGAffineTransformIdentity;
        self.rightHandGoneImageView.transform = CGAffineTransformIdentity;
    }];
}

-(void)oweShyStatus{
    [UIView animateWithDuration:0.5 animations:^{
        
        //仅平移
        self.leftHandImageView.transform = CGAffineTransformMakeTranslation(SIZ(55), - SIZ(30));
        self.rightHandImageView.transform = CGAffineTransformMakeTranslation(-SIZ(48),- SIZ(30));
        //平移同时缩小
        self.leftHandGoneImageView.transform = CGAffineTransformMakeTranslation(50, -10);
        self.rightHandGoneImageView.transform = CGAffineTransformMakeTranslation(-30, -10);
        self.leftHandGoneImageView.transform = CGAffineTransformScale(self.leftHandGoneImageView.transform, 0.01, 0.01);
        self.rightHandGoneImageView.transform = CGAffineTransformScale(self.rightHandGoneImageView.transform, 0.01, 0.01);
    }];
}

#pragma mark - 响应事件

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.pswTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    
}

//点击登陆
-(void)loginClick{
    
    BOOL valide = [self.userTextField isNotEmpty];
    
    if (valide) {
        valide = [self.pswTextField isNotEmpty];
    }else{
        [self.userShaker shake];
        return;
    }
    if (valide) {
        valide = [self.userTextField validateUserName];
    }else{
        [self.pswShaker shake];
        return;
    }
    if (valide) {
        valide = [self.pswTextField validatePassWord];
    }else{
        [self showMessage:@"请输入11位有效手机号" becomeFirstResponder:self.userTextField];
        return;
    }
    if (valide) {
        
        //服务器验证账号，密码合法性。返回完整的账号信息
        
        //加载当前帐号的资源，自发的网络同步过程
        
        //修改本地所有相关个人信息的设置
        
        NSLog(@"验证成功");
        //更新本地用户文件系统
        [self refreshUpLocalInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHaveLogIn" object:nil];
        
    }else{
        [self showMessage:@"请输入6～20位密码" becomeFirstResponder:self.pswTextField];
        return;
    }
}

//更新本地文件夹信息
-(void)refreshUpLocalInfo
{
    SZYUser *user = [[SZYUser alloc]initWithPhoneNumber:self.userTextField.text AndUserID:[NSString stringOfUUID]];
    ApplicationDelegate.userSession = user;
    [ApplicationDelegate.userSession solidateDataWithKey:UDUserSession];
    //为新用户创建本地一级目录
    [[SZYLocalFileManager sharedInstance] setUpLocalFileDir:kUserFolderType];
    ApplicationDelegate.isLoggedin = YES;
    [self createDefaultNoteBook];
}

//创建默认笔记本
-(void)createDefaultNoteBook
{
    SZYNoteBookSolidater *solidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
    SZYNoteBookModel *defaultNoteBook = [[SZYNoteBookModel alloc]initWithID:kDEFAULT_NOTEBOOK_ID Title:@"默认笔记本" UserID:ApplicationDelegate.userSession.user_id IsPrivate:@"NO"];
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        [solidater saveOne:defaultNoteBook successHandler:^(id result) {
            
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"error = %@",errorMsg);
        }];
    }];
}

-(void)showMessage:(NSString *)msg becomeFirstResponder:(UITextField *)textField{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [textField becomeFirstResponder];
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:alertVC completion:nil];
}

//点击注册
-(void)registerClick{
    
    SZYRegViewController *regVC = [[SZYRegViewController alloc]initWithTitle:@"注册" BackButton:YES];
    [self.navigationController pushViewController:regVC animated:YES];
}

//找回密码
-(void)findPswClick{
    
    NSLog(@"找回密码");
}


#pragma mark - getters
-(UIImageView *)headImageView{
    if (!_headImageView){
        _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owl-login"]];
        //隐藏边界，消除阴影
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}
-(UIImageView *)leftHandImageView{
    if (!_leftHandImageView){
        _leftHandImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owl-login-arm-left"]];
    }
    return _leftHandImageView;
}
-(UIImageView *)rightHandImageView{
    if (!_rightHandImageView){
        _rightHandImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owl-login-arm-right"]];
    }
    return _rightHandImageView;
}
-(UIView *)loginView{
    if (!_loginView){
        _loginView = [[UIView alloc]init];
        _loginView.backgroundColor = self.view.backgroundColor;
//        _loginView.backgroundColor = [UIColor orangeColor];
    }
    return _loginView;
}
-(UIImageView *)leftHandGoneImageView{
    if (!_leftHandGoneImageView){
        _leftHandGoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_hand"]];
    }
    return _leftHandGoneImageView;
}
-(UIImageView *)rightHandGoneImageView{
    if (!_rightHandGoneImageView){
        _rightHandGoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_hand"]];
    }
    return _rightHandGoneImageView;
}

-(UIImageView *)userView{
    if (!_userView){
        _userView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
    }
    return _userView;
}
-(UIImageView *)pswView{
    if (!_pswView){
        _pswView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
    }
    return _pswView;
}

-(UITextField *)userTextField{
    if (!_userTextField){
        _userTextField = [[UITextField alloc]init];
        _userTextField.delegate = self;
        _userTextField.placeholder = @"手机号";
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userTextField.keyboardType = UIKeyboardTypePhonePad;
        //左侧图层
        _userTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZ(40), SIZ(40))];
        _userTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 16, 16)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_userTextField.leftView addSubview:imgUser];
    }
    return _userTextField;
}

-(UITextField *)pswTextField{
    if (!_pswTextField){
        _pswTextField = [[UITextField alloc]init];
        _pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pswTextField.delegate = self;
        _pswTextField.placeholder = @"密码";
        _pswTextField.secureTextEntry = YES;
        _pswTextField.returnKeyType = UIReturnKeyDone;
        //左侧图层
        _pswTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZ(40), SIZ(40))];
        _pswTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
        [_pswTextField.leftView addSubview:imgPwd];
    }
    return _pswTextField;
}

-(UIButton *)loginBtn{
    if (!_loginBtn){
        _loginBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登   陆" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn){
        _registerBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"我是新手" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = FONT_13;
        [_registerBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _registerBtn;
}

-(UIButton *)findPswBtn{
    if (!_findPswBtn){
        _findPswBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        [_findPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _findPswBtn.titleLabel.font = FONT_13;
        [_findPswBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_findPswBtn addTarget:self action:@selector(findPswClick) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _findPswBtn;
}

@end
