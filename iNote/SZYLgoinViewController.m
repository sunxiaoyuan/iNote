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
#import "SZYViewShaker.h"
#import "SZYRegViewController.h"
#import "SZYHomeViewController.h"

#define offsetLeftHand      SIZ(60)

@interface SZYLgoinViewController ()<UITextFieldDelegate>{
    
    SZYLoginShowType showType;
    UITextField *txtUser;
    UITextField *txtPwd;
    UIImageView *imgLeftHand;
    UIImageView *imgRightHand;
    UIImageView *imgLeftHandGone;
    UIImageView *imgRightHandGone;
    UIButton    *leftBtn;
    UIButton    *loginBtn;
    UIButton    *registerBtn;
    UIButton    *findPswBtn;
    NSArray     *allFields;
}



@end

@implementation SZYLgoinViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    //初始化导航条上的内容
    [self setNavigationItem];
    
    //初始化UI
    [self setUP];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextFielDgelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txtUser) {
        return [txtPwd becomeFirstResponder];
    }else {
        return [txtPwd resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:txtUser]) {
        if (showType != SZYLoginShowType_PASS)
        {
            showType = SZYLoginShowType_USER;
            return;
        }
        showType = SZYLoginShowType_USER;
        [self oweLookStatus];
        
    }
    else if ([textField isEqual:txtPwd]) {
        if (showType == SZYLoginShowType_PASS)
        {
            showType = SZYLoginShowType_PASS;
            return;
        }
        showType = SZYLoginShowType_PASS;
        [self oweShyStatus];
    }
}

-(void)oweLookStatus{
    [UIView animateWithDuration:0.5 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + SIZ(30), imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + SIZ(48), imgRightHand.frame.origin.y + SIZ(30), imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - SIZ(70), imgLeftHandGone.frame.origin.y, SIZ(40), SIZ(40));
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + SIZ(30), imgRightHandGone.frame.origin.y, SIZ(40), SIZ(40));
    } completion:^(BOOL b) {
    }];
}

-(void)oweShyStatus{
    [UIView animateWithDuration:0.5 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - SIZ(30), imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - SIZ(48), imgRightHand.frame.origin.y - SIZ(30), imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + SIZ(70), imgLeftHandGone.frame.origin.y, 0, 0);
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - SIZ(30), imgRightHandGone.frame.origin.y, 0, 0);
    } completion:^(BOOL b) {
    }];
}

#pragma mark - 私有方法

-(void)setNavigationItem{
    
    self.title = @"登陆";
    self.navigationItem.rightBarButtonItem = nil;
    
//    if (self.needsBack) {
    
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, SIZ(20), SIZ(20));
        [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    }
  
}

-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setUP{
    
    //设置底色
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    CGFloat imgLoginX = (UIScreenWidth - SIZ(211))/2;
    CGFloat imgLoginY = SIZ(15);
    CGFloat imgLoginW = SIZ(211);
    CGFloat imgLoginH = SIZ(109);
    UIImageView *imgLogin = [[UIImageView alloc]initWithFrame:CGRectMake(imgLoginX, imgLoginY, imgLoginW, imgLoginH)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc]initWithFrame:CGRectMake(SIZ(61)-offsetLeftHand, SIZ(90), SIZ(40), SIZ(65))];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(imgLogin.frame.size.width/2+SIZ(60), SIZ(90), SIZ(40), SIZ(65))];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(SIZ(15), SIZ(115), UIScreenWidth - SIZ(30), SIZ(160))];
    vLogin.layer.cornerRadius = 5;
    vLogin.layer.masksToBounds = YES;
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    
    CGFloat handGoneW = SIZ(40);
    CGFloat handGoneH = SIZ(40);
    CGFloat handGoneY = vLogin.frame.origin.y - SIZ(22);
    CGRect rectLeftHandGone = CGRectMake(UIScreenWidth/2-SIZ(100), handGoneY, handGoneW, handGoneH);
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgLeftHandGone];
    
    CGRect rectRightHandGone = CGRectMake(UIScreenWidth/2+SIZ(62), handGoneY, handGoneW, handGoneH);
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgRightHandGone];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(SIZ(30), SIZ(30), vLogin.frame.size.width - SIZ(60), SIZ(44))];
    txtUser.delegate = self;
    txtUser.layer.cornerRadius = 5;
    txtUser.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtUser.layer.borderWidth = 0.5;
    txtUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZ(44), SIZ(44))];
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    CGFloat leftimageX = SIZ(11);
    CGFloat leftimageY = SIZ(11);
    CGFloat leftimageW = SIZ(22);
    CGFloat leftimageH = SIZ(22);
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(leftimageX, leftimageY, leftimageW, leftimageH)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [txtUser.leftView addSubview:imgUser];
    [vLogin addSubview:txtUser];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(SIZ(30), SIZ(90), vLogin.frame.size.width - SIZ(60), SIZ(44))];
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPwd.delegate = self;
    txtPwd.layer.cornerRadius = 5;
    txtPwd.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtPwd.layer.borderWidth = 0.5;
    txtPwd.secureTextEntry = YES;
    txtPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZ(44), SIZ(44))];
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(leftimageX, leftimageY, leftimageW, leftimageH)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [txtPwd.leftView addSubview:imgPwd];
    [vLogin addSubview:txtPwd];
    
    //登陆
    loginBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"button_login_bg_6P"] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(SIZ(30), CGRectGetMaxY(vLogin.frame) + SIZ(50), UIScreenWidth-SIZ(60), SIZ(50));
    [loginBtn setTitle:@"登 陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册
    registerBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"我是新手" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = FONT_13;
    [registerBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(SIZ(30), CGRectGetMaxY(loginBtn.frame) + SIZ(8), SIZ(60), SIZ(30));
    [self.view addSubview:registerBtn];
    
    //找回密码
    findPswBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
    [findPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    findPswBtn.titleLabel.font = FONT_13;
    [findPswBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [findPswBtn addTarget:self action:@selector(findPswClick) forControlEvents:UIControlEventTouchUpInside];
    findPswBtn.frame = CGRectMake(UIScreenWidth - SIZ(90), CGRectGetMaxY(loginBtn.frame) + SIZ(8), SIZ(60), SIZ(30));
    [self.view addSubview:findPswBtn];
    
}

//点击登陆
-(void)loginClick{
    
    if ([txtUser isNotEmpty]) {
        if ([txtPwd isNotEmpty]) {
            
            if ([txtUser validateUserName]) {
                if ([txtPwd validatePassWord]) {
                    
                    //服务器验证账号，密码合法性。返回完整的账号信息
                    
                    //加载当前帐号的资源，自发的网络同步过程
                    
                    //修改本地所有相关个人信息的设置
                    
                    NSLog(@"验证成功");
                    ApplicationDelegate.isLoggedin = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self shakeTextFiedWithError:SZYLoginErrorType_WrongPsw];
                }
            }else{
                [self shakeTextFiedWithError:SZYLoginErrorType_WrongUser];
            }
        }else{
            [self shakeTextFiedWithError:SZYLoginErrorType_WrongPsw];
        }
    }else{
        [self shakeTextFiedWithError:SZYLoginErrorType_WrongUser];
    }
}

//震动提示
-(void)shakeTextFiedWithError:(SZYLoginErrorType )type{
    
    switch (type) {
        case SZYLoginErrorType_WrongUser:
        {
            [[[SZYViewShaker alloc]initWithView:txtUser] shake];
        }
            break;
        case SZYLoginErrorType_WrongPsw:
        {
            [[[SZYViewShaker alloc]initWithView:txtPwd] shake];
        }
            break;
        default:
            break;
    }
 
}

//点击注册
-(void)registerClick{
    
    SZYRegViewController *regVC = [[SZYRegViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [txtPwd resignFirstResponder];
    [txtUser resignFirstResponder];
    
    if (showType != SZYLoginShowType_PASS)
    {
        showType = SZYLoginShowType_USER;
        return;
    }
    showType = SZYLoginShowType_USER;
    [self oweLookStatus];
}

//找回密码
-(void)findPswClick{
    
    NSLog(@"找回密码");
}


@end
