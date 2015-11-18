//
//  SZYLgoinViewController.h
//  iNote
//
//  Created by 孙中原 on 15/10/13.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYBaseViewController.h"

typedef NS_ENUM(NSInteger, SZYLoginShowType) {
    SZYLoginShowType_NONE,
    SZYLoginShowType_USER,
    SZYLoginShowType_PASS,
};

typedef NS_ENUM(NSInteger,SZYLoginErrorType) {
    SZYLoginErrorType_WrongUser,
    SZYLoginErrorType_WrongPsw,
};

@interface SZYLgoinViewController : SZYBaseViewController

@end
