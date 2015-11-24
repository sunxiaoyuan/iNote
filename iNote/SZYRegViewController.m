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



//输入框
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *nickNameTextField;
@property (nonatomic, strong) UITextField *pswTextField;
@property (nonatomic, strong) UITextField *pswConfirmTextField;
//输入框名称
@property (nonatomic, strong) UILabel     *phoneLabel;
@property (nonatomic, strong) UILabel     *nickNameLabel;
@property (nonatomic, strong) UILabel     *pswLabel;
@property (nonatomic, strong) UILabel     *pswConfirmLabel;
//注册按钮
@property (nonatomic, strong) UIButton    *regBtn;
//是否有输入
@property (nonatomic, assign) BOOL        isChanged;


@end

@implementation SZYRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    //去掉右上角按钮
    self.navigationItem.rightBarButtonItem = nil;
    //初始化UI
    [self setUP];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneTextField) {
        return [_nickNameTextField becomeFirstResponder];
    }else if (textField == _nickNameTextField){
        return [_pswTextField becomeFirstResponder];
    }else if (textField == _pswTextField){
        return [_pswConfirmTextField becomeFirstResponder];
    }else{
        [self restoreTextFieldName:_pswConfirmLabel textField:_pswConfirmTextField];
        return [_pswConfirmTextField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _phoneTextField) {
        
        [self diminishTextFieldName:_phoneLabel];
        [self restoreTextFieldName:_nickNameLabel textField:_nickNameTextField];
        [self restoreTextFieldName:_pswLabel textField:_pswTextField];
        [self restoreTextFieldName:_pswConfirmLabel textField:_pswConfirmTextField];
        
    }else if (textField == _nickNameTextField){
        
        [self restoreTextFieldName:_phoneLabel textField:_phoneTextField];
        [self diminishTextFieldName:_nickNameLabel];
        [self restoreTextFieldName:_pswLabel textField:_pswTextField];
        [self restoreTextFieldName:_pswConfirmLabel textField:_pswConfirmTextField];
        
    }else if (textField == _pswTextField){
        
        [self restoreTextFieldName:_phoneLabel textField:_phoneTextField];
        [self restoreTextFieldName:_nickNameLabel textField:_nickNameTextField];
        [self diminishTextFieldName:_pswLabel];
        [self restoreTextFieldName:_pswConfirmLabel textField:_pswConfirmTextField];

    }else if (textField == _pswConfirmTextField){
        
        [self restoreTextFieldName:_phoneLabel textField:_phoneTextField];
        [self restoreTextFieldName:_nickNameLabel textField:_nickNameTextField];
        [self restoreTextFieldName:_pswLabel textField:_pswTextField];
        [self diminishTextFieldName:_pswConfirmLabel];
        
    }
    return YES;
}

- (void)diminishTextFieldName:(UILabel *)label{
    
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -SIZ(17));
        label.textColor = ThemeColor;
        label.font = FONT_10;
    }];
}

- (void)restoreTextFieldName:(UILabel *)label textField:(UITextField *)textFieled{
    //检查将要改变的输入框内，是否有文本
    [self checkTextFieldChange:textFieled];
    if (self.isChanged) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.textColor = [UIColor grayColor];
            label.font = FONT_16;
        }];
    }
}

- (void)checkTextFieldChange:(UITextField *)textField{
    if (textField.text.length != 0) {
        self.isChanged = NO;
    } else {
        self.isChanged = YES;
    }
}

#pragma mark - 点击空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self restoreTextFieldName:_phoneLabel textField:_phoneTextField];
    [self restoreTextFieldName:_nickNameLabel textField:_nickNameTextField];
    [self restoreTextFieldName:_pswLabel textField:_pswTextField];
    [self restoreTextFieldName:_pswConfirmLabel textField:_pswConfirmTextField];
}
#pragma mark - 私有方法



-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUP{
    
    
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(SIZ(15), SIZ(50), UIScreenWidth - SIZ(30), SIZ(300))];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.cornerRadius = 8;
    vLogin.layer.masksToBounds = YES;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    
    SZYInputText *inputText = [[SZYInputText alloc]init];
    CGFloat centerX = vLogin.frame.size.width /2;
    
    //手机号
    _phoneTextField = [inputText setupWithIcon:nil textY:SIZ(20) centerX:centerX point:nil];
    _phoneTextField.delegate = self;
    [_phoneTextField setReturnKeyType:UIReturnKeyNext];
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneTextField.textColor = [UIColor grayColor];
    _phoneTextField.tintColor = [UIColor grayColor];
    [vLogin addSubview:_phoneTextField];
    _phoneLabel = [self setupTextName:@"手机号" OnTextField:_phoneTextField];
    [_phoneTextField addSubview:_phoneLabel];
    
    //昵称
    _nickNameTextField = [inputText setupWithIcon:nil textY:CGRectGetMaxY(_phoneTextField.frame)+SIZ(20) centerX:centerX point:nil];
    _nickNameTextField.delegate = self;
    [_nickNameTextField setReturnKeyType:UIReturnKeyNext];
    _nickNameTextField.textColor = [UIColor grayColor];
    _nickNameTextField.tintColor = [UIColor grayColor];
    [vLogin addSubview:_nickNameTextField];
    _nickNameLabel = [self setupTextName:@"昵称" OnTextField:_nickNameTextField];
    [_nickNameTextField addSubview:_nickNameLabel];
    
    //密码
    _pswTextField = [inputText setupWithIcon:nil textY:CGRectGetMaxY(_nickNameTextField.frame)+SIZ(20) centerX:centerX point:nil];
    _pswTextField.delegate = self;
    [_pswTextField setReturnKeyType:UIReturnKeyNext];
    [_pswTextField setSecureTextEntry:YES];
    _pswTextField.textColor = [UIColor grayColor];
    _pswTextField.tintColor = [UIColor grayColor];
    [vLogin addSubview:_pswTextField];
    _pswLabel = [self setupTextName:@"密码" OnTextField:_pswTextField];
    [_pswTextField addSubview:_pswLabel];
    
    //确认密码
    _pswConfirmTextField = [inputText setupWithIcon:nil textY:CGRectGetMaxY(_pswTextField.frame)+SIZ(20) centerX:centerX point:nil];
    _pswConfirmTextField.delegate = self;
    [_pswConfirmTextField setReturnKeyType:UIReturnKeyDone];
    [_pswConfirmTextField setSecureTextEntry:YES];
    _pswConfirmTextField.textColor = [UIColor grayColor];
    _pswConfirmTextField.tintColor = [UIColor grayColor];
    [vLogin addSubview:_pswConfirmTextField];
    _pswConfirmLabel = [self setupTextName:@"确认密码" OnTextField:_pswConfirmTextField];
    [_pswConfirmTextField addSubview:_pswConfirmLabel];
    
    //注册
    _regBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
    [_regBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
    _regBtn.frame = CGRectMake(SIZ(30), CGRectGetMaxY(vLogin.frame) + SIZ(20), UIScreenWidth-SIZ(60), SIZ(50));
    [_regBtn setTitle:@"注   册" forState:UIControlStateNormal];
    [_regBtn addTarget:self action:@selector(regClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regBtn];
    
}

- (UILabel *)setupTextName:(NSString *)textName OnTextField:(UITextField *)textField
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = FONT_16;
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = CGRectMake(0, 0, textField.frame.size.width, textField.frame.size.height);
    return textNameLabel;
}

-(void)regClick{
    if ([_phoneTextField isNotEmpty]) {
        if ([_nickNameTextField isNotEmpty]) {
            if ([_pswTextField isNotEmpty]) {
                if ([_pswConfirmTextField isNotEmpty]) {
                    if ([_phoneTextField validatePhoneNumber]) {
                        if ([_pswTextField validatePassWord]) {
                            if ([_pswConfirmTextField.text isEqualToString:_pswTextField.text]) {
                                
                                //注册成功
                                NSLog(@"注册成功");
                                //返回登录界面
                                [self.navigationController popViewControllerAnimated:YES];
                                
                                
                            }else{
                                [self showAlertWithMsg:@"确认密码不一致"];
                            }
                        }else{
                            [self showAlertWithMsg:@"请输入6～12位密码"];
                        }
                    }else{
                        [self showAlertWithMsg:@"请输入11位有效手机号码"];
                    }
                }else{
                    [[[AFViewShaker alloc]initWithView:_pswConfirmTextField] shake];
                }
            }else{
                [[[AFViewShaker alloc]initWithView:_pswTextField] shake];
            }
        }else{
            [[[AFViewShaker alloc]initWithView:_nickNameTextField] shake];
        }
    }else{
        [[[AFViewShaker alloc]initWithView:_phoneTextField] shake];
    }
}

-(void)showAlertWithMsg:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - getters



@end
