//
//  SZYNoteFrameInfo.m
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteFrameInfo.h"

//控件左间距
#define kSZYNoteShowCellSpacing SIZ(13)
#define kSZYNoteShowCellVerticalSpacing SIZ(3)

//图片尺寸
#define kSZYNoteShowCellImageWidth SIZ(130)
#define kSZYNoteShowCellImageHeight SIZ(80)
//录音尺寸
#define kSZYNoteShowCellVideoWidth SIZ(220)
#define kSZYNoteShowCellVideoHeight SIZ(40)
//分割区域高度
#define kSZYNoteShowCellSeperatorHeight SIZ(5)
//录音图标尺寸
#define kSZYNoteShowCellVideoIconWidth SIZ(34)
#define kSZYNoteShowCellVideoIconHeight SIZ(34)
//箭头图标尺寸
#define kSZYNoteShowCellArrowIconWidth  SIZ(24)
#define kSZYNoteShowCellArrowIconHeight SIZ(24)
//录音文件信息尺寸
#define kSZYNoteShowCellFileInfoHeight  SIZ(20)


@implementation SZYNoteFrameInfo

-(id)initWithNote:(SZYNoteModel *)note{
    
    self = [super init];
    if (self) {
        if (note == nil) {
            return self;
        }
        
        SZYCommonToolClass *commTools = [[SZYCommonToolClass alloc]init];
        
        //标题
        CGFloat titleX = kSZYNoteShowCellSpacing;
        CGFloat titleY = kSZYNoteShowCellVerticalSpacing;
        CGFloat titleW = UIScreenWidth - 2*titleX;
        NSString *title = [NSString string];
        //强制给予一个标题
        ([self checkIfKong:note.title]) ? (title = @"无标题笔记"):(title = note.title);
        CGSize size = [commTools newLabelSizeWithContent:title Font:FONT_17 IsSngle:YES Width:0];
        self.titleLabelFrame = CGRectMake(titleX , titleY + SIZ(3), titleW, size.height);
        
        //时间
        size = [commTools newLabelSizeWithContent:note.mendTime Font:FONT_12 IsSngle:YES Width:0];
        CGFloat timeX = kSZYNoteShowCellSpacing;
        CGFloat timeY = CGRectGetMaxY(self.titleLabelFrame) + kSZYNoteShowCellVerticalSpacing;
        self.timeLabelFrame = CGRectMake(timeX, timeY, size.width, size.height);
        
        //正文
        CGFloat contentX = kSZYNoteShowCellSpacing;
        CGFloat contentW = UIScreenWidth - 2 * contentX;
        CGFloat contentY = CGRectGetMaxY(self.timeLabelFrame) + kSZYNoteShowCellVerticalSpacing;
        if ([self checkIfKong:note.content]) {
            //当正文不存在时，我们必须拿到下一个空间X，Y轴的起始位置
            self.contentLabelFrame  = CGRectMake(contentX, CGRectGetMaxY(self.timeLabelFrame), 0, 0);
        }else{
            size = [commTools newLabelSizeWithContent:[note content] Font:FONT_14 IsSngle:YES Width:0];
            self.contentLabelFrame = CGRectMake(contentX, contentY, contentW, size.height);
        }
        
        //图片
        CGFloat myImageViewX = kSZYNoteShowCellSpacing;
        CGFloat myImageViewY = CGRectGetMaxY(self.contentLabelFrame) + 3*kSZYNoteShowCellVerticalSpacing;
        if ([self checkIfKong:note.image]) {
            self.myImageViewFrame = CGRectMake(myImageViewX, CGRectGetMaxY(self.contentLabelFrame), 0, 0);
        }else{
            self.myImageViewFrame = CGRectMake(myImageViewX, myImageViewY, kSZYNoteShowCellImageWidth,kSZYNoteShowCellImageHeight);
        }
        
        //录音
        CGFloat videoViewX = kSZYNoteShowCellSpacing;
        CGFloat videoViewY = CGRectGetMaxY(self.myImageViewFrame) + 3*kSZYNoteShowCellVerticalSpacing;
        if ([self checkIfKong:note.video]) {
            self.videoViewFrame = CGRectMake(videoViewX,CGRectGetMaxY(self.myImageViewFrame), 0, 0);
        }else{
            
            self.videoViewFrame = CGRectMake(videoViewX, videoViewY, kSZYNoteShowCellVideoWidth, kSZYNoteShowCellVideoHeight);
            self.videoIconFrame = CGRectMake(SIZ(6), (kSZYNoteShowCellVideoHeight-kSZYNoteShowCellVideoIconHeight)/2, kSZYNoteShowCellVideoIconWidth, kSZYNoteShowCellVideoIconHeight);
            
            self.fileNameFrame = CGRectMake(CGRectGetMaxX(self.videoIconFrame)+SIZ(3), (kSZYNoteShowCellVideoHeight-2*kSZYNoteShowCellFileInfoHeight)/2, SIZ(170), kSZYNoteShowCellFileInfoHeight);
            self.fileSizeFrame = CGRectMake(CGRectGetMaxX(self.videoIconFrame)+SIZ(3), CGRectGetMaxY(self.fileNameFrame), SIZ(70), kSZYNoteShowCellFileInfoHeight);
            
            self.arrowIconFrame = CGRectMake(kSZYNoteShowCellVideoWidth-SIZ(6)-kSZYNoteShowCellArrowIconWidth, (kSZYNoteShowCellVideoHeight-kSZYNoteShowCellArrowIconHeight)/2, kSZYNoteShowCellArrowIconWidth, kSZYNoteShowCellArrowIconHeight);
        }

        self.cellHeight = CGRectGetMaxY(self.videoViewFrame) + SIZ(10);

        
    }
    return self;
   
}

-(BOOL)checkIfKong:(NSString *)value{
    
    if (!value || [value isEqualToString:@""]) {
        return YES;
    }
    return NO;
    
}


@end
