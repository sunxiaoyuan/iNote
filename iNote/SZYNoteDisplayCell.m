//
//  SZYNoteDisplayCell.m
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteDisplayCell.h"
#import "SZYNoteModel.h"
#import "UIImage+Size.h"

@interface SZYNoteDisplayCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UILabel *videoFileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoFileSizeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoIcon;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIcon;


@end

@implementation SZYNoteDisplayCell

- (void)awakeFromNib {
    //标题
    self.titleLabel.font = FONT_17;
    self.titleLabel.textColor = UIColorFromRGB(0x000000);
    
    //时间
    self.timeLabel.font = FONT_12;
    self.timeLabel.textColor = ThemeColor;
    
    //正文
    self.contentLabel.font = FONT_12;
    self.contentLabel.textColor = UIColorFromRGB(0x000000);

    
    //录音
    self.videoView.layer.cornerRadius = 8.5;
    self.videoView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNote:(SZYNoteModel *)note FrameInfo:(SZYNoteFrameInfo *)info{
    
    ([self checkIfKong:note.title]) ? (self.titleLabel.text = @"无标题笔记"):(self.titleLabel.text  = note.title);
    self.timeLabel.text = note.mendTime;
    self.contentLabel.text = [note contentAtLocal];
    //截取部分图片展示
    self.myImageView.image = [UIImage getSubImage:[note imageAtlocal] mCGRect:info.myImageViewFrame centerBool:NO];

//    [self.videoView setFilName:@"231232413412" FileSize:@"1.2M"];
    
    self.note = note;
    self.info = info;
    
    //通知强制重新绘制子控件
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    self.titleLabel.frame = self.info.titleLabelFrame;
    self.timeLabel.frame = self.info.timeLabelFrame;
    self.contentLabel.frame = self.info.contentLabelFrame;
    self.myImageView.frame = self.info.myImageViewFrame;
    self.videoView.frame = self.info.videoViewFrame;
    self.videoIcon.frame = self.info.videoIconFrame;
    self.videoFileNameLabel.frame = self.info.fileNameFrame;
    self.videoFileSizeLabel.frame = self.info.fileSizeFrame;
    self.arrowIcon.frame = self.info.arrowIconFrame;
    
}

-(BOOL)checkIfKong:(NSString *)value{
    
    if (!value || [value isEqualToString:@""]) {
        return YES;
    }
    return NO;
    
}



@end
