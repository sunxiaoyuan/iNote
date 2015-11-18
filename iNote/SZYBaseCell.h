//
//  SZYBaseCell.h
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYNoteModel.h"
#import "SZYNoteFrameInfo.h"

@interface SZYBaseCell : UITableViewCell

@property (nonatomic, strong) SZYNoteModel *note;
@property (nonatomic, strong) SZYNoteFrameInfo *info;

//初始化方法
+(id)loadFromXib;

//数据源方法
-(void)setNote:(SZYNoteModel *)note FrameInfo:(SZYNoteFrameInfo *)info;

@end
