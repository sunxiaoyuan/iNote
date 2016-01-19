//
//  SZYNoteFrameInfo.h
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYCellState.h"
@class SZYNoteModel;

@interface SZYNoteFrameInfo : NSObject
//单元格高度
@property (nonatomic, assign) CGFloat          cellHeight;
//控件frame
@property (nonatomic, assign) CGRect noteImageViewFrame;
@property (nonatomic, assign) CGRect noteVideoViewFrame;
@property (nonatomic, assign) CGRect titleLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect contentLabelFrame;
@property (nonatomic, assign) CGRect allInfoBtnFrame;


-(instancetype)initWithNote:(SZYNoteModel *)note Type:(SZYCellStateType)type;

@end
