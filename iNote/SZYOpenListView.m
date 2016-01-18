//
//  SZYOpenListView.m
//  iNote
//
//  Created by 孙中原 on 15/10/10.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYOpenListView.h"
#import "SZYNoteBookModel.h"
#import "SZYOpenListCellCell.h"

@interface SZYOpenListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView         *shadowView;//下方的阴影遮罩，点击收起OpenListView
@property (nonatomic, strong) UITableView    *noteBookTable;
@property (nonatomic, assign) NSInteger      selectedIndex;
@property (nonatomic, strong) NSMutableArray *noteBookListData;//数据源

@end

@implementation SZYOpenListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.noteBookTable];
        [self addSubview:self.shadowView];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.noteBookTable.frame = CGRectMake(0, 0, w, h * 0.75);
    self.shadowView.frame = CGRectMake(0, CGRectGetMaxY(_noteBookTable.frame), w , h * 0.25);
}


#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_noteBookListData count] + 1; //多出一行给“全部笔记”
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SZYOpenListCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"全部笔记";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        static NSString *identifier = @"OpenListCell";
        SZYOpenListCellCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SZYOpenListCellCell class]) owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        SZYNoteBookModel *noteBook = _noteBookListData[indexPath.row - 1];
        [cell setNoteBookModel:noteBook];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取选择的笔记本索引
    self.selectedIndex = indexPath.row;
    //通知代理，收起下拉列表
    [self closeNoteBookList];
    
}

#pragma mark - 通知代理
-(void)closeNoteBookList{
    
    [self.delegate openListShouldDisappear:self.selectedIndex];
}

-(void)refreshOpenList:(NSMutableArray *)dataArr{
    
    self.noteBookListData = dataArr;
    [self.noteBookTable reloadData];
}

-(void)makeTranslateAnimation:(BOOL)isUp {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = isUp ?  CGAffineTransformIdentity :CGAffineTransformMakeTranslation(0, UIScreenHeight - NavigationBarHeight);
    }];
}

#pragma mark - getters

-(UITableView *)noteBookTable{
    if (!_noteBookTable){
        _noteBookTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _noteBookTable.delegate = self;
        _noteBookTable.dataSource = self;
    }
    return _noteBookTable;
}
-(UIView *)shadowView{
    if (!_shadowView){
        _shadowView = [[UIView alloc]init];
        [_shadowView setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
        [_shadowView setAlpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeNoteBookList)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

@end
