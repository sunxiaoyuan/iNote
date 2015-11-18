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
    SZYFromListType,
    SZYFromAddType,
};

@interface SZYDetailViewController : UIViewController

//>>>>>>>>>>>>>>接受数据模型的初始化方法<<<<<<<<<<<<<<<<//

-(instancetype)initWithNote:(SZYNoteModel *)noteBook AndSourceType:(SZYFromType)type;

@end
