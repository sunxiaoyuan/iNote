//
//  SZYDetailNaviView.h
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYDetailNaviViewDelegate <NSObject>

@required
-(void)backBtnDidClick;

@optional
-(void)moreBtnDidclick;
-(void)doneBtnDidClick;

@end

@interface SZYDetailNaviView : UIView

@property (nonatomic, strong) UIButton          *doneBtn;
@property (nonatomic, strong) UIButton          *moreBtn;
@property (nonatomic, assign) id<SZYDetailNaviViewDelegate> delegate;

@end
