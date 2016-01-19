//
//  SZYDetailNaviView.h
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYCustomNaviViewDelegate.h"


@interface SZYDetailNaviView : UIView

@property (nonatomic, assign) id<SZYCustomNaviViewDelegate> delegate;

-(void)enterEditingState;

-(void)exitEditingState;

-(void)hideBarButton;

-(void)removeMoreBtn;

@end
