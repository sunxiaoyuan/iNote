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

@interface SZYFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource,SZYNoteDisplayCellDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, copy  ) NSMutableArray *noteListArr;
@property (nonatomic, strong) NSMutableDictionary *cellStateDict;
@property (nonatomic, strong) SZYNoteSolidater    *noteSolidater;

@end

@implementation SZYFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    self.noteSolidater = (SZYNoteSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteModel class])];
    self.noteListArr = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //加载数据源
    [self loadData];
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
}

#pragma mark - TableViewDelegate和TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noteListArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:self.noteListArr[indexPath.row] Type:[cellState integerValue]];
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
    SZYNoteModel *note = self.noteListArr[indexPath.row];
    SZYNoteFrameInfo *info;
    NSNumber *cellState = self.cellStateDict[@(indexPath.row)];
    info = [[SZYNoteFrameInfo alloc]initWithNote:note Type:[cellState integerValue]];
    [cell setNote:note FrameInfo:info Type:[cellState integerValue] IndexPath:indexPath];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转详情页
    SZYDetailViewController *detailVC = [[SZYDetailViewController alloc]initWithNote:self.noteListArr[indexPath.row] AndSourceType:SZYFromListType];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - SZYNoteDisplayCellDelegate

-(void)allInfoBtnDidClick:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.cellStateDict setObject:@(SZYCellStateType_All) forKey:@(indexPath.row)];
    }else{
        [self.cellStateDict setObject:@(SZYCellStateType_Part) forKey:@(indexPath.row)];
    }
    [self.tableView reloadData];
}

#pragma mark - 私有方法

-(void)loadData{
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        //查询数据库
        NSString *criteria = @"WHERE user_id_belonged = ?";
        [_noteSolidater readByCriteria:criteria queryValue:ApplicationDelegate.userSession.user_id successHandler:^(id result) {
            NSMutableArray *arr = [NSMutableArray array];
            for (SZYNoteModel *note in (NSMutableArray *)result) {
                if ([note.isFavorite isEqualToString:@"YES"]) {
                    [arr addObject:note];
                }
            }
            self.noteListArr = arr;
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
