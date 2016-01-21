//
//  UIAlertController+SZYKit.h
//  iNote
//
//  Created by sunxiaoyuan on 15/12/3.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^confirm)(UIAlertAction *action);
typedef void (^cancle)(UIAlertAction *action);

@interface UIAlertController (SZYKit)

/*
 默认标题，完整的回调
 */
+(void)showAlertAtViewController:(UIViewController *)viewController
       withMessage:(NSString *)message
       cancelTitle:(NSString *)cancelButtonTitle
       confirmTitle:(NSString *)confirmButtonTitle
       cancelHandler:(cancle)cancle
       confirmHandler:(confirm)confirm;

+(void)showAlertAtViewController:(UIViewController *)viewController
                           title:(NSString *)title
                     message:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm;

//带有输入框
+(void)showAlertWithTextFieldAtViewController:(UIViewController *)viewController
                                        title:(NSString *)title
                                      message:(NSString *)message
                                  cancelTitle:(NSString *)cancelButtonTitle
                                 confirmTitle:(NSString *)confirmButtonTitle
                               confirmHandler:(void(^)(NSString *inputStr))confirm;

//编辑笔记本专用接口
+(void)showAlertSheetAtViewController:(UIViewController *)viewController
                        cancelHandler:(void(^)())cancelHandler
                        deleteHandler:(void(^)())deleteHandler
                      privateBtnTitle:(NSString *)privateBtnTitle
                       privateHandler:(void(^)())privateHandler
                        renameHandler:(void(^)())renameHandler;

@end
