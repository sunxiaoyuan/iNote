//
//  SZYNoteFrameInfo.h
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYNoteModel.h"

@interface SZYNoteFrameInfo : NSObject

//单元格高度
@property (nonatomic, assign) float cellHeight;

//控件frame
@property (nonatomic, assign) CGRect titleLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect contentLabelFrame;
@property (nonatomic, assign) CGRect myImageViewFrame;
@property (nonatomic, assign) CGRect videoViewFrame;
@property (nonatomic, assign) CGRect videoIconFrame;
@property (nonatomic, assign) CGRect arrowIconFrame;
@property (nonatomic, assign) CGRect fileNameFrame;
@property (nonatomic, assign) CGRect fileSizeFrame;



-(id)initWithNote:(SZYNoteModel *)note;

@end
