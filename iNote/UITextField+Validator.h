//
//  UITextField+Validator.h
//  iNote
//
//  Created by 孙中原 on 15/10/13.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Validator)

-(BOOL)isNotEmpty;
-(BOOL)validateUserName;
-(BOOL)validateEmail;
-(BOOL)validatePhoneNumber;
-(BOOL)validatePassWord;

@end
