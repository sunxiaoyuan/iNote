//
//  SZYNotesViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNotesViewController.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"
#import "SZYNoteBookCell.h"
#import "SZYNoteBookViewController.h"
<<<<<<< HEAD
#import "MJRefresh.h"
#import "SZYRefreshHeader.h"
=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61


<<<<<<< HEAD
=======
@interface SZYNotesViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
@property (nonatomic, strong) UITableView          *tableView;//表视图
@property (nonatomic, strong) NSMutableArray       *noteBookArr;
@property (nonatomic, strong) NSIndexPath          *selectIndexPath;
@property (nonatomic, strong) SZYNoteBookModel     *selectNoteBook;
@property (nonatomic, strong) UIButton             *addNoteBookBtn;
@property (nonatomic, strong) UIView               *sepLineView;
@property (nonatomic, strong) UIButton             *rightBtn;
@property (nonatomic, strong) SZYNoteBookSolidater *noteBookSolidater;
@end

@implementation SZYNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
<<<<<<< HEAD
    
    //不需要系统自动处理顶部内容伸缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置底色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //加载组件
    [self.view addSubview:self.addNoteBookBtn];
    [self.view addSubview:self.sepLineView];
    [self.view addSubview:self.tableView];
    //自定义右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    //初始化数据库工具
    self.noteBookSolidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //设置下拉刷新
    [self setHeadRefresh];
    
    self.addNoteBookBtn.frame = CGRectMake((UIScreenWidth-100)/2, 7, 100, 30);
    self.sepLineView.frame = CGRectMake(0, 44, UIScreenWidth, 1);
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}

=======
    //不需要系统自动处理顶部内容伸缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置底色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //加载组件
    [self.view addSubview:self.addNoteBookBtn];
    [self.view addSubview:self.sepLineView];
    [self.view addSubview:self.tableView];
    //自定义右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    //初始化数据库工具
    self.noteBookSolidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    self.addNoteBookBtn.frame = CGRectMake((UIScreenWidth-100)/2, 7, 100, 30);
    self.sepLineView.frame = CGRectMake(0, 44, UIScreenWidth, 1);
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noteBookArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
<<<<<<< HEAD
    return 120;
=======
    return 100;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NoteBookCell";
    SZYNoteBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SZYNoteBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
<<<<<<< HEAD

    }
    SZYNoteBookModel *noteBook = _noteBookArr[indexPath.row];
    cell.titleLabel.text = noteBook.title;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"(%lu个笔记)",(unsigned long)[noteBook.noteList count]];
=======
    }
    cell.noteBook = _noteBookArr[indexPath.row];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteBookModel *noteBook = _noteBookArr[indexPath.row];
    //调转到笔记本展示界面
    SZYNoteBookViewController *noteBookVC = [[SZYNoteBookViewController alloc]initWithTitle:noteBook.title BackButton:YES];
    noteBookVC.currentNoteBook = noteBook;
    [self.navigationController pushViewController:noteBookVC animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteBookModel *noteBook = self.noteBookArr[indexPath.row];
    if ([noteBook.noteBook_id isEqualToString:kDEFAULT_NOTEBOOK_ID]) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndexPath = indexPath;
    self.selectNoteBook = self.noteBookArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //提醒用户数据改变
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除笔记本将导致数据丢失，您确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 101) { //提醒用户数据改变的alert
        if (buttonIndex == 1) {
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
                //数据库中删除
                [_noteBookSolidater deleteOneByID:self.selectNoteBook.noteBook_id successHandler:^(id result) {
                    
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"error = %@",errorMsg);
                }];
            }];
            //数据源中删除(这一步容易遗忘)
            [self.noteBookArr removeObject:self.selectNoteBook];
            
            //局部刷新
            [self.tableView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }else{ //新建笔记本的alert
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
<<<<<<< HEAD
            SZYNoteBookModel *newNoteBook = [[SZYNoteBookModel alloc]init];
            newNoteBook.noteBook_id = [NSString stringOfUUID];
            newNoteBook.user_id_belonged = ApplicationDelegate.userSession.user_id;
            newNoteBook.title = tf.text;
            newNoteBook.isPrivate = @"NO";
=======
            SZYNoteBookModel *newNoteBook = [[SZYNoteBookModel alloc]initWithID:[NSString stringOfUUID] Title:tf.text UserID:ApplicationDelegate.userSession.user_id IsPrivate:@"NO"];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
                //插入一行笔记本数据
                [_noteBookSolidater saveOne:newNoteBook successHandler:^(id result) {
                    
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"error = %@",errorMsg);
                }];
            }];
            [self loadData];
        }
    }
}

#pragma mark - 私有方法

<<<<<<< HEAD
-(void)setHeadRefresh{
    SZYRefreshHeader *header = [SZYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.header = header;
}

=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(void)editBtnClick:(UIButton *)sender{
    
    if (_tableView.isEditing) {
        //移动表格视图
        [UIView animateWithDuration:0.3f animations:^{
            self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
            
        } completion:^(BOOL finished) {
            self.addNoteBookBtn.hidden = YES;
        }];

    }else{
        //移动表格视图
        [UIView animateWithDuration:0.3f animations:^{
            self.tableView.frame = CGRectMake(0, 45, UIScreenWidth, UIScreenHeight);
            self.addNoteBookBtn.hidden = NO;
        }];
    }
    
    //进入或退出表格编辑模式
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    sender.selected = !sender.selected;
    
}

//加载数据，刷新视图
-(void)loadData{
    //查询到当前用户id下的所有笔记本信息
    if (!self.noteBookArr) {
        self.noteBookArr = [NSMutableArray array];
    }
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
<<<<<<< HEAD
        [_noteBookSolidater readAllSuccessHandler:^(id result) {
            self.noteBookArr = (NSMutableArray *)result;
            //停止刷新
            [self.tableView.header endRefreshing];
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"error = %@",errorMsg);

=======
        //获取笔记本简介列表
        [_noteBookSolidater readAllWithoutNoteListSuccessHandler:^(id result) {
            self.noteBookArr = (NSMutableArray *)result;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"error = %@",errorMsg);
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
        }];
    }];
    [self.tableView reloadData];
}

-(void)addNoteBookBtnClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"新建笔记本" message:@"请输入笔记本的标题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 102;
    [alert show];
}

#pragma mark - getters

-(UIButton *)addNoteBookBtn{
    if (!_addNoteBookBtn){
        _addNoteBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNoteBookBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
        [_addNoteBookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addNoteBookBtn addTarget:self action:@selector(addNoteBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addNoteBookBtn.hidden = YES;
    }
    return _addNoteBookBtn;
}
-(UIView *)sepLineView{
    if (!_sepLineView){
        _sepLineView = [[UIView alloc]init];
        _sepLineView.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _sepLineView;
}
-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIButton *)rightBtn{
    if (!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor clearColor];
        _rightBtn.frame = CGRectMake(0, 0, SIZ(40), SIZ(40));
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}




@end
