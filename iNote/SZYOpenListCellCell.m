//
//  SZYOpenListCellCell.m
//  iNote
//
//  Created by 孙中原 on 15/10/10.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYOpenListCellCell.h"
#import "SZYNoteBookModel.h"


@interface SZYOpenListCellCell ()

@end

@implementation SZYOpenListCellCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
