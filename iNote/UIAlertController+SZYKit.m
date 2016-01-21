//
//  UIAlertController+SZYKit.m
//  iNote
//
//  Created by sunxiaoyuan on 15/12/3.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "UIAlertController+SZYKit.h"

@implementation UIAlertController (SZYKit)


+(void)showAlertAtViewController:(UIViewController *)viewController
                     withMessage:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm{
    
    [self showAlertAtViewController:viewController title:@"提示" message:message cancelTitle:cancelButtonTitle confirmTitle:confirmButtonTitle cancelHandler:cancle confirmHandler:confirm];
}

+(void)showAlertAtViewController:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle(action);
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm(action);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

+(void)showAlertWithTextFieldAtViewController:(UIViewController *)viewController
                                        title:(NSString *)title
                                      message:(NSString *)message
                                  cancelTitle:(NSString *)cancelButtonTitle
                                 confirmTitle:(NSString *)confirmButtonTitle
                               confirmHandler:(void(^)(NSString *inputStr))confirm{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //在这里可以设置textfield的样式
        textField.placeholder = @"";
        textField.secureTextEntry = NO;
    }];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    //确认
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取alertcontroller的第一个输入框的内容
        confirm(alertController.textFields.firstObject.text);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlertSheetAtViewController:(UIViewController *)viewController
                        cancelHandler:(void(^)())cancelHandler
                        deleteHandler:(void(^)())deleteHandler
                      privateBtnTitle:(NSString *)privateBtnTitle
                       privateHandler:(void(^)())privateHandler
                        renameHandler:(void(^)())renameHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        deleteHandler();
    }];
    UIAlertAction *privateAction = [UIAlertAction actionWithTitle:privateBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        privateHandler();
    }];
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        renameHandler();
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:privateAction];
    [alertController addAction:renameAction];
    [alertController addAction:deleteAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
