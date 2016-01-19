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
#import "SZYNoteFrameInfo.h"
#import "SZYNoteBookList.h"
#import "NSObject+Memento.h"
#import "SZYRefreshHeader.h"
#import "MJRefresh.h"
#import "SZYMenuButton.h"
#import "SZYCellState.h"


@interface SZYHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SZYCustomNaviViewDelegate,SZYNoteDisplayCellDelegate>

@property (nonatomic, strong) SZYCustomNaviView   *naviView;//定制的导航栏小面板
@property (nonatomic, strong) SZYOpenListView     *openListView;//下拉列表
@property (nonatomic, strong) NSMutableArray      *noteBookArr;//笔记本的列表
@property (nonatomic, strong) UITableView         *tableView;//数据表格
@property (nonatomic, assign) NSInteger           selectedNoteBookIndex;
@property (nonatomic, assign) NSInteger           numberOfRows;
@property (nonatomic, strong) SZYMenuButton       *addNoteBtn;
@property (nonatomic, strong) NSMutableDictionary *cellStateDict;

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
    self.cellStateDict = [NSMutableDictionary dictionary];
    //添加组件
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addNoteBtn];
    [self.view addSubview:self.openListView];
    [self.view addSubview:self.naviView];
    self.openListView.delegate = self.naviView;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //加载数据
    [self loadData];
    
    //绘制控件
    //数据表格
    self.tableView.frame = CGRectMake(0, 64, UIScreenWidth, UIScreenHeight-64);
    //添加笔记－视图层尺寸，注意要放在viewDidLoad中
    CGFloat iconW = SIZ(80);
    CGFloat trailSpacing = SIZ(30);
    CGFloat bottomSpacing = SIZ(30);
    //添加笔记－按钮
    self.addNoteBtn.transform = CGAffineTransformIdentity;
    self.addNoteBtn.alpha = 1;
    self.addNoteBtn.frame = CGRectMake(self.view.bounds.size.width-trailSpacing-iconW, self.view.bounds.size.height-iconW-bottomSpacing, iconW, iconW);
    //导航栏
    self.naviView.frame = CGRectMake(0,0, UIScreenWidth, NavigationBarHeight);
}


#pragma mark - SZYCustomNaviViewDelegate 点击同步 & 点击指示箭头打开笔记本列表

-(void)customNaviViewSyncButtonClick:(UIButton *)sender{
    //执行同步的网络请求
    //同步后的界面刷新等操作
}

-(void)customNaviViewLeftMenuClick:(UIButton *)sender{
    //调用父类方法实现
    [super leftMenuClick];
}

-(void)customNaviViewRightSearchClick:(UIButton *)sender{
    [super rightSearchClick];
}

-(void)openListStateShouldChange:(BOOL)isListOpen{
    
    [self.openListView makeTranslateAnimation:isListOpen];
}

-(void)openListHaveDisappear:(NSInteger)selectedIndex{
    
    self.selectedNoteBookIndex = selectedIndex;
    //如果选中全部，需要更新行数
<<<<<<< HEAD
    if (_selectedNoteBookIndex == 0) self.numberOfRows = [self allNoteNumber];
=======
    if (_selectedNoteBookIndex == 0){
        self.numberOfRows = [self allNoteNumber];
    }else{
        self.numberOfRows = [self.noteBookArr[_selectedNoteBookIndex - 1] noteList].count;
    }
    
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:[self currentNoteAtIndexPath:indexPath] Type:[cellState integerValue]];
    return info.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"NoteDisplayCell";
    SZYNoteDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [SZYNoteDisplayCell loadFromXib];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    SZYNoteModel *note = [self currentNoteAtIndexPath:indexPath];
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:[self currentNoteAtIndexPath:indexPath] Type:[cellState integerValue]];
    [cell setNote:note FrameInfo:info Type:[cellState integerValue] IndexPath:indexPath];
    return cell;
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

#pragma mark - SZYNoteDisplayCellDelegate

-(void)allInfoBtnDidClick:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.cellStateDict setObject:@(SZYCellStateType_All) forKey:@(indexPath.row)];
    }else{
        [self.cellStateDict setObject:@(SZYCellStateType_Part) forKey:@(indexPath.row)];
    }
    [self.tableView reloadData];
}

#pragma mark - 私有方法

////下拉加载数据
//- (void)loadNewData
//{
//    //模拟1秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 拿到当前的下拉刷新控件，结束刷新状态
//        [self.tableView.header endRefreshing];
//    });
//}

-(void)addNoteClick{
    
    [self performSelector:@selector(jumpToDatail) withObject:nil afterDelay:0.1];
    
    [UIView animateWithDuration:0.2 animations:^{
        //迎面放大
        self.addNoteBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        //消失效果
        self.addNoteBtn.alpha = 0;
    }];
}

-(void)jumpToDatail{
    //跳转到详情页编辑
    SZYDetailViewController * detailVC = [[SZYDetailViewController alloc]initWithNote:nil AndSourceType:SZYFromAddType];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)loadData{
    
    //查询到所有笔记本信息
    if (!self.noteBookArr) {
        self.noteBookArr = [NSMutableArray array];
    }
    
    SZYNoteBookSolidater *solidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
    //在主线程中到数据库查询数据，这里需要阻塞主线程
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        //获得数据库中所有数据
        [solidater readAllSuccessHandler:^(id result) {
            self.noteBookArr = (NSMutableArray *)result;
            [self.tableView.header endRefreshing];
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];

    //存储所有笔记本的快照
    SZYNoteBookList *noteBookList = [[SZYNoteBookList alloc]initWithArray:self.noteBookArr];
    [noteBookList saveStateWithKey:kNoteBookListSnapShot];
    
    //初始化配置数据
    //默认加载"全部笔记"
    self.numberOfRows = [self allNoteNumber];
    self.selectedNoteBookIndex = 0;
    
    //导航栏数据源
    [self.naviView setNoteBooksData:self.noteBookArr];
    //下拉列表数据源
    [self.openListView refreshOpenList:self.noteBookArr];
    //更新cell状态字典,全部置成收起状态
    for (int i = 0; i < self.numberOfRows; i++) {
        [self.cellStateDict setObject:@(SZYCellStateType_Part) forKey:@(i)];
    }
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
        sum += [tempModel.noteList count];
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
        
        //普通header
<<<<<<< HEAD
//            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//            //设置状态栏
//            header.stateLabel.hidden = NO;
//            header.stateLabel.font = FONT_11;
//            header.stateLabel.textColor = UIColorFromRGB(0xdcdcdc);
//            //设置时间栏
//            header.lastUpdatedTimeLabel.hidden = YES;
//            header.lastUpdatedTimeLabel.font = FONT_11;
//            header.lastUpdatedTimeLabel.textColor = UIColorFromRGB(0xdcdcdc);
=======
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        //设置状态栏
//        header.stateLabel.hidden = NO;
//        header.stateLabel.font = FONT_11;
//        header.stateLabel.textColor = UIColorFromRGB(0xdcdcdc);
//        //设置时间栏
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.lastUpdatedTimeLabel.font = FONT_11;
//        header.lastUpdatedTimeLabel.textColor = UIColorFromRGB(0xdcdcdc);
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
        
        //动态GIFheader
        SZYRefreshHeader *header = [SZYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = NO;
        header.stateLabel.font = FONT_11;
        header.stateLabel.textColor = UIColorFromRGB(0xdcdcdc);
        _tableView.header = header;
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

-(SZYMenuButton *)addNoteBtn{
    if (_addNoteBtn == nil){
        //写笔记圆形按钮
        _addNoteBtn = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        [_addNoteBtn setImage:[UIImage imageNamed:@"add_note_black"] forState:UIControlStateNormal];
        CGFloat margin = SIZ(10);
        [_addNoteBtn setImageEdgeInsets:UIEdgeInsetsMake(margin, margin, margin, margin)];
        [_addNoteBtn addTarget:self action:@selector(addNoteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNoteBtn;
}

//自定义导航栏
-(SZYCustomNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYCustomNaviView alloc]init];
        _naviView.delegate = self;
    }
    return _naviView;
}

-(SZYOpenListView *)openListView{
    if (_openListView == nil){
        //下拉列表
        CGFloat opListH = UIScreenHeight - NavigationBarHeight;
        _openListView = [[SZYOpenListView alloc]initWithFrame:CGRectMake(0, -(opListH - NavigationBarHeight), UIScreenWidth, opListH)];
    }
    return _openListView;
}

@end
