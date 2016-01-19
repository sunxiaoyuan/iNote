//
//  SZYNoteBookCell.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/25.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< HEAD
@interface SZYNoteBookCell : UITableViewCell

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subTitleLabel;
=======
@class SZYNoteBookModel;



@interface SZYNoteBookCell : UITableViewCell

@property (nonatomic, strong) SZYNoteBookModel *noteBook;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61

@end
