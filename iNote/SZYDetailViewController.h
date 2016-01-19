//
//  SZYDetailViewController.h
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZYNoteModel;

typedef NS_ENUM(NSInteger, SZYFromType) {
    SZYFromListType,//将要做修改操作
    SZYFromAddType,//将要做创建操作
};

@interface SZYDetailViewController : UIViewController

/**
 *  初始化方法
 *
 *  @param noteBook 详情页展示的笔记
 *  @param type     跳转来源
 *
 */
-(instancetype)initWithNote:(SZYNoteModel *)noteBook AndSourceType:(SZYFromType)type;

@end
