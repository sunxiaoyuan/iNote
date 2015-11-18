//
//  SZYCustomNaviView.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//在Home页定制的导航栏面板

#import "SZYCustomNaviView.h"
#import "SZYDoubleTextView.h"

@interface SZYCustomNaviView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) SZYDoubleTextView *titleView;
@property (nonatomic, strong) UIButton          *syncBtn;
@property (nonatomic, strong) UIButton          *menuBtn;
@property (nonatomic, strong) UIButton          *searchBtn;
@property (nonatomic, strong) UIImageView       *backgroundImageView;


@end

@implementation SZYCustomNaviView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置底色
        self.backgroundColor = [UIColor clearColor];
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.image = [UIImage imageNamed:@"recomend_btn_gone"];
        [self addSubview:self.backgroundImageView];
        
        //添加左侧列表按钮
        self.menuBtn = [[UIButton alloc]init];
        [self.menuBtn setImage:[UIImage imageNamed:@"artcleList_icon_white"] forState:UIControlStateNormal];
        [self.menuBtn addTarget:self action:@selector(leftMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuBtn];
        
        //添加搜索按钮
        self.searchBtn = [[UIButton alloc]init];
        [self.searchBtn setImage:[UIImage imageNamed:@"search_icon_white"] forState:UIControlStateNormal];
        [self.searchBtn addTarget:self action:@selector(rightSearchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.searchBtn];
        
        //添加同步按钮
//        self.syncBtn = [[UIButton alloc]init];
//        [self.syncBtn setImage:[UIImage imageNamed:@"btn_sync"] forState:UIControlStateNormal];
//        [self.syncBtn addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.syncBtn];
        
        //添加指示箭头
        self.arrowImageView = [[UIImageView alloc]init];
        [self.arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
        [self addSubview:self.arrowImageView];
        
        //设置导航条的titleView
        self.titleView = [[SZYDoubleTextView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openNoteBookList:)];
        tap.numberOfTapsRequired = 1;//敲击数
        tap.numberOfTouchesRequired = 1;//手指数
        tap.delegate = self;
        [self.titleView addGestureRecognizer:tap];
        [self addSubview:self.titleView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
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
    self.syncBtn.frame = CGRectMake(w - 72, 32, 20, 20);
    
}

-(void)setCurrentNoteBookName:(NSString *)name NoteBookNumber:(NSString *)number{
    
    [self.titleView setTitle:name subTitle:[NSString stringWithFormat:@"%@个笔记",number]];
}


#pragma mark - 通知代理
-(void)syncAction:(UIButton *)sender{
    //因为是必须实现的，所以不用判断delegate有没有实现方法
    [self.delegate customNaviViewSyncButtonClick:sender];
}

-(void)openNoteBookList:(UITapGestureRecognizer *)sender{
    [self.delegate customNaviViewOpenNoteBookListClick:sender];
}

-(void)leftMenuClick:(UIButton *)sender{
    [self.delegate customNaviViewLeftMenuClick:sender];
}

-(void)rightSearchClick:(UIButton *)sender{
    [self.delegate customNaviViewRightSearchClick:sender];
}

@end
