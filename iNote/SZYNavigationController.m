//
//  SZYNavigationController.m
//  iNote
//
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  基类导航控制器,定义了整个工程的UINavigationBar的主题

#import "SZYNavigationController.h"

@interface SZYNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation SZYNavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //恢复因替换导航条的back按钮失去系统默认手势
    self.interactivePopGestureRecognizer.delegate = nil;
    
    //去除系统的右滑返回手势
    self.interactivePopGestureRecognizer.enabled = NO;

    [self.view addGestureRecognizer:self.pan];
}

+(void)initialize{
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];

    //需要处理一下背景图片，做一个拉伸处理
    //参数为UIEdgeInsetsMake(0, 0, 0, 0)时，代表我们未对原始图像的任何区域进行保护，会被整体拉伸
    [bar setBackgroundImage:[[UIImage imageNamed:@"recomend_btn_gone"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    //去掉导航条的半透明
    bar.translucent = NO;
    //标题样式
    [bar setTitleTextAttributes:@{NSFontAttributeName:FONT_20,
                                  NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

#pragma mark - 手势代理方法
// 是否开始触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断下当前控制器是否是根控制器
    return (self.topViewController != [self.viewControllers firstObject]);
}

#pragma mark - getters

-(UIPanGestureRecognizer *)pan{
    if (!_pan){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
        _pan.delegate = self;
    }
    return _pan;
}

@end
