//
//  SZYToolView.h
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYToolViewDelegate <NSObject>

-(void)addPictureClick;
-(void)addVideoClick;
-(void)adjustFontClick;
-(void)hideKeyBoardClick;

@end

@interface SZYToolView : UIView

@property (nonatomic, assign) id<SZYToolViewDelegate> delegate;

@end
