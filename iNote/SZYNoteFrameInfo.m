//
//  SZYNoteFrameInfo.m
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  VM层，数据视图层－负责视图层跟数据层交互

#import "SZYNoteFrameInfo.h"
#import "SZYNoteModel.h"
#import "NSString+SZYKit.h"

//间距
static CGFloat const kItemLeadingSpacing    = 15;
static CGFloat const kItemVerticalSpacing   = 10;
static CGFloat const kItemHorizontalSpacing = 5;
//图片尺寸
static CGFloat const kImageViewWidth        = 18;
static CGFloat const kImageViewHeight       = 18;
//标题宽度
static CGFloat const kTitleLabelWidth       = 140;
//收起时正文的高度
static CGFloat const kPartContentHeight     = 40;
//展开时正文的高度
static CGFloat const kAllContentHeight      = 120;


@interface SZYNoteFrameInfo ()

//根据内容计算高度
@property (nonatomic, assign) CGFloat          contentHeight;
//cell状态
@property (nonatomic, assign) SZYCellStateType type;
@end

@implementation SZYNoteFrameInfo{
    CGFloat currentX;
}

-(instancetype)initWithNote:(SZYNoteModel *)note Type:(SZYCellStateType)type{
    
    self = [super init];
    if (self) {
        if (note == nil) {
            return self;
        }
        _type = type;
        
        [self noteImageViewFrameMake:note];
        [self noteVideoViewFrame:note];
        [self titleLabelFrameMake:note];
        [self timeLabelFrameMake:note];
        
        [self contentLabelFrameMake:note];
        
        //cell高度
        _cellHeight = CGRectGetMaxY(_allInfoBtnFrame) + kItemVerticalSpacing/2;

    }
    return self;
}

- (void)noteImageViewFrameMake:(SZYNoteModel *)note {
    //图片图标
    if ([self isEmpty:note.image]) {
        _noteImageViewFrame = CGRectMake(kItemLeadingSpacing, kItemVerticalSpacing+2, 0, 0);
        currentX = CGRectGetMaxX(_noteImageViewFrame);
    }else{
        _noteImageViewFrame = CGRectMake(kItemLeadingSpacing, kItemVerticalSpacing+2, kImageViewWidth, kImageViewHeight);
        currentX = CGRectGetMaxX(_noteImageViewFrame)+kItemHorizontalSpacing;
    }
}
- (void)noteVideoViewFrame:(SZYNoteModel *)note {
    //录音图标
    if ([self isEmpty:note.video]) {
        _noteVideoViewFrame = CGRectMake(currentX, kItemVerticalSpacing+2, 0, 0);
        currentX = CGRectGetMaxX(_noteVideoViewFrame);
    }else{
        _noteVideoViewFrame = CGRectMake(currentX, kItemVerticalSpacing+2, kImageViewWidth, kImageViewHeight);
        currentX = CGRectGetMaxX(_noteVideoViewFrame) + kItemHorizontalSpacing;
    }
}

- (void)titleLabelFrameMake:(SZYNoteModel *)note {
    //标题
    CGFloat titleX = currentX;
    CGFloat titleY = kItemVerticalSpacing;
    CGFloat titleW = kTitleLabelWidth;
    if ([self isEmpty:note.image]) titleW += (kImageViewWidth+kItemHorizontalSpacing);
    if ([self isEmpty:note.video]) titleW += (kImageViewWidth+kItemHorizontalSpacing);
    CGSize size = [note.title sizeWithAttributes:@{NSFontAttributeName:FONT_17}];
    _titleLabelFrame = CGRectMake(titleX , titleY , titleW, size.height);
    
}

- (void)timeLabelFrameMake:(SZYNoteModel *)note {
    //时间
    CGSize size = [note.mendTime sizeWithAttributes:@{NSFontAttributeName:FONT_12}];
    CGFloat timeX = UIScreenWidth - kItemLeadingSpacing - size.width;
    CGFloat timeY = CGRectGetMaxY(_titleLabelFrame)-size.height;
    _timeLabelFrame = CGRectMake(timeX, timeY, size.width, size.height);
}

- (void)contentLabelFrameMake:(SZYNoteModel *)note {

    if ([self isEmpty:[note contentAtLocal]]) {
        _contentLabelFrame  = CGRectMake(kItemLeadingSpacing, CGRectGetMaxY(_titleLabelFrame)+ kItemVerticalSpacing/2, 0, 0);
        _allInfoBtnFrame = [self allInfoBtnFrameMakeWithState:NO];
    }else{
        
        [self adaptContentLabelFrame:[note contentAtLocal]];
    }
}

-(void)adaptContentLabelFrame:(NSString *)content{
    
    //正文
    CGFloat contentX = kItemLeadingSpacing;
    CGFloat contentW = UIScreenWidth - 2 * contentX;
    CGFloat contentY = CGRectGetMaxY(_titleLabelFrame) + kItemVerticalSpacing/2;
    CGSize size = [content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_16} context:nil].size;
    _contentHeight = size.height;
    
    switch (_type) {
            
        case SZYCellStateType_Part: {
            
            if (_contentHeight < 40) {
                _contentLabelFrame = CGRectMake(contentX, contentY, contentW, _contentHeight);
                //没有按钮
                _allInfoBtnFrame = [self allInfoBtnFrameMakeWithState:NO];
            }else{
                _contentLabelFrame = CGRectMake(contentX, contentY, contentW, kPartContentHeight);
                //有按钮
                _allInfoBtnFrame = [self allInfoBtnFrameMakeWithState:YES];
            }

            break;
        }
        case SZYCellStateType_All: {
            
            if (_contentHeight >= 40 && _contentHeight < 150) {
                _contentLabelFrame = CGRectMake(contentX, contentY, contentW, _contentHeight);
                _allInfoBtnFrame = [self allInfoBtnFrameMakeWithState:YES];
            }else if (_contentHeight > 150){
                _contentLabelFrame = CGRectMake(contentX, contentY, contentW, kAllContentHeight);
                _allInfoBtnFrame = [self allInfoBtnFrameMakeWithState:YES];
            }

            break;
        }
        default: {
            break;
        }
    }
}

-(CGRect)allInfoBtnFrameMakeWithState:(BOOL)isShow{
    if (!isShow) {
        return  CGRectMake(0, CGRectGetMaxY(_contentLabelFrame), 0, 0);
    }else{
        return  CGRectMake(kItemLeadingSpacing, CGRectGetMaxY(_contentLabelFrame), 60, 25);
    }
}


-(BOOL)isEmpty:(NSString *)value{
    return (!value || [value isEqualToString:@""]);
}


@end
