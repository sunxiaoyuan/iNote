//
//  SZYNoteBookCell.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/25.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookCell.h"

#import "SZYNoteBookModel.h"
#import "SZYSolidaterFactory.h"

//static CGFloat const CellHeight = 100;

@interface SZYNoteBookCell ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *privateBtn;
@property (nonatomic, strong) UIView      *seplineView;

@end

@implementation SZYNoteBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //加载控件
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.privateBtn];
        [self.contentView addSubview:self.seplineView];
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor clearColor];

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat viewW = self.contentView.width;
    CGFloat viewH = self.contentView.height;
    CGFloat leadingSpacing = 20;
    
    self.titleLabel.frame = CGRectMake(leadingSpacing, (viewH - 40)/2, 150, 40);
    CGFloat btnW = 14;
    CGFloat btnH = 16;
    self.privateBtn.frame = CGRectMake(viewW - btnW - leadingSpacing, (viewH - btnH)/2 , btnW, btnH);
    self.seplineView.frame = CGRectMake(0, viewH - 1, viewW - leadingSpacing, 1);
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
    self.privateBtn.hidden = [self.noteBook.isPrivate isEqualToString:@"YES"] ? NO : YES;
;
    //通知强制重新绘制子控件
    [self setNeedsLayout];
}

#pragma mark - getters

-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_17;
        _titleLabel.textColor = UIColorFromRGB(0x888888);
    }
    return _titleLabel;
}

-(UIButton *)privateBtn{
    if (!_privateBtn){
        _privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateBtn setBackgroundImage:[UIImage imageNamed:@"notes_lock"] forState:UIControlStateNormal];
        [_privateBtn addTarget:self action:@selector(privateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _privateBtn.hidden = YES;
    }
    return _privateBtn;
}

-(UIView *)seplineView{
    if (!_seplineView){
        _seplineView = [[UIView alloc]init];
        _seplineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _seplineView;
}


@end
