//
//  SZYNoteDisplayCell.m
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteDisplayCell.h"
#import "SZYNoteModel.h"
#import "SZYNoteFrameInfo.h"

@interface SZYNoteDisplayCell ()

@property (strong, nonatomic) IBOutlet UILabel          *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel          *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel          *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView      *notePicImageView;
@property (strong, nonatomic) IBOutlet UIImageView      *noteVideoImageView;
@property (strong, nonatomic) IBOutlet UIButton         *allInfoBtn;
@property (nonatomic, strong) NSIndexPath               *indexPath;
- (IBAction)allInfobtnClick:(UIButton *)sender;

@end

@implementation SZYNoteDisplayCell

+(id)loadFromXib{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    //标题
    self.titleLabel.font = FONT_18;
    self.titleLabel.textColor = UIColorFromRGB(0x000000);
    
    //时间
    self.timeLabel.font = FONT_12;
    self.timeLabel.textColor = UIColorFromRGB(0x888888);
    
    //正文
    self.contentLabel.font = FONT_14;
    self.contentLabel.textColor = UIColorFromRGB(0x888888);
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //展开按钮
    [self.allInfoBtn setTitle:@"点击展开" forState:UIControlStateNormal];
    [self.allInfoBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [self.allInfoBtn setTitle:@"点击收起" forState:UIControlStateSelected];
    [self.allInfoBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
    self.allInfoBtn.titleLabel.font = FONT_13;
    self.allInfoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
}

-(void)setNote:(SZYNoteModel *)note FrameInfo:(SZYNoteFrameInfo *)info Type:(SZYCellStateType)type IndexPath:(NSIndexPath *)indexPath{
    
    self.titleLabel.text  = note.title;
    self.timeLabel.text = note.mendTime;
    self.contentLabel.text = [note contentAtLocal];
    
    //改变contentLabel样式
    if (type == SZYCellStateType_Part) {
        self.contentLabel.numberOfLines = 2;
    }else{
        self.contentLabel.numberOfLines = 6;
    }
    //VM-V
    self.note = note;
    self.info = info;
    self.indexPath = indexPath;
    
    //通知强制重新绘制子控件
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.notePicImageView.frame   = self.info.noteImageViewFrame;
    self.noteVideoImageView.frame = self.info.noteVideoViewFrame;
    self.titleLabel.frame         = self.info.titleLabelFrame;
    self.timeLabel.frame          = self.info.timeLabelFrame;
    self.contentLabel.frame       = self.info.contentLabelFrame;
    self.allInfoBtn.frame         = self.info.allInfoBtnFrame;
}



- (IBAction)allInfobtnClick:(UIButton *)sender {
    
    [self.delegate allInfoBtnDidClick:sender IndexPath:self.indexPath];
    
}
@end
