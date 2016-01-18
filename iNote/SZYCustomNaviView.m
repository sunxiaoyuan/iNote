//
//  SZYCustomNaviView.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//在Home页定制的导航栏面板

#import "SZYCustomNaviView.h"
#import "SZYDoubleTextView.h"
#import "SZYNoteBookModel.h"

@interface SZYCustomNaviView ()

@property (nonatomic, strong  ) SZYDoubleTextView *titleView;//标题面板
@property (nonatomic, strong  ) UIButton          *syncBtn;
@property (nonatomic, strong  ) UIButton          *menuBtn;
@property (nonatomic, strong  ) UIButton          *searchBtn;
@property (nonatomic, strong  ) UIImageView       *backgroundImageView;
@property (nonatomic, strong  ) UIImageView       *arrowImageView;
@property (nonatomic, assign  ) BOOL              isListOpen;
@property (nonatomic, strong  ) NSMutableArray    *noteBookListData;//数据源
@property (nonatomic, strong  ) NSString          *currentNoteBookName;
@property (nonatomic, strong  ) NSString          *currentNoteBookNumber;

@end

@implementation SZYCustomNaviView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //底层背景
        [self addSubview:self.backgroundImageView];
        //添加左侧列表按钮
        [self addSubview:self.menuBtn];
        //添加搜索按钮
        [self addSubview:self.searchBtn];
        //添加指示箭头
        [self addSubview:self.arrowImageView];
        //设置导航条的titleView
        [self addSubview:self.titleView];
        
        //添加同步按钮
        //        self.syncBtn = [[UIButton alloc]init];
        //        [self.syncBtn setImage:[UIImage imageNamed:@"btn_sync"] forState:UIControlStateNormal];
        //        [self.syncBtn addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:self.syncBtn];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = UIScreenWidth;
    CGFloat h = NavigationBarHeight;
    
    self.backgroundImageView.frame = self.bounds;
    
    //两侧按钮
    self.menuBtn.frame = CGRectMake(16, 27, 30, 30);
    self.searchBtn.frame = CGRectMake(w - 41, 30, 25, 25);

    //设置导航条的titleView位置
    CGFloat titleW = w * 0.25;
    CGFloat titleX = (w - titleW) / 2;
    self.titleView.frame = CGRectMake(titleX, h * 0.25, titleW, h * 0.8);
    
    //指示箭头位置
    self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.titleView.frame), 35, 12.5, 12.5);
    
    //同步按钮位置
//    self.syncBtn.frame = CGRectMake(w - 72, 32, 20, 20);
    
}

#pragma mark - 公共方法

-(void)setNoteBooksData:(NSMutableArray *)noteBookArr{
    self.noteBookListData = noteBookArr;
    //默认是在全部笔记本下
    [self.titleView setTitle:@"全部笔记" subTitle:[NSString stringWithFormat:@"%ld个笔记",(long)[self getAllNoteAmount]]];
}

#pragma mark - 私有方法

-(void)refreshNaviViewWithState:(BOOL)isNoteBookListOpen{
    
    self.arrowImageView.image = isNoteBookListOpen ? ([UIImage imageNamed:@"arrow_down"]) : ([UIImage imageNamed:@"arrow_up"]);
}

#pragma mark - SZYOpenListViewDelegate 点击阴影收起下拉列表

-(void)openListShouldDisappear:(NSInteger)selectedIndex{
    
    //改变下拉列表状态
    [self openNoteBookListClick];
    //传递选择笔记本的结果
    if ([self.delegate respondsToSelector:@selector(openListHaveDisappear:)]) {
        [self.delegate openListHaveDisappear:selectedIndex];
    }
    

    if (selectedIndex == 0) {
        //选中“全部笔记”
        self.currentNoteBookName = @"全部笔记";
        self.currentNoteBookNumber = [NSString stringWithFormat:@"%ld",[self getAllNoteAmount]];
        
    }else{
        
        SZYNoteBookModel *selectedNoteBook = self.noteBookListData[selectedIndex-1];
        self.currentNoteBookName = selectedNoteBook.title;
        self.currentNoteBookNumber = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedNoteBook.noteList count]];
    }
    
    //刷新导航栏信息
    [self.titleView setTitle:self.currentNoteBookName subTitle:[NSString stringWithFormat:@"%@个笔记",self.currentNoteBookNumber]];
   
}

-(NSInteger)getAllNoteAmount{
    NSInteger sum = 0;
    for (SZYNoteBookModel* tempModel in self.noteBookListData) {
        sum += [tempModel.noteList count];
    }
    return sum;
}

#pragma mark - 通知代理
-(void)syncAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(customNaviViewSyncButtonClick:)]) {
        [self.delegate customNaviViewSyncButtonClick:sender];
    }
}

-(void)openNoteBookListClick{
    
    //通知代理改变下拉列表状态
    if ([self.delegate respondsToSelector:@selector(openListStateShouldChange:)]) {
        [self.delegate openListStateShouldChange:self.isListOpen];
    }
    //改变指示箭头方向
    [self refreshNaviViewWithState:self.isListOpen];
    self.isListOpen = !self.isListOpen;
}

-(void)leftMenuClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(customNaviViewLeftMenuClick:)]) {
        [self.delegate customNaviViewLeftMenuClick:sender];
    }
}

-(void)rightSearchClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(customNaviViewRightSearchClick:)]) {
        [self.delegate customNaviViewRightSearchClick:sender];
    }
}

#pragma mark - getters

-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView){
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recomend_btn_gone"]];
    }
    return _backgroundImageView;
}
-(UIButton *)menuBtn{
    if (!_menuBtn){
        _menuBtn = [[UIButton alloc]init];
        [_menuBtn setImage:[UIImage imageNamed:@"artcleList_icon_white"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(leftMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

-(UIButton *)searchBtn{
    if (!_searchBtn){
        _searchBtn = [[UIButton alloc]init];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon_white"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(rightSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return _arrowImageView;
}

-(SZYDoubleTextView *)titleView{
    if (!_titleView){
        _titleView = [[SZYDoubleTextView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openNoteBookListClick)];
        [_titleView addGestureRecognizer:tap];
    }
    return _titleView;
}

@end
