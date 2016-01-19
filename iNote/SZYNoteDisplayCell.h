//
//  SZYNoteDisplayCell.h
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYCellState.h"
@class SZYNoteModel;
@class SZYNoteFrameInfo;

@protocol SZYNoteDisplayCellDelegate <NSObject>
-(void)allInfoBtnDidClick:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
@end

@interface SZYNoteDisplayCell : UITableViewCell

@property (nonatomic, strong) SZYNoteModel               *note;
@property (nonatomic, strong) SZYNoteFrameInfo           *info;
@property (nonatomic, assign) id<SZYNoteDisplayCellDelegate> delegate;

//初始化方法
+(id)loadFromXib;
//数据源方法
-(void)setNote:(SZYNoteModel *)note FrameInfo:(SZYNoteFrameInfo *)info Type:(SZYCellStateType)type IndexPath:(NSIndexPath *)indexPath;

@end
