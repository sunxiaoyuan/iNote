//
//  SZYNoteBookCell.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/25.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookCell.h"

static CGFloat const CellHeight = 120;

@interface SZYNoteBookCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation SZYNoteBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载控件
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.titleLabel];
        [self.bgImageView addSubview:self.subTitleLabel];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bgImageView.frame = CGRectMake(15, 10, self.contentView.frame.size.width-30, CellHeight-20);
    self.titleLabel.frame = CGRectMake(15, 5, 150, 40);
    self.subTitleLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+2, 150, 40);
}

#pragma mark - getters

-(UIImageView *)bgImageView{
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 8.0;
        _bgImageView.layer.borderWidth = 1.0;
        _bgImageView.layer.borderColor = [ThemeColor CGColor];
    }
    return _bgImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_19;
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = FONT_14;
    }
    return _subTitleLabel;
}


@end
