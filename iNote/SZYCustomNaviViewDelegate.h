//
//  SZYCustomNaviViewDelegate.h
//  iNote
//
//  Created by sunxiaoyuan on 15/12/16.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZYCustomNaviViewDelegate <NSObject>

@optional
//点击同步
-(void)customNaviViewSyncButtonClick:(UIButton *)sender;
//点击左侧列表
-(void)customNaviViewLeftMenuClick:(UIButton *)sender;
//点击搜索
-(void)customNaviViewRightSearchClick:(UIButton *)sender;
//下拉列表收起时
-(void)openListHaveDisappear:(NSInteger)selectedIndex;
//改变下拉列表状态
-(void)openListStateShouldChange:(BOOL)isListOpen;

//右侧按钮点击响应事件
<<<<<<< HEAD
-(void)moreBtnDidclick:(UIButton *)sender;
-(void)doneBtnDidClick:(UIButton *)sender;
=======
-(void)moreBtnDidclick;
-(void)doneBtnDidClick;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61

@end
