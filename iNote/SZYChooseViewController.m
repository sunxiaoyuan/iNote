//
//  SZYChooseViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/26.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYChooseViewController.h"
#import "SZYDetailNaviView.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"
#import "SZYOpenListCellCell.h"
#import "SZYchooseCell.h"
#import "SZYNoteBookList.h"
#import "NSObject+Memento.h"

@interface SZYChooseViewController ()<SZYDetailNaviViewDelegate,UITableViewDelegate,UITableViewDataSource>

//导航栏
@property (nonatomic, strong) SZYDetailNaviView *naviView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *allNoteBookArr;//笔记本的列表
@property (nonatomic, assign) NSInteger         chosenRow;
@end

@implementation SZYChooseViewController

- (instancetype)initWithSelectedRow:(NSInteger)row
{
    self = [super init];
    if (self) {
        //拿到选中的笔记本索引
        self.chosenRow = row;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //读取笔记本列表的快照
    SZYNoteBookList *noteBookList = [[SZYNoteBookList alloc]init];
    [noteBookList recoverFromStateWithKey:kNoteBookListSnapShot];
    self.allNoteBookArr = [noteBookList.noteBookList mutableCopy];
    
    
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.tableView];
    [self clearExtraLine:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏
    self.naviView.frame = CGRectMake(0, 0, UIScreenWidth, NavigationBarHeight);
    //表格
    self.tableView.frame = CGRectMake(0, NavigationBarHeight, UIScreenWidth, UIScreenHeight-64);
}

//去掉下方多余的线
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - TableViewDelegate和TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allNoteBookArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SZYOpenListCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SZYchooseCell";
    
    SZYchooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SZYchooseCell class]) owner:nil options:nil] lastObject];
    }
    SZYNoteBookModel *noteBook = self.allNoteBookArr[indexPath.row];
    cell.titleLabel.text = noteBook.title;
    //只显示选中行的图片
    if (indexPath.row == self.chosenRow) {
        cell.indicatorImageView.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //传值：notebook对象
    [self.delegate didChooseNoteBook:self.allNoteBookArr[indexPath.row] AtRow:indexPath.row];
    //调转到笔记列表页
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - SZYDetailNaviViewDelegate

-(void)backBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters

-(SZYDetailNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYDetailNaviView alloc]init];
        _naviView.delegate = self;
        _naviView.doneBtn.hidden = YES;
        _naviView.moreBtn.hidden = YES;
    }
    return _naviView;
}

-(UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


@end
