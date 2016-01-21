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
#import "UIAlertController+SZYKit.h"



@interface SZYSettingViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *sepLineView;


//个人中心
@property (nonatomic, strong) SZYSettingView         *personalCenterView;
//清理缓存
@property (nonatomic, strong) SZYSettingView         *cleanCacheView;
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
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.personalCenterView];
    [self.bottomView addSubview:self.cleanCacheView];
    [self.bottomView addSubview:self.sepLineView];
    [self.view addSubview:self.logoutBtn];
   
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
//            if (ApplicationDelegate.isLoggedin) {
//                
//                SZYPersonalCenterViewController *centerVC = [SZYPersonalCenterViewController createFromStoryboardName:@"PersonalCenter" withIdentifier:@"PersonalCenterIB"];
//                [self.navigationController pushViewController:centerVC animated:YES];
//
//            }else{
            
                SZYLgoinViewController *loginVC = [[SZYLgoinViewController alloc]initWithTitle:@"登录" BackButton:YES];
                [self.navigationController pushViewController:loginVC animated:YES];
//            }
        }
            break;
            
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


-(SZYSettingView *)personalCenterView{
    if (!_personalCenterView){
        _personalCenterView = [SZYSettingView settingViewWithTitle:@"个人中心"];
        _personalCenterView.tag = SZYSetingViewTypePersonalCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [_personalCenterView addGestureRecognizer:tap];
    }
    return _personalCenterView;
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
