//
//  SZYNoteBookCell.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/25.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookCell.h"
<<<<<<< HEAD

static CGFloat const CellHeight = 120;

@interface SZYNoteBookCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
=======
#import "SZYNoteBookModel.h"
#import "SZYSolidaterFactory.h"

static CGFloat const CellHeight = 100;

@interface SZYNoteBookCell ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subTitleLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton    *privateBtn;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61

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
<<<<<<< HEAD
=======
        [self.bgImageView addSubview:self.privateBtn];
        
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bgImageView.frame = CGRectMake(15, 10, self.contentView.frame.size.width-30, CellHeight-20);
    self.titleLabel.frame = CGRectMake(15, 5, 150, 40);
<<<<<<< HEAD
    self.subTitleLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+2, 150, 40);
=======
    self.subTitleLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+2, 150, 30);
    CGFloat btnW = 40;
    CGFloat btnH = 20;
    self.privateBtn.frame = CGRectMake(self.bgImageView.width - 15 - btnW, self.subTitleLabel.bottom - btnH , btnW, btnH);
}

#pragma mark - 响应事件
-(void)privateBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.noteBook.isPrivate = sender.selected ? @"YES" : @"NO";
    SZYNoteBookSolidater *noteBookSolidater = [SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];

    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        [noteBookSolidater updateOne:self.noteBook successHandler:^(id result) {
            
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
}

#pragma mark - setters

-(void)setNoteBook:(SZYNoteBookModel *)noteBook{
    
    _noteBook = noteBook;
    self.titleLabel.text = self.noteBook.title;
    self.privateBtn.selected = [self.noteBook.isPrivate isEqualToString:@"YES"] ? YES : NO;
    //通知强制重新绘制子控件
    [self setNeedsLayout];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
}

#pragma mark - getters

-(UIImageView *)bgImageView{
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 8.0;
        _bgImageView.layer.borderWidth = 1.0;
        _bgImageView.layer.borderColor = [ThemeColor CGColor];
<<<<<<< HEAD
    }
    return _bgImageView;
}
=======
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_19;
    }
    return _titleLabel;
}
<<<<<<< HEAD
=======

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = FONT_14;
<<<<<<< HEAD
=======
        _subTitleLabel.backgroundColor = [UIColor orangeColor];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    }
    return _subTitleLabel;
}

<<<<<<< HEAD
=======
-(UIButton *)privateBtn{
    if (!_privateBtn){
        _privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateBtn setTitle:@"公开" forState:UIControlStateNormal];
        [_privateBtn setTitle:@"私密" forState:UIControlStateSelected];
        _privateBtn.titleLabel.font = FONT_11;
        [_privateBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_privateBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        _privateBtn.layer.masksToBounds = YES;
        _privateBtn.layer.cornerRadius = 8.0f;
        _privateBtn.layer.borderColor = [ThemeColor CGColor];
        _privateBtn.layer.borderWidth = 0.8f;
        [_privateBtn addTarget:self action:@selector(privateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateBtn;
}

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61

@end
