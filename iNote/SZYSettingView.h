//
//  SZYSettingView.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//SZYSetingView的类型
typedef NS_ENUM(NSInteger, SZYSetingViewType) {
    SZYSetingViewTypePersonalCenter,
    SZYSetingViewTypeCleanCache,
    SZYSetingViewTypePrivate,
    SZYSetingViewTypeAboutUs
};

@interface SZYSettingView : UIView
/**
 *  设置view的文字
 *
 *  @param title 字符串标题
 *
 *  @return SZYSettingView的实例
 */
+(instancetype)settingViewWithTitle:(NSString *)title;

@end
