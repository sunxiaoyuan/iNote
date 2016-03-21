//
//  SZYPrivateViewController.m
//  iNote
//
//  Created by Develop on 16/3/4.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYPrivateViewController.h"
#import "UIAlertController+SZYKit.h"

@interface SZYPrivateViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UILabel *pwdLabel;
@property (nonatomic ,strong) UITextField *pwdTF;
@property (nonatomic ,strong) UILabel *confirmLabel;
@property (nonatomic ,strong) UITextField *confirmTF;
@property (nonatomic ,strong) UIView *sepLineView;
@property (nonatomic ,strong) UIButton *sureBtn;

@end

@implementation SZYPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.pwdLabel];
    [self.bottomView addSubview:self.pwdTF];
    [self.bottomView addSubview:self.confirmLabel];
    [self.bottomView addSubview:self.confirmTF];
    [self.bottomView addSubview:self.sepLineView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sureBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat kLeadingMargin = 20;
    self.bottomView.frame = CGRectMake(0, 25, UIScreenWidth, UIScreenHeight*0.18);
    self.pwdLabel.frame = CGRectMake(kLeadingMargin, (self.bottomView.height/2-50)/2, 80, 50);
    self.pwdTF.frame = CGRectMake(self.pwdLabel.right+kLeadingMargin, self.pwdLabel.top, UIScreenWidth-self.pwdLabel.right-2*kLeadingMargin, 50);
    self.sepLineView.frame = CGRectMake(kLeadingMargin, self.bottomView.height/2, UIScreenWidth-2*kLeadingMargin, 0.5);
    self.confirmLabel.frame = CGRectMake(kLeadingMargin, self.sepLineView.bottom+(self.bottomView.height/2-50)/2, 80, 50);
    self.confirmTF.frame = CGRectMake(self.confirmLabel.right+kLeadingMargin, self.confirmLabel.top, UIScreenWidth-self.confirmLabel.right-2*kLeadingMargin, 50);

    
    [self.pwdTF becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.confirmTF) {
        [self formCheck];
    }
    return YES;
}

#pragma mark - 重写父类返回方法
- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pwdTF resignFirstResponder];
    [self.confirmTF resignFirstResponder];
}

#pragma mark - 点击确认按钮
-(void)sureBtnClick
{
    [self formCheck];
}

#pragma mark - 验证表单
-(void)formCheck
{
    if (![self.pwdTF.text isEqualToString:self.confirmTF.text]) {
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"确认密码不一致" cancelTitle:@"我知道了" cancelHandler:^{
            [self.confirmTF becomeFirstResponder];
        }];
    }
    else{
        //本地化新密码
        [[NSUserDefaults standardUserDefaults] setObject:self.confirmTF.text forKey:NoteBookPswKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self popViewController];
    }
}

#pragma mark - getters

-(UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
-(UILabel *)pwdLabel{
    if (!_pwdLabel){
        _pwdLabel = [[UILabel alloc]init];
        _pwdLabel.text = @"新密码:";
        _pwdLabel.textAlignment = NSTextAlignmentLeft;
        _pwdLabel.font = FONT_14;
        _pwdLabel.textColor = ThemeColor;
    }
    return _pwdLabel;
}

-(UILabel *)confirmLabel{
    if (!_confirmLabel){
        _confirmLabel = [[UILabel alloc]init];
        _confirmLabel.text = @"确认密码:";
        _confirmLabel.textAlignment = NSTextAlignmentLeft;
        _confirmLabel.font = FONT_14;
        _confirmLabel.textColor = ThemeColor;
    }
    return _confirmLabel;
}

-(UITextField *)pwdTF{
    if (!_pwdTF){
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.textAlignment = NSTextAlignmentLeft;
        _pwdTF.secureTextEntry = YES;
        _pwdTF.textColor = UIColorFromRGB(0x888888);
        _pwdTF.returnKeyType = UIReturnKeyNext;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.backgroundColor = [UIColor whiteColor];
        _pwdTF.font = FONT_14;
        _pwdTF.delegate = self;
        _pwdTF.keyboardType = UIKeyboardTypeDefault;
    }
    return _pwdTF;
}

-(UITextField *)confirmTF{
    if (!_confirmTF){
        _confirmTF = [[UITextField alloc]init];
        _confirmTF.textAlignment = NSTextAlignmentLeft;
        _confirmTF.secureTextEntry = YES;
        _confirmTF.textColor = UIColorFromRGB(0x888888);
        _confirmTF.returnKeyType = UIReturnKeyDone;
        _confirmTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmTF.backgroundColor = [UIColor whiteColor];
        _confirmTF.font = FONT_14;
        _confirmTF.delegate = self;
        _confirmTF.keyboardType = UIKeyboardTypeDefault;
    }
    return _confirmTF;
}

-(UIView *)sepLineView{
    if (!_sepLineView){
        _sepLineView = [[UIView alloc]init];
        _sepLineView.backgroundColor = UIColorFromRGB(0xefefef);
    }
    return _sepLineView;
}

-(UIButton *)sureBtn{
    if (!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, 0, 40, 40);
        _sureBtn.titleLabel.font = FONT_14;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
















@end
