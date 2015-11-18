//
//  SZYInputText.m
//  iNote
//
//  Created by 孙中原 on 15/10/14.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYInputText.h"
#import "UIView+SZY.h"

#define kSZYTextFieldWidth SIZ(230)
#define kSZYTextFieldHeight SIZ(44)

@implementation SZYInputText

- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = kSZYTextFieldWidth;
    textField.height = kSZYTextFieldHeight;
    textField.centerX = centerX;
    textField.y = textY;
    textField.placeholder = point;
    textField.font = FONT_16;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //下方分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kSZYTextFieldHeight-SIZ(0.5), kSZYTextFieldWidth, SIZ(0.5))];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor grayColor];
    [textField addSubview:view];

    //左侧图标
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
    if (icon) {
        iconView.width = SIZ(34);
    }
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

@end
