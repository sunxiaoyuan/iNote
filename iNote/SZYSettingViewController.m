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
#import "SZYPersonalCenterViewController.h"
#import "SZYLocalFileManager.h"
#import "SZYUser.h"



@interface SZYSettingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *sepLineView;

//点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//个人中心
@property (nonatomic, strong) SZYSettingView         *personalCenterView;
//清理缓存
@property (nonatomic, strong) SZYSettingView         *cleanCacheView;
//注销按钮
@property (nonatomic, strong) SZYMenuButton          *logoutBtn;
//缓存弹出提示框
@property (nonatomic, strong) UIAlertView            *alertView;

@property (nonatomic, strong) SZYLocalFileManager    *fileManager;

@end

@implementation SZYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.navigationItem.rightBarButtonItem = nil;
    self.fileManager = [SZYLocalFileManager sharedInstance];
    
    //加载组件
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.personalCenterView];
    [self.bottomView addSubview:self.cleanCacheView];
    [self.bottomView addSubview:self.sepLineView];
    [self.view addSubview:self.logoutBtn];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.personalCenterView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.personalCenterView addGestureRecognizer:tap1];
    [self.cleanCacheView addGestureRecognizer:tap2];
   
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //渲染组件
    self.bottomView.frame = CGRectMake(0, 12, UIScreenWidth, UIScreenHeight * 0.2);
    CGFloat sepW = UIScreenWidth * 0.85;
    CGFloat sepX = (UIScreenWidth - sepW)/2;
    CGFloat sepY = self.bottomView.frame.size.height/2;
    self.sepLineView.frame = CGRectMake(sepX, sepY, sepW, 1);
    
    CGFloat bottomH = self.bottomView.frame.size.height;
    self.personalCenterView.frame = CGRectMake((UIScreenWidth-270)/2, (bottomH/2 - 40)/2, 270, 40);
    self.cleanCacheView.frame = CGRectMake((UIScreenWidth-270)/2, CGRectGetMaxY(self.sepLineView.frame)+(bottomH/2 - 40)/2, 270, 40);

    self.logoutBtn.frame = CGRectMake((UIScreenWidth-270)/2, CGRectGetMaxY(self.bottomView.frame)+24, 270, 45);
    
//    //添加view
//    CGFloat viewW = UIScreenWidth * 0.88;
//    CGFloat viewX = UIScreenWidth * 0.12 / 2;
//    CGFloat viewH = SIZ(50);
//    CGFloat viewY = SIZ(40);
//    [self viewAddSetingViewWithSetingView:self.personalCenterView frame:CGRectMake(viewX, viewY, viewW, viewH) tag:SZYSetingViewTypePersonalCenter];
//    [self viewAddSetingViewWithSetingView:self.cleanCacheView frame:CGRectMake(viewX, viewY + viewH + SIZ(2), viewW, viewH) tag:SZYSetingViewTypeCleanCache];
//    
//    
//    
    //设置“退出登录”是否出现
    self.logoutBtn.hidden = !ApplicationDelegate.isLoggedin;
    
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        
        //清除temp文件夹下所有缓存
        [self.fileManager cleanTempFolder];
    }
    self.alertView = nil;
}

#pragma mark - 私有方法
- (void)viewAddSetingViewWithSetingView:(SZYSettingView *)view frame:(CGRect)frame tag:(SZYSetingViewType)tag{
    view.frame = frame;
    view.tag = tag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [view addGestureRecognizer:tap];
}

//view被点击
- (void)viewClick:(UITapGestureRecognizer *)tap{
    //判断点击了那个view
    switch (tap.view.tag){
        case SZYSetingViewTypePersonalCenter:
            //跳转到个人中心详情页 或者 登陆界面
        {
//            if (ApplicationDelegate.isLoggedin) {
//                
//                SZYPersonalCenterViewController *centerVC = [SZYPersonalCenterViewController createFromStoryboardName:@"PersonalCenter" withIdentifier:@"PersonalCenterIB"];
//                [self.navigationController pushViewController:centerVC animated:YES];
//
//            }else{
            
                SZYLgoinViewController *loginVC = [[SZYLgoinViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
//            }
        }
            break;
            
        case SZYSetingViewTypeCleanCache:
            
        {
            //获得temp文件夹下的缓存文件大小
            float chacheSize = [self.fileManager fileSizeAtTempFolder];
            self.alertView = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗?", chacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [self.alertView show];
            self.alertView.delegate = self;
            
        }
            break;
            
        default:
            break;
    }
}

//退出登录
- (void)logoutButtonClick{
    //注销账户
    
}

#pragma mark - getters

-(UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIView *)sepLineView{
    if (!_sepLineView){
        _sepLineView = [[UIView alloc]init];
        _sepLineView.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _sepLineView;
}


-(UITapGestureRecognizer *)tap{
    if (!_tap){
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    }
    return _tap;
}

-(SZYSettingView *)personalCenterView{
    if (!_personalCenterView){
        _personalCenterView = [SZYSettingView settingViewWithTitle:@"个人中心"];
        _personalCenterView.tag = SZYSetingViewTypePersonalCenter;
    }
    return _personalCenterView;
}

-(SZYSettingView *)cleanCacheView{
    if (!_cleanCacheView){
        _cleanCacheView = [SZYSettingView settingViewWithTitle:@"清理缓存"];
        _cleanCacheView.tag = SZYSetingViewTypeCleanCache;
    }
    return _cleanCacheView;
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
