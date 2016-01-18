//
//  SZYPhotoChooseView.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/30.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYPhotoChooseViewDelegate <NSObject>

-(void)chooseBtnDidClick:(UIButton *)sender;

@end


@interface SZYPhotoChooseView : UIView

@property (nonatomic, assign) id <SZYPhotoChooseViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame AndImage:(UIImage *)image;


@end
