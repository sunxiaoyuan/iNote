//
//  SZYCustomNaviView.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYNoteBookModel.h"

@protocol SZYCustomNaviViewDelegate <NSObject>

-(void)customNaviViewSyncButtonClick:(UIButton *)sender;//点击同步
-(void)customNaviViewOpenNoteBookListClick:(UITapGestureRecognizer *)sender;//点击下拉列表
-(void)customNaviViewLeftMenuClick:(UIButton *)sender;//点击左侧列表
-(void)customNaviViewRightSearchClick:(UIButton *)sender;//点击搜索

@end

@interface SZYCustomNaviView : UIView

@property (nonatomic, assign  ) id<SZYCustomNaviViewDelegate> delegate;
@property (nonatomic, strong  ) UIImageView               *arrowImageView;


-(void)setCurrentNoteBookName:(NSString *)name NoteBookNumber:(NSString *)number;

@end
