//
//  SZYMenuView.h
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYMenuViewDelegate <NSObject>

-(void)menuBtnDidClick:(UIButton *)sender;


@end

@interface SZYMenuView : UIView

@property (nonatomic, assign) id<SZYMenuViewDelegate> delegate;

@end
