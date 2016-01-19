//
//  SZYFavoriteViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYFavoriteViewController.h"
#import "SZYNoteModel.h"
#import "SZYSolidaterFactory.h"
#import "SZYNoteFrameInfo.h"
#import "SZYNoteDisplayCell.h"
#import "SZYDetailViewController.h"

@interface SZYFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSMutableArray    *noteListArr;//收藏笔记的列表

@end

@implementation SZYFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载数据源
    [self loadData];
    
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    
}

#pragma mark - TableViewDelegate和TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noteListArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SZYNoteFrameInfo *info = [[SZYNoteFrameInfo alloc]initWithNote:self.noteListArr[indexPath.row]];
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *cellID = @"NoteDisplayCell";
//    SZYBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [SZYNoteDisplayCell loadFromXib];
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    SZYNoteModel *note = self.noteListArr[indexPath.row];
//    SZYNoteFrameInfo *info = [[SZYNoteFrameInfo alloc]initWithNote:note];
//    [cell setNote:note FrameInfo:info IndexPath:indexPath];
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转详情页
    SZYDetailViewController *detailVC = [[SZYDetailViewController alloc]initWithNote:self.noteListArr[indexPath.row] AndSourceType:SZYFromListType];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 私有方法

-(void)loadData{
    
    //加载数据
    if (!self.noteListArr) {
        self.noteListArr = [NSMutableArray array];
    }
    
    SZYNoteSolidater *solidater = (SZYNoteSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteModel class])];
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        //查询数据库
        NSString *criteria = @"WHERE isFavorite = ?";
        [solidater readByCriteria:criteria queryValue:@"YES" successHandler:^(id result) {
            self.noteListArr = (NSMutableArray *)result;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
    [self.tableView reloadData];
    
}

#pragma mark - getters

-(UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

@end
