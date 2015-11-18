//
//  SZYDatePickView.h
//  iNote
//
//  Created by 孙中原 on 15/10/19.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYDatePickViewDelegate <NSObject>
-(void)cancelBtnDidClick;
-(void)sureBtnDidClick:(NSString *)selecteDdate;
@end

@interface SZYDatePickView : UIView

@property (nonatomic, weak) id<SZYDatePickViewDelegate> delegate;

@end
