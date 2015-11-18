//
//  SZYHomeViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYHomeViewController.h"
#import "SZYNoteDisplayCell.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"
#import "SZYDetailViewController.h"
#import "SZYCustomNaviView.h"
#import "SZYOpenListView.h"
#import "SZYNoteFrameInfo.h"
#import "SZYBaseCell.h"
#import "SZYNoteBookList.h"
#import "NSObject+Memento.h"

@interface SZYHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SZYCustomNaviViewDelegate,SZYOpenListViewDelegate>
@property (nonatomic, strong) SZYCustomNaviView *naviView;//定制的导航栏小面板
@property (nonatomic, strong) NSMutableArray    *noteBookArr;//笔记本的列表
@property (nonatomic, strong) UITableView       *tableView;//数据表格
@property (nonatomic, strong) SZYOpenListView   *openListView;//下拉列表
@property (nonatomic, assign) NSInteger         selectedNoteBookIndex;
@property (nonatomic, assign) NSInteger         numberOfRows;
@property (nonatomic, copy  ) NSString          *currentNoteBookName;
@property (nonatomic, copy  ) NSString          *currentNoteBookNumber;
@property (nonatomic, strong) UIImageView       *addNoteImageView;
@property (nonatomic, strong) UIButton          *addNoteBtn;
@property (nonatomic, strong) SZYNoteBookModel  *currentNoteBook;
@property (nonatomic, assign) BOOL              isListOpen;
@end

@implementation SZYHomeViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];


    //初始化UI
    //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //不需要系统自动处理顶部内容伸缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置底色
    [self.view setBackgroundColor:UIColorFromRGB(0xdddddd)];
    //添加组件
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addNoteImageView];
    [self.view addSubview:self.addNoteBtn];
    [self.view addSubview:self.openListView];
    [self.view addSubview:self.naviView];
    
 
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //加载数据
    [self loadData];
    
    //绘制控件
    //数据表格
    self.tableView.frame = CGRectMake(0, NavigationBarHeight, UIScreenWidth, UIScreenHeight-SIZ(44));
    //添加笔记－视图层尺寸，注意要放在viewDidLoad中
    CGFloat iconW = SIZ(60);
    CGFloat trailSpacing = SIZ(30);
    CGFloat bottomSpacing = SIZ(30);
    self.addNoteImageView.frame = CGRectMake(self.view.bounds.size.width-trailSpacing-iconW, self.view.bounds.size.height-iconW-bottomSpacing, iconW, iconW);
    self.addNoteImageView.layer.cornerRadius = CGRectGetHeight([self.addNoteImageView bounds])/2;
    //添加笔记－按钮
    self.addNoteBtn.frame = self.addNoteImageView.frame;
    //导航栏
    self.naviView.frame = CGRectMake(0,0, UIScreenWidth, NavigationBarHeight);
}


#pragma mark - SZYCustomNaviViewDelegate 点击同步 & 点击指示箭头打开笔记本列表

-(void)customNaviViewSyncButtonClick:(UIButton *)sender{
    //执行同步的网络请求
    //同步后的界面刷新等操作
}

-(void)customNaviViewOpenNoteBookListClick:(UITapGestureRecognizer *)sender{
    
    if (self.isListOpen) {
        
        [self closeOpenList];
    }else{
        
        //打开笔记本列表，选择笔记本
        [UIView animateWithDuration:0.3 animations:^{
            self.openListView.frame = CGRectMake(0, NavigationBarHeight, UIScreenWidth, UIScreenHeight);
        }];
        //改变指示箭头方向
        self.naviView.arrowImageView.image = [UIImage imageNamed:@"arrow_up"];
    }
    
    self.isListOpen = !self.isListOpen;
    
}

-(void)customNaviViewLeftMenuClick:(UIButton *)sender{
    //调用父类方法实现
    [super leftMenuClick];
}

-(void)customNaviViewRightSearchClick:(UIButton *)sender{
    [super rightSearchClick];
}


#pragma mark - SZYOpenListViewDelegate 点击阴影收起下拉列表

-(void)haveTouchedShadowView{
    [self closeOpenList];
}

-(void)closeOpenList{
    //收起列表
    [UIView animateWithDuration:0.3 animations:^{
        //向上平移
        self.openListView.frame = CGRectMake(0, -UIScreenHeight, UIScreenWidth, UIScreenHeight);
    }];
    //获取选择的笔记本索引
    self.selectedNoteBookIndex = self.openListView.selectedIndex;
    if (_selectedNoteBookIndex == 0) {
        //选中“全部笔记”
        self.numberOfRows = [self allNoteNumber];
        self.currentNoteBookName = @"全部笔记";
        self.currentNoteBookNumber = [NSString stringWithFormat:@"%ld",(long)self.numberOfRows];
    }else{
        self.currentNoteBook = self.noteBookArr[_selectedNoteBookIndex-1];
        self.numberOfRows = [[self.currentNoteBook noteNumber] integerValue];
        self.currentNoteBookName = self.currentNoteBook.title;
    }
    //刷新导航栏信息
    [self.naviView setCurrentNoteBookName:self.currentNoteBookName NoteBookNumber:self.currentNoteBookNumber];
    //刷新表格数据
    [self.tableView reloadData];
    //改变指示箭头方向
    self.naviView.arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
}

#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"NoteDisplayCell";
    SZYBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [SZYNoteDisplayCell loadFromXib];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SZYNoteModel *note = [self currentNoteAtIndexPath:indexPath];
    SZYNoteFrameInfo *info = [[SZYNoteFrameInfo alloc]initWithNote:note];
    [cell setNote:note FrameInfo:info];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SZYNoteFrameInfo *info = [[SZYNoteFrameInfo alloc]initWithNote:[self currentNoteAtIndexPath:indexPath]];
    return info.cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYDetailViewController * detailVC = [[SZYDetailViewController alloc]initWithNote:[self currentNoteAtIndexPath:indexPath] AndSourceType:SZYFromListType];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(SZYNoteModel *)currentNoteAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedNoteBookIndex == 0) {
        //“全部笔记”
        NSMutableArray *allNoteList = [self allNoteList];
        return allNoteList[indexPath.row];
    }else{
        return [self.noteBookArr[_selectedNoteBookIndex-1] noteList][indexPath.row];
    }
}

#pragma mark - 私有方法

-(void)addNoteClick{
    
    //新增笔记，跳转到详情页编辑
    SZYDetailViewController * detailVC = [[SZYDetailViewController alloc]initWithNote:nil AndSourceType:SZYFromAddType];
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(void)loadData{
    
    //查询到所有笔记本信息
    if (!self.noteBookArr) {
        self.noteBookArr = [NSMutableArray array];
    }
    SZYNoteBookLocalmanager *noteBookLM = (SZYNoteBookLocalmanager *)[SZYLocalManagerFactory managerFactoryWithType:kNoteBookType];
    noteBookLM.solidater = [SZYSolidaterFactory solidaterFctoryWithType:kNoteBookType];
    //获得数据库中所有数据
    self.noteBookArr = [noteBookLM noteBooksByUserId:ApplicationDelegate.userSession.user_id];
    //存储所有笔记本的快照
    SZYNoteBookList *noteBookList = [[SZYNoteBookList alloc]initWithArray:self.noteBookArr];
    [noteBookList saveStateWithKey:kNoteBookListSnapShot];
    
    //初始化配置数据
    self.numberOfRows = [self allNoteNumber];
    self.currentNoteBookName = @"全部笔记";
    self.currentNoteBookNumber = [NSString stringWithFormat:@"%ld",(long)self.numberOfRows];
    self.selectedNoteBookIndex = 0;
    
    //下拉列表的数据源
    [self.openListView refreshOpenList:self.noteBookArr];
    //导航栏数据源
    [self.naviView setCurrentNoteBookName:self.currentNoteBookName NoteBookNumber:self.currentNoteBookNumber];
    
    [self.tableView reloadData];
    
}

//取出全部笔记，组成一个新的数据源
-(NSMutableArray *)allNoteList{
    NSMutableArray *allArr = [[NSMutableArray alloc]init];
    for (SZYNoteBookModel *tempNoteBook in self.noteBookArr) {
        for (SZYNoteModel *tempNote in tempNoteBook.noteList) {
            [allArr addObject:tempNote];
        }
    }
    return allArr;
}

//获取全部笔记数的函数
-(NSInteger)allNoteNumber{
    NSInteger sum = 0;
    for (SZYNoteBookModel* tempModel in self.noteBookArr) {
        sum += [tempModel.noteNumber integerValue];
    }
    return sum;
}


#pragma mark - getters

-(UITableView *)tableView{
    //表格
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

-(SZYOpenListView *)openListView{
    if (_openListView == nil){
        //下拉列表
        _openListView = [[SZYOpenListView alloc]initWithFrame:CGRectMake(0, -UIScreenHeight, UIScreenWidth, UIScreenHeight)];
        _openListView.delegate = self;
        
    }
    return _openListView;
}

-(UIImageView *)addNoteImageView{
    if (_addNoteImageView == nil){
        //圆形图标
        _addNoteImageView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_note_black"]];
        _addNoteImageView.layer.masksToBounds = YES;
        _addNoteImageView.clipsToBounds = YES;
        _addNoteImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _addNoteImageView;
}

-(UIButton *)addNoteBtn{
    if (_addNoteBtn == nil){
        //写笔记圆形按钮
        _addNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNoteBtn addTarget:self action:@selector(addNoteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNoteBtn;
}

//自定义导航栏
-(SZYCustomNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYCustomNaviView alloc]init];
        _naviView.delegate = self;
        [_naviView setCurrentNoteBookName:self.currentNoteBookName NoteBookNumber:self.currentNoteBookNumber];
    }
    return _naviView;
}

@end
