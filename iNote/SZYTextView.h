//
//  SZYTextView.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/30.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
////实现一个光标可以随手势移动的UITextView

#import <UIKit/UIKit.h>

@interface SZYTextView : UITextView

//区分手势
- (void)requireGestureRecognizerToFail:(UIGestureRecognizer*)gestureRecognizer;

@end
