//
//  SZYBaseViewController.h
//  iNote
//
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^coverDidRomove)();

@interface SZYBaseViewController : UIViewController

@property (nonatomic, strong) UIButton       *hudBtn;//遮盖按钮
@property (nonatomic, strong) coverDidRomove coverDidRomove;
@property (nonatomic, assign) BOOL           isScale;//是否缩放
@property (nonatomic, assign) BOOL     isNeedBack;

//初始化方法
- (instancetype)initWithTitle:(NSString *)title  BackButton:(BOOL)isNeedBack;

- (void)recoverInterface;
- (void)leftMenuClick;
- (void)rightSearchClick;

-(void)addHub;
-(void)removeHub;

@end
