//
//  SZYIntroView.h
//  iNote
//
//  Created by 孙中原 on 15/9/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYIntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface SZYIntroView : UIView

@property (nonatomic,assign)id<SZYIntroViewDelegate> delegate;

@end
