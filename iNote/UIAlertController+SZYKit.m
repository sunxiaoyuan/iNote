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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
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


+(void)showAlertAtViewController:(UIViewController *)viewController
                       withTitle:(NSString *)title
                     withMessage:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                  confirmHandler:(confirm)confirm{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm(action);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
  
}

+(void)showAlertAtViewController:(UIViewController *)viewController
                       withTitle:(NSString *)title
                     withMessage:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
