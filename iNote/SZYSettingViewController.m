//
//  SZYSettingViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSettingViewController.h"
#import "SZYSettingView.h"
#import "SZYMenuButton.h"
#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "SZYLgoinViewController.h"
#import "SZYLocalFileManager.h"
#import "SZYUser.h"
#import "UIAlertController+SZYKit.h"
#import "SZYPCViewController.h"
#import "SZYPermissionViewController.h"


@interface SZYSettingViewController ()

@property (nonatomic, strong) UIView *bottomView1;
@property (nonatomic ,strong) UIView *bottomView2;
@property (nonatomic, strong) UIView *sepLineView1;
@property (nonatomic, strong) UIView *sepLineView2;

//个人中心
@property (nonatomic, strong) SZYSettingView         *personalCenterView;
//隐私设置
@property (nonatomic ,strong) SZYSettingView         *privateView;
//清理缓存
@property (nonatomic, strong) SZYSettingView         *cleanCacheView;
//关于我们
@property (nonatomic ,strong) SZYSettingView         *aboutUsView;
//注销按钮
@property (nonatomic, strong) SZYMenuButton          *logoutBtn;

@property (nonatomic, strong) SZYLocalFileManager    *fileManager;

@end

@implementation SZYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.navigationItem.rightBarButtonItem = nil;
    self.fileManager = [SZYLocalFileManager sharedInstance];
    
    //加载组件
    [self.view addSubview:self.bottomView1];
    [self.bottomView1 addSubview:self.personalCenterView];
    [self.bottomView1 addSubview:self.privateView];
    [self.bottomView1 addSubview:self.sepLineView1];
    
    [self.view addSubview:self.bottomView2];
    [self.bottomView2 addSubview:self.cleanCacheView];
    [self.bottomView2 addSubview:self.aboutUsView];
    [self.bottomView2 addSubview:self.sepLineView2];
    
    [self.view addSubview:self.logoutBtn];
   
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //渲染组件
    self.bottomView1.frame = CGRectMake(0, 12, UIScreenWidth, UIScreenHeight * 0.18);
    CGFloat sepW = UIScreenWidth * 0.85;
    CGFloat sepX = (UIScreenWidth - sepW)/2;
    CGFloat sepY = self.bottomView1.frame.size.height/2;
    self.sepLineView1.frame = CGRectMake(sepX, sepY, sepW, 1);
    CGFloat bottomH = self.bottomView1.frame.size.height;
    CGFloat customViewX = 20;
    self.personalCenterView.frame = CGRectMake(customViewX, (bottomH/2 - 40)/2, self.bottomView1.width-2*customViewX, 40);
    self.privateView.frame = CGRectMake(customViewX, self.sepLineView1.bottom+(bottomH/2 - 40)/2, self.bottomView1.width-2*customViewX, 40);
    
    self.bottomView2.frame = CGRectMake(0, self.bottomView1.bottom+15, UIScreenWidth, UIScreenHeight * 0.18);
    self.sepLineView2.frame = CGRectMake(sepX, self.bottomView2.height/2, sepW, 1);
    self.cleanCacheView.frame = CGRectMake(customViewX, (self.bottomView2.height/2-40)/2, self.bottomView2.width-2*customViewX, 40);
    self.aboutUsView.frame = CGRectMake(customViewX, self.sepLineView2.bottom+(self.bottomView2.height/2-40)/2, self.bottomView2.width-2*customViewX, 40);
    
    self.logoutBtn.frame = CGRectMake((UIScreenWidth-270)/2, CGRectGetMaxY(self.bottomView2.frame)+24, 270, 45);
    //设置“退出登录”是否出现
    self.logoutBtn.hidden = !ApplicationDelegate.isLoggedin;
    
}

#pragma mark - 响应方法

- (void)viewClick:(UITapGestureRecognizer *)tap{
    //判断点击了那个view
    switch (tap.view.tag){
        case SZYSetingViewTypePersonalCenter:
            //跳转到个人中心详情页 或者 登陆界面
        {
            if (ApplicationDelegate.isLoggedin) {
                SZYPCViewController *centerVC = [[SZYPCViewController alloc]initWithTitle:@"个人中心" BackButton:YES];
                [self.navigationController pushViewController:centerVC animated:YES];
            }else{
                SZYLgoinViewController *loginVC = [[SZYLgoinViewController alloc]initWithTitle:@"登录" BackButton:YES];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
            
        case SZYSetingViewTypePrivate:
        {
            SZYPermissionViewController * perVC = [[SZYPermissionViewController alloc]initWithTitle:@"验证" BackButton:YES];
            [self.navigationController pushViewController:perVC animated:YES];
            break;
        }
            
        case SZYSetingViewTypeCleanCache:
            
        {
            //获得temp文件夹下的缓存文件大小
            float chacheSize = [self.fileManager fileSizeAtTempFolder];
            
            [UIAlertController showAlertAtViewController:self title:@"清除缓存" message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗?", chacheSize] cancelTitle:@"取消" confirmTitle:@"确定" cancelHandler:^(UIAlertAction *action) {
                //
            } confirmHandler:^(UIAlertAction *action) {
                //异步清除文件缓存
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.fileManager cleanTempFolderHandler:^(NSError *error) {
                        if (!error) {
                            NSLog(@"文件清理结果：成功！");
                        }else {
                            NSLog(@"文件清理失败:%@",[error localizedDescription]);
                        }
                    }];
                });
            }];
        }
            break;
        
        case SZYSetingViewTypeAboutUs:
        {
            
            break;
        }
            
        default:
            break;
    }
}

//退出登录
- (void)logoutButtonClick{
    //注销账户
    
}

#pragma mark - getters

-(UIView *)bottomView1{
    if (!_bottomView1){
        _bottomView1 = [[UIView alloc]init];
        _bottomView1.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView1;
}

-(UIView *)sepLineView1{
    if (!_sepLineView1){
        _sepLineView1 = [[UIView alloc]init];
        _sepLineView1.backgroundColor = UIColorFromRGB(0xefefef);
    }
    return _sepLineView1;
}

-(UIView *)bottomView2{
    if (!_bottomView2){
        _bottomView2 = [[UIView alloc]init];
        _bottomView2.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView2;
}

-(UIView *)sepLineView2{
    if (!_sepLineView2){
        _sepLineView2 = [[UIView alloc]init];
        _sepLineView2.backgroundColor = UIColorFromRGB(0xefefef);
    }
    return _sepLineView2;
}

-(SZYSettingView *)personalCenterView{
    if (!_personalCenterView){
        _personalCenterView = [SZYSettingView settingViewWithTitle:@"个人中心"];
        _personalCenterView.tag = SZYSetingViewTypePersonalCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [_personalCenterView addGestureRecognizer:tap];
    }
    return _personalCenterView;
}

-(SZYSettingView *)privateView{
    if (!_privateView){
        _privateView = [SZYSettingView settingViewWithTitle:@"隐私设置"];
        _privateView.tag = SZYSetingViewTypePrivate;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [_privateView addGestureRecognizer:tap];
    }
    return _privateView;
}


-(SZYSettingView *)cleanCacheView{
    if (!_cleanCacheView){
        _cleanCacheView = [SZYSettingView settingViewWithTitle:@"清理缓存"];
        _cleanCacheView.tag = SZYSetingViewTypeCleanCache;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [_cleanCacheView addGestureRecognizer:tap];
    }
    return _cleanCacheView;
}

-(SZYSettingView *)aboutUsView{
    if (!_aboutUsView){
        _aboutUsView = [SZYSettingView settingViewWithTitle:@"关于我们"];
        _aboutUsView.tag = SZYSetingViewTypeAboutUs;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [_aboutUsView addGestureRecognizer:tap];
    }
    return _aboutUsView;
}


-(SZYMenuButton *)logoutBtn{
    if (!_logoutBtn){
        _logoutBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forState:UIControlStateNormal];
        [_logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = FONT_14;
        [_logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}



@end
