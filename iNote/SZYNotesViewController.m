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
#import "UIAlertController+SZYKit.h"

@interface SZYNotesViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView          *tableView;//表视图
@property (nonatomic, strong) NSMutableArray       *noteBookArr;
@property (nonatomic, strong) NSIndexPath          *selectIndexPath;
@property (nonatomic, strong) SZYNoteBookModel     *selectNoteBook;
@property (nonatomic, strong) UIButton             *rightBtn;
@property (nonatomic, strong) SZYNoteBookSolidater *noteBookSolidater;
@property (nonatomic ,strong) UILongPressGestureRecognizer *longPressGuesture;

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
    //添加长按手势
    [self.view addSubview:self.tableView];
    [self.tableView addGestureRecognizer:self.longPressGuesture];
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

#pragma mark - 私有方法

-(void)longPressToDo:(UILongPressGestureRecognizer *)guesture{

    if (guesture.state == UIGestureRecognizerStateBegan)
    {
        //获取手势点坐标
        CGPoint point = [guesture locationInView:self.tableView];
        //根据坐标判断所属哪一行
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        //由于“默认笔记本”不能被编辑，直接跳出
        if (!indexPath || indexPath.row == 0) return;
        //改变选中行的状态
        [self setCellChosen:YES forRowAtIndexPath:indexPath];
        //设置弹出框的第一行标题
        SZYNoteBookModel *currentNoteBook = self.noteBookArr[indexPath.row];
        NSString *privateBtnTitle = [currentNoteBook.isPrivate isEqualToString:@"YES"] ? @"设为公开" : @"设为私密";
        [UIAlertController showAlertSheetAtViewController:self cancelHandler:^{
            //取消选中状态
            [self setCellChosen:NO forRowAtIndexPath:indexPath];
        } deleteHandler:^{
            //删除
            [self deleteNoteBook:currentNoteBook forRowAtIndexPath:indexPath];
        } privateBtnTitle:privateBtnTitle privateHandler:^{
            //修改权限
            [self setPrivateStatus:currentNoteBook forRowAtIndexPath:indexPath];
        } renameHandler:^{
            //重命名
            [self renameNoteBook:currentNoteBook forRowAtIndexPath:indexPath];
        }];
    }
}

-(void)setCellChosen:(BOOL)isChosen forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = isChosen ? [UIColor whiteColor] : [UIColor clearColor];
}

-(void)deleteNoteBook:(SZYNoteBookModel *)noteBook forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIAlertController showAlertAtViewController:self withMessage:@"您确定删除吗？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action) {
        //do nothing..
    } confirmHandler:^(UIAlertAction *action) {
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
            [self.noteBookSolidater deleteOneByID:noteBook.noteBook_id successHandler:^(id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //数据源中删除(这一步容易遗忘)
                    [self.noteBookArr removeObject:noteBook];
                    //局部刷新
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                });
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];
    }];
}

-(void)setPrivateStatus:(SZYNoteBookModel *)noteBook forRowAtIndexPath:(NSIndexPath *)indexPath
{
    noteBook.isPrivate = [noteBook.isPrivate isEqualToString:@"YES"] ? @"NO" : @"YES";
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        [self.noteBookSolidater updateOne:noteBook successHandler:^(id result) {
            //在主线程刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadData];
                [self setCellChosen:NO forRowAtIndexPath:indexPath];
            });
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
}

-(void)renameNoteBook:(SZYNoteBookModel *)noteBook forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIAlertController showAlertWithTextFieldAtViewController:self title:@"重命名" message:@"请输入笔记本的名称" cancelTitle:@"取消" confirmTitle:@"修改" confirmHandler:^(NSString *inputStr) {
        //处理用户没有输入的情况
        noteBook.title = [inputStr isEqualToString:@""] ? @"未命名笔记本" : inputStr;
        //更新数据库
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
            [self.noteBookSolidater updateOne:noteBook successHandler:^(id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadData];
                    [self setCellChosen:NO forRowAtIndexPath:indexPath];
                });
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];
    }];
}

-(void)addNewNoteBook:(UIButton *)sender
{
    [UIAlertController showAlertWithTextFieldAtViewController:self title:@"新建笔记本" message:@"请输入笔记本的名称" cancelTitle:@"取消" confirmTitle:@"创建" confirmHandler:^(NSString *inputStr) {
        
        NSString *title = [inputStr isEqualToString:@""] ? @"未命名笔记本" : inputStr;
        
        SZYNoteBookModel *newNoteBook = [[SZYNoteBookModel alloc]initWithID:[NSString stringOfUUID] Title:title UserID:ApplicationDelegate.userSession.user_id IsPrivate:@"NO"];
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
            //插入一行笔记本数据
            [_noteBookSolidater saveOne:newNoteBook successHandler:^(id result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新界面
                    [self loadData];
                });
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"error = %@",errorMsg);
            }];
        }];
    }];
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

#pragma mark - getters

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
        [_rightBtn setTitle:@"新建" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(addNewNoteBook:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UILongPressGestureRecognizer *)longPressGuesture{
    if (!_longPressGuesture){
        _longPressGuesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        _longPressGuesture.minimumPressDuration = 0.5f;
    }
    return _longPressGuesture;
}

@end
