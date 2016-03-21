//
//  SZYPermissionViewController.m
//  iNote
//
//  Created by Develop on 16/3/4.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYPermissionViewController.h"
#import "SZYPrivateViewController.h"
#import "UIAlertController+SZYKit.h"

@interface SZYPermissionViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UITextField *pwdTF;
@property (nonatomic ,strong) UIButton *sureBtn;

@end

@implementation SZYPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.sureBtn];
    self.navigationItem.rightBarButtonItem = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT_14}];
    
    self.titleLabel.frame = CGRectMake(0, 120, size.width, size.height);
    self.titleLabel.centerX = self.view.centerX;
    self.pwdTF.frame = CGRectMake(0, self.titleLabel.bottom + 20, size.width+10, size.height+10);
    self.pwdTF.centerX = self.view.centerX;
    self.sureBtn.frame = CGRectMake(0, self.pwdTF.bottom + 50, size.width, size.height);
    self.sureBtn.centerX = self.view.centerX;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self formCheck];
    return YES;
}
#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pwdTF resignFirstResponder];
}

#pragma mark - 点击确定按钮
-(void)sureBtnClick
{
    [self formCheck];
}

#pragma mark - 验证密码
-(void)formCheck
{
    if ([self.pwdTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:NoteBookPswKey]]) {
        SZYPrivateViewController * vc = [[SZYPrivateViewController alloc]initWithTitle:@"修改密码" BackButton:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"密码不正确" cancelTitle:@"我知道了" cancelHandler:^{
            [self.pwdTF becomeFirstResponder];
        }];
    }
}

#pragma mark - getters

-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_14;
        _titleLabel.text = @"请输入私密笔记本密码";
        _titleLabel.textColor = ThemeColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UITextField *)pwdTF{
    if (!_pwdTF){
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.textAlignment = NSTextAlignmentLeft;
        _pwdTF.secureTextEntry = YES;
        _pwdTF.textColor = UIColorFromRGB(0x888888);
        _pwdTF.returnKeyType = UIReturnKeyDone;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.backgroundColor = [UIColor whiteColor];
        _pwdTF.font = FONT_14;
        _pwdTF.delegate = self;
        _pwdTF.keyboardType = UIKeyboardTypeDefault;
        _pwdTF.layer.masksToBounds = YES;
        _pwdTF.layer.cornerRadius = 8.0f;
    }
    return _pwdTF;
}

-(UIButton *)sureBtn{
    if (!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = FONT_14;
        [_sureBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}



@end
