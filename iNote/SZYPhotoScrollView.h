//
//  SZYPhotoScrollView.h
//  iNote
//
//  Created by 孙中原 on 15/10/16.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYPhotoScrollViewClickDelegate <NSObject>

-(void)addPhotoBtnDidClick:(UIButton *)sender;
-(void)selectPhotoDidClick:(UIButton *)sender;

@end


@interface SZYPhotoScrollView : UIScrollView

@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, weak) id<SZYPhotoScrollViewClickDelegate> aDelegate;

-(NSMutableArray *)setPhoto:(NSMutableArray *)photoList;
@end
