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

@interface SZYNotesViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

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
    
    //不需要系统自动处理顶部内容伸缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //磨砂背景
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"hub_bg"];
    [self.view addSubview:bgImageView];
    
    //加载组件
//    [self.view addSubview:self.addNoteBookBtn];
//    [self.view addSubview:self.sepLineView];
    [self.view addSubview:self.tableView];
    //自定义右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    //初始化数据库工具
    self.noteBookSolidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}

#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noteBookArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NoteBookCell";
    SZYNoteBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SZYNoteBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.noteBook = _noteBookArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteBookModel *noteBook = _noteBookArr[indexPath.row];
    //调转到笔记本展示界面
    SZYNoteBookViewController *noteBookVC = [[SZYNoteBookViewController alloc]initWithTitle:noteBook.title BackButton:YES];
    noteBookVC.currentNoteBook = noteBook;
    [self.navigationController pushViewController:noteBookVC animated:YES];
    
}

//允许直接编辑行
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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

            SZYNoteBookModel *newNoteBook = [[SZYNoteBookModel alloc]initWithID:[NSString stringOfUUID] Title:tf.text UserID:ApplicationDelegate.userSession.user_id IsPrivate:@"NO"];
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

-(void)editBtnClick:(UIButton *)sender{
    
    if (_tableView.isEditing) {
        [self.sepLineView removeFromSuperview];
        self.sepLineView = nil;
        //移动表格视图
        [UIView animateWithDuration:0.3f animations:^{
            self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
            
        } completion:^(BOOL finished) {
            [self.addNoteBookBtn removeFromSuperview];
            self.addNoteBookBtn = nil;
        }];

    }else{
        
        [self.view addSubview:self.addNoteBookBtn];
        //移动表格视图
        [UIView animateWithDuration:0.3f animations:^{
            self.tableView.frame = CGRectMake(0, 45, UIScreenWidth, UIScreenHeight);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view addSubview:self.sepLineView];
            }
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

        //获取笔记本简介列表
        [_noteBookSolidater readAllWithoutNoteListSuccessHandler:^(id result) {
            self.noteBookArr = (NSMutableArray *)result;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"error = %@",errorMsg);
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
        _addNoteBookBtn.frame = CGRectMake((UIScreenWidth-100)/2, 7, 100, 30);
        [_addNoteBookBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
        [_addNoteBookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addNoteBookBtn addTarget:self action:@selector(addNoteBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNoteBookBtn;
}
-(UIView *)sepLineView{
    if (!_sepLineView){
        _sepLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, UIScreenWidth, 1)];
        _sepLineView.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _sepLineView;
}
-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
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
