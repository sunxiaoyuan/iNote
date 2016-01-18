//
//  SZYBaseViewController.m
//  iNote
//
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  基类ViewController

#import "SZYBaseViewController.h"

static NSTimeInterval const kScaleAnimateWithDuration = 0.3;


@interface SZYBaseViewController ()

@end

@implementation SZYBaseViewController

- (instancetype)initWithTitle:(NSString *)title  BackButton:(BOOL)isNeedBack
{
    self = [super init];
    if (self) {
        self.title = title;
        _isNeedBack = isNeedBack;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //添加导航条上的按钮
    //右侧搜索按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithNormalImage:@"search_icon_white" target:self action:@selector(rightSearchClick) width:25 height:25];
    //左侧返回按钮
    if (!self.isNeedBack) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"artcleList_icon_white" target:self action:@selector(leftMenuClick) width:30 height:30];
    }else{
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"back" target:self action:@selector(popViewController)];
    }
}

#pragma mark - 响应事件

-(void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftMenuClick{
    
    //添加遮罩
    [self addHub];
    
    //缩放比例
    CGFloat zoomScale = (UIScreenHeight - SZYScaleTopMargin * 2) / UIScreenHeight;
    //X移动距离
    CGFloat moveX = UIScreenWidth - UIScreenWidth * SZYZoomScaleRight;
    
    //进行动画
    [UIView animateWithDuration:kScaleAnimateWithDuration animations:^{
        
        //创建缩放矩阵仿射对象
        CGAffineTransform transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
        //移动矩阵仿射对象
        self.navigationController.view.transform = CGAffineTransformTranslate(transform, moveX, 0);

        //将状态改成已经缩放
        self.isScale = YES;
    }];
}

//推出search控制器
-(void)rightSearchClick{
    
    NSString *str = NSStringFromClass([self class]);
    NSLog(@"^^^^^^^%@－rightSearchClick^^^^^^",str);
    
}

// 遮盖点击,恢复界面
- (void)recoverInterface
{
    [UIView animateWithDuration:kScaleAnimateWithDuration animations:^{
        
        self.navigationController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeHub];
        self.isScale = NO;
//        //当遮盖按钮被销毁时调用
//        if (_coverDidRomove) {
//            _coverDidRomove();
//        }
    }];
}

#pragma mark - 公开方法
-(void)addHub{
    //添加遮盖,拦截用户操作
    [self.navigationController.view addSubview:self.hudBtn];

}

-(void)removeHub{
    [self.hudBtn removeFromSuperview];
    self.hudBtn = nil;
}

#pragma mark - getters

-(UIButton *)hudBtn{
    if (!_hudBtn){
        _hudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hudBtn.frame = self.navigationController.view.bounds;
        [_hudBtn addTarget:self action:@selector(recoverInterface) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hudBtn;
}

@end
