//
//  SZYRegViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/13.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYRegViewController.h"
#import "SZYInputText.h"
#import "SZYMenuButton.h"
#import "AFViewShaker.h"
#import "UITextField+Validator.m"



@interface SZYRegViewController ()<UITextFieldDelegate>
//注册按钮
@property (nonatomic, strong) UIButton     *regBtn;
//输入框
@property (nonatomic, strong) UITextField  *phoneTextField;
@property (nonatomic, strong) UITextField  *nickNameTextField;
@property (nonatomic, strong) UITextField  *pswregTextField;
@property (nonatomic, strong) UITextField  *pswConfirmTextField;
@property (nonatomic,strong ) UIImageView  *phoneView;
@property (nonatomic,strong ) UIImageView  *nickNameView;
@property (nonatomic,strong ) UIImageView  *pswregView;
@property (nonatomic,strong ) UIImageView  *pswConfirmView;
@property (nonatomic,strong ) UIView       *regView;
//震动
@property (nonatomic,strong ) AFViewShaker  *phoneShaker;
@property (nonatomic,strong ) AFViewShaker  *nickNameShaker;
@property (nonatomic,strong ) AFViewShaker  *pswregShaker;
@property (nonatomic,strong ) AFViewShaker  *pswConfirmShaker;

@end

@implementation SZYRegViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil ;
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    
    // 加载组件
    
    [self.view addSubview:self.regView];
    [self.regView addSubview:self.regBtn];
    [self.regView addSubview:self.phoneTextField];
    [self.regView addSubview:self.pswTextField];
    [self.regView addSubview:self.nickNameTextField];
    [self.regView addSubview:self.phoneView];
    [self.regView addSubview:self.nickNameView];
    [self.regView addSubview:self.pswregView];
    [self.regView addSubview:self.pswConfirmView];
    [self.regView addSubview:self.pswConfirmTextField];
    
    self.phoneShaker = [[AFViewShaker alloc]initWithView:self.phoneTextField];
    self.nickNameShaker = [[AFViewShaker alloc]initWithView:self.nickNameTextField];
    self.pswregShaker = [[AFViewShaker alloc]initWithView:self.pswregTextField];
    self.pswConfirmShaker = [[AFViewShaker alloc]initWithView:self.pswConfirmTextField];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //注册底层图层
    self.regView.frame = CGRectMake(25, 20, UIScreenWidth - 50, 300);
    //输入框边框图层
    CGFloat inputViewX = 15;
    CGFloat inputViewW = self.regView.frame.size.width - 2 * inputViewX ;
    CGFloat inputViewH = 44;
    self.phoneView.frame = CGRectMake(inputViewX, 10, inputViewW, inputViewH);
    self.nickNameView.frame = CGRectMake(inputViewX,CGRectGetMaxY(self.phoneView.frame)+10, inputViewW, inputViewH);
    self.pswregView.frame = CGRectMake(inputViewX, CGRectGetMaxY(self.nickNameView.frame)+10, inputViewW, inputViewH);
    self.pswConfirmView.frame = CGRectMake(inputViewX, CGRectGetMaxY(self.pswregView.frame)+10, inputViewW, inputViewH);
    //输入框
    CGFloat textFieldX = 20;
    CGFloat textFieldW = self.regView.frame.size.width - 2 * textFieldX ;
    CGFloat textFieldMarginY = 12;
    CGFloat jiange = 2;
    CGFloat textFieldH = inputViewH - 2 * jiange;
    self.phoneTextField.frame = CGRectMake(textFieldX, textFieldMarginY, textFieldW, textFieldH);
    self.nickNameTextField.frame = CGRectMake(textFieldX, self.nickNameView.frame.origin.y+jiange, textFieldW, textFieldH);
    self.pswregTextField.frame = CGRectMake(textFieldX, self.pswregView.frame.origin.y+jiange, textFieldW, textFieldH);
    self.pswConfirmTextField.frame = CGRectMake(textFieldX, self.pswConfirmView.frame.origin.y+jiange, textFieldW, textFieldH);
    //注册按钮
    self.regBtn.frame = CGRectMake((self.regView.frame.size.width-textFieldW)/2, CGRectGetMaxY(self.pswConfirmView.frame)+30, textFieldW, 44);
    
    
}
#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideRegKeyboard];
    return YES;
}

#pragma mark - 响应方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideRegKeyboard];
}
-(void)hideRegKeyboard{
    [self.phoneTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    [self.pswregTextField resignFirstResponder];
    [self.pswConfirmTextField resignFirstResponder];
    
}
-(void)regClick{
    BOOL valide = [self.phoneTextField isNotEmpty];
    if (valide) {
        valide = [self.nickNameTextField isNotEmpty];
    }else{
        [self.phoneShaker shake];
        return;
    }
    if (valide) {
        valide = [self.pswregTextField isNotEmpty];
    }else{
        [self.nickNameShaker shake];
        return;
    }
    if (valide) {
        valide = [self.pswConfirmTextField isNotEmpty];
    }else{
        [self.pswregShaker shake];
        return;
    }
    if (valide) {
        valide = [self.phoneTextField validatePhoneNumber];
    }else{
        [self.pswConfirmShaker shake];
        return;
    }
    if (valide) {
        valide = [self.pswregTextField validatePassWord];
    }else{
        [self showRegMessage:@"请输入11位有效手机号码" becomeFirstResponder:self.phoneTextField];
        return;
    }
    if (valide) {
        if ([self.pswregTextField.text isEqualToString: self.pswConfirmTextField.text]) {
            [self showRegMessage:@"注册成功！请返回到登录界面进行登录" becomeFirstResponder:nil];
        }else{
            [self showRegMessage:@"两次输入密码不一致，请重新进行密码设置" becomeFirstResponder:self.pswConfirmTextField];
            return;
        }
    }else{
        [self showRegMessage:@"请输入6～20位密码" becomeFirstResponder:self.pswregTextField];
        return;
    }
    
}
-(void)showRegMessage:(NSString *)msg becomeFirstResponder:(UITextField *) textField{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (textField) {
            [textField becomeFirstResponder];
        }
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - getters
-(UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.delegate = self ;
        _phoneTextField.placeholder = @"请输入注册手机号码";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        //左侧图层
        _phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 16, 16)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_phoneTextField.leftView addSubview:imgUser];
    }
    return _phoneTextField;
}
-(UITextField *)nickNameTextField{
    if (!_nickNameTextField) {
        _nickNameTextField = [[UITextField alloc]init];
        _nickNameTextField.delegate = self ;
        _nickNameTextField.placeholder = @"请输入昵称";
        _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameTextField.returnKeyType = UIReturnKeyNext;
        //左侧图层
        _nickNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 16, 16)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_nickNameTextField.leftView addSubview:imgUser];
    }
    return _nickNameTextField;
}
-(UITextField *)pswTextField{
    if (!_pswregTextField) {
        _pswregTextField = [[UITextField alloc]init];
        _pswregTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pswregTextField.delegate = self ;
        _pswregTextField.placeholder = @"请设置您的密码";
        _pswregTextField.secureTextEntry = YES;
        _pswregTextField.returnKeyType = UIReturnKeyNext;
        //左侧图层
        _pswregTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _pswregTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imgUser.image = [UIImage imageNamed:@"iconfont-password"];
        [_pswregTextField.leftView addSubview:imgUser];
    }
    return  _pswregTextField;
}
-(UITextField *)pswConfirmTextField{
    if (!_pswConfirmTextField) {
        _pswConfirmTextField = [[UITextField alloc]init];
        _pswConfirmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pswConfirmTextField.delegate = self ;
        _pswConfirmTextField.placeholder = @"请确认您的密码";
        _pswConfirmTextField.secureTextEntry = YES;
        _pswConfirmTextField.returnKeyType = UIReturnKeyDone;
        //左侧图层
        _pswConfirmTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _pswConfirmTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imgUser.image = [UIImage imageNamed:@"iconfont-password"];
        [_pswConfirmTextField.leftView addSubview:imgUser];
    }
    return  _pswConfirmTextField;
}
-(UIButton *)regBtn{
    if (!_regBtn) {
        _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_regBtn setTitle:@"注   册" forState:UIControlStateNormal];
        [_regBtn addTarget:self action:@selector(regClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _regBtn;
}
-(UIView *)regView{
    if (!_regView) {
        _regView = [[UIView alloc]init];
        _regView.backgroundColor = self.view.backgroundColor;
        //   _regView.backgroundColor = [UIColor grayColor];
        
    }
    return _regView;
}
-(UIImageView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
        
    }
    return _phoneView;
}
-(UIImageView *)nickNameView{
    if (!_nickNameView) {
        _nickNameView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
        
    }
    return _nickNameView;
}
-(UIImageView *)pswregView{
    if (!_pswregView) {
        _pswregView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
        
    }
    return _pswregView;
}
-(UIImageView *)pswConfirmView{
    if (!_pswConfirmView) {
        _pswConfirmView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_input"]];
        
    }
    return _pswConfirmView;
}

@end
