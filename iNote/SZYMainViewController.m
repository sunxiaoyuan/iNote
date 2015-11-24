//
//  SZYMainViewController.m
//  iNote
////////////////////////////////////////////////////////////////////////
//
//                      祖国万岁! 老婆万岁！没有bug!
//
////////////////////////////////////////////////////////////////////////
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  程序主入口，实现一个自定义标签控制器

#import "SZYMainViewController.h"
#import "SZYIntroView.h"
#import "SZYLeftMenuView.h"
#import "SZYHomeViewController.h"
#import "SZYNavigationController.h"
#import "SZYNotesViewController.h"
#import "SZYFavoriteViewController.h"
#import "SZYSettingViewController.h"
#import "SZYLgoinViewController.h"

@interface SZYMainViewController ()<SZYIntroViewDelegate,SZYLeftMenuViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) SZYIntroView           *introView;//引导页
@property (nonatomic, strong) SZYBaseViewController  *showViewController;//记录当前显示的页
@property (nonatomic, strong) SZYLeftMenuView        *leftMenuView;//侧边栏
@property (nonatomic, strong) UIPanGestureRecognizer *pan; //拖动手势

@end

@implementation SZYMainViewController

#pragma mark - 生命事件
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控制器
    SZYHomeViewController *homeVC = [[SZYHomeViewController alloc]init];
    SZYNotesViewController *notesVC = [[SZYNotesViewController alloc]init];
    SZYFavoriteViewController *favVC = [[SZYFavoriteViewController alloc]init];
    SZYSettingViewController *setVC = [[SZYSettingViewController alloc]init];
    SZYLgoinViewController *logVC = [[SZYLgoinViewController alloc] initWithTitle:@"登录" BackButton:NO];
    NSArray *vcArr = @[homeVC,notesVC,favVC,setVC,logVC];
    
    for (int i = 0; i < [vcArr count]; i ++) {
        SZYNavigationController *nc = [[SZYNavigationController alloc]initWithRootViewController:vcArr[i]];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:nc];
    }
    
    //保证侧边栏始终在最底层
    [self.view insertSubview:self.leftMenuView atIndex:1];
    
    //添加手势
    [self.view addGestureRecognizer:self.pan];
    
    //添加引导页(引导页最后再添加到主页面上,覆盖在最上面)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"IntroView_Showed"]) {
        //首次打开应用才会添加引导页
        [self.view addSubview:self.introView];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    //绘制侧边栏，添加约束
    [self.leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.width.equalTo(self.view).with.multipliedBy(0.76);
    }];
}


#pragma mark - SZYIntroViewDelegate

-(void)onDoneButtonPressed{
    
    //再次打开应用时保证引导页不出现(卸载除外,会清空defaults的内容)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"IntroView_Showed"];
    [defaults synchronize];
    //淡出引导页－动画
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
    
}

#pragma mark - SZYLeftMenuViewDelegate 左视图按钮点击事件
-(void)switchViewControllerFrom:(SZYleftButtonType)fromIndex To:(SZYleftButtonType)toIndex{
    
    SZYNavigationController *newNC = self.childViewControllers[toIndex];
    SZYNavigationController *oldNC = self.childViewControllers[fromIndex];
    //移除旧的控制器view
    [oldNC.view removeFromSuperview];
    //添加新的控制器view
    [self.view addSubview:newNC.view];
    newNC.view.transform = oldNC.view.transform;
    self.showViewController = newNC.childViewControllers[0];
    //触发点击遮罩的方法,恢复界面
    [self.showViewController recoverInterface];
}

#pragma mark - 私有方法

-(void)panGesture:(UIPanGestureRecognizer *)pan{
    
    //手指移动距离
    CGFloat moveX = [pan translationInView:self.view].x;
    //缩放的最终比例
    CGFloat zoomScale = (UIScreenHeight - SZYScaleTopMargin * 2)/UIScreenHeight;
    //X最终偏移距离
    CGFloat maxMoveX = UIScreenWidth - UIScreenWidth * SZYZoomScaleRight;
    //没有缩放时，允许缩放
    if (self.showViewController.isScale == NO) {
        if ( moveX >= 0 && moveX <= maxMoveX + 5 ){
            //获取X偏移下, XY缩放的比例
            CGFloat scaleXY = 1 - moveX / maxMoveX * SZYZoomScaleRight;
            CGAffineTransform transform = CGAffineTransformMakeScale(scaleXY, scaleXY);
            self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(transform, moveX / scaleXY, 0);
        }
        //当手势停止的时候,判断X轴的移动距离，停靠
        if (pan.state == UIGestureRecognizerStateEnded){
            //计算剩余停靠时间
            if (moveX >= maxMoveX / 2){ //X轴移动超过一半
                CGFloat duration = 0.5 * (maxMoveX - moveX)/maxMoveX > 0 ? 0.5 * (maxMoveX - moveX)/maxMoveX : -(0.5 * (maxMoveX - moveX)/maxMoveX);
                if (duration <= 0.1) duration = 0.1;
                //直接停靠到停止的位置
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    CGAffineTransform tt = CGAffineTransformMakeScale(zoomScale, zoomScale);
                    self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(tt, maxMoveX , 0);
                    
                } completion:^(BOOL finished) {
                    //将状态改为已经缩放
                    self.showViewController.isScale = YES;
                    //手动点击按钮添加遮盖
                    [self.showViewController leftMenuClick];
                }];
                
            }else{
                //X轴移动不够一半 回到原位,不是缩放状态
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.showViewController.navigationController.view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    self.showViewController.isScale = NO;
                }];
            }
        }
        
    }else if (self.showViewController.isScale == YES){
        
        //在已经缩放的情况下，计算比例
        CGFloat scaleXY = zoomScale - moveX / maxMoveX * SZYZoomScaleRight;
        if (moveX <= 5) {
            CGAffineTransform transform = CGAffineTransformMakeScale(scaleXY, scaleXY);
            self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(transform, (moveX + maxMoveX), 0);
        }
        //当手势停止的时候,判断X轴的移动距离，停靠
        if (pan.state == UIGestureRecognizerStateEnded) {
            //计算剩余停靠时间
            if (-moveX >= maxMoveX / 2) {
                CGFloat duration = 0.5 * (maxMoveX + moveX)/maxMoveX > 0 ? 0.5 * (maxMoveX + moveX)/maxMoveX : -(0.5 * (maxMoveX + moveX)/maxMoveX);
                if (duration <= 0.1) duration = 0.1;
                //直接停靠到停止的位置
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    self.showViewController.navigationController.view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    
                    //将状态改为已经缩放
                    self.showViewController.isScale = NO;
                    //手动点击按钮添加遮盖
                    [self.showViewController recoverInterface];
                }];
                
            } else {//X轴移动不够一半 回到原位,不是缩放状态
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    CGAffineTransform tt = CGAffineTransformMakeScale(zoomScale, zoomScale);
                    self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(tt, maxMoveX, 0);
                    
                } completion:^(BOOL finished) {
                    self.showViewController.isScale = YES;
                }];
            }
        }
    }
}


#pragma mark - getters

-(SZYLeftMenuView *)leftMenuView{
    if (!_leftMenuView){
        _leftMenuView = [[NSBundle mainBundle] loadNibNamed:@"SZYLeftMenuView" owner:nil options:nil].lastObject;
        _leftMenuView.delegate = self;
    }
    return _leftMenuView;
}

-(SZYIntroView *)introView{
    if (!_introView){
        _introView = [[SZYIntroView alloc] initWithFrame:self.view.frame];
        _introView.delegate = self;
    }
    return _introView;
}

-(UIPanGestureRecognizer *)pan{
    if (!_pan){
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        _pan.delegate = self;
    }
    return _pan;
}


@end
