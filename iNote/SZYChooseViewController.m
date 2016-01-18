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
#import "SZYchooseCell.h"
#import "SZYNoteSolidater.h"

@interface SZYChooseViewController ()<SZYCustomNaviViewDelegate,UITableViewDelegate,UITableViewDataSource>

//导航栏
@property (nonatomic, strong) SZYDetailNaviView *naviView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *allNoteBookArr;//笔记本的列表
@property (nonatomic, strong) SZYNoteModel      *currentNote;
@end

@implementation SZYChooseViewController

- (instancetype)initWithCurrentNote:(SZYNoteModel *)note
{
    self = [super init];
    if (self) {
        _currentNote = note;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载笔记本列表简介－不加载笔记本下的所有笔记信息
    [self loadNoteBookList];
    
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏
    self.naviView.frame = CGRectMake(0, 0, UIScreenWidth, NavigationBarHeight);
    //表格
    self.tableView.frame = CGRectMake(0, NavigationBarHeight, UIScreenWidth, UIScreenHeight-64);
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
    if ([noteBook.noteBook_id isEqualToString:self.currentNote.noteBook_id_belonged]) {
        cell.indicatorImageView.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //传值：notebook对象
    [self.delegate didChooseNoteBook:self.allNoteBookArr[indexPath.row]];
    //调转到笔记列表页
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - SZYDetailNaviViewDelegate

-(void)backBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 私有方法

-(void)loadNoteBookList{
    
    SZYNoteBookSolidater *noteBookSolidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        [noteBookSolidater readAllWithoutNoteListSuccessHandler:^(id result) {
            self.allNoteBookArr = (NSMutableArray *)result;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
}

#pragma mark - getters

-(SZYDetailNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYDetailNaviView alloc]init];
        _naviView.delegate = self;
        [_naviView hideBarButton];
    }
    return _naviView;
}

-(UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setTableFooterView:[[UIView alloc]init]];
    }
    return _tableView;
}


@end
