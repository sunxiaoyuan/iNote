//
//  SZYNoteBookViewController.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/25.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookViewController.h"
#import "UIView+SZY.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"
#import "SZYNoteFrameInfo.h"
#import "SZYNoteDisplayCell.h"
#import "MJRefresh.h"
#import "SZYRefreshHeader.h"
#import "SZYSolidaterFactory.h"
#import "SZYDetailViewController.h"

@interface SZYNoteBookViewController ()<UITableViewDelegate,UITableViewDataSource,SZYNoteDisplayCellDelegate>

@property (nonatomic, strong) UITableView         *tableView;//数据表格
@property (nonatomic, strong) NSMutableArray      *noteArr;//笔记本的列表
@property (nonatomic, strong) NSMutableDictionary *cellStateDict;
@property (nonatomic, strong) SZYNoteSolidater    *noteSolidater;
@property (nonatomic, strong) UIButton             *rightBtn;

@end

@implementation SZYNoteBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //自定义右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.noteSolidater = (SZYNoteSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteModel class])];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self loadData];
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}

#pragma mark - 加载数据方法

-(void)loadData{
    
    if (!self.noteArr) {
        self.noteArr = [NSMutableArray array];
    }
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        [_noteSolidater readOneByPID:self.currentNoteBook.noteBook_id successHandler:^(id result) {
            self.noteArr = (NSMutableArray *)result;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate和TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noteArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:self.noteArr[indexPath.row] Type:[cellState integerValue]];
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
    SZYNoteModel *note = self.noteArr[indexPath.row];
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:note Type:[cellState integerValue]];
    [cell setNote:note FrameInfo:info Type:[cellState integerValue] IndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYDetailViewController * detailVC = [[SZYDetailViewController alloc]initWithNote:self.noteArr[indexPath.row] AndSourceType:SZYFromListType];
    [self.navigationController pushViewController:detailVC animated:YES];
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

#pragma mark - 响应方法

-(void)addNewNote:(UIButton *)sender{
    
    SZYDetailViewController *newNoteVC = [[SZYDetailViewController alloc]initWithNote:nil AndSourceType:SZYFromAddType];
    [self.navigationController pushViewController:newNoteVC animated:YES];
}

#pragma mark - getters

-(UITableView *)tableView{
    //表格
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

-(UIButton *)rightBtn{
    if (!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor clearColor];
        _rightBtn.frame = CGRectMake(0, 0, SIZ(40), SIZ(40));
        [_rightBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(addNewNote:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
