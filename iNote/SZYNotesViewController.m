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
#import "SZYOpenListCellCell.h"
#import "SZYNoteBookLocalmanager.h"
#import "NSString+Random.h"

@interface SZYNotesViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) NSMutableArray   *noteBookArr;
@property (nonatomic, strong) NSIndexPath      *selectIndexPath;
@property (nonatomic, strong) SZYNoteBookModel *selectNoteBook;
@property (nonatomic, strong) UIButton         *addNoteBookBtn;

@end

@implementation SZYNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self loadData];
    
}



#pragma mark - TableViewDelegate和TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noteBookArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SZYOpenListCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"OpenListCell";
    SZYOpenListCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SZYOpenListCellCell class]) owner:nil options:nil] lastObject];
    }
    SZYNoteBookModel *noteBook = _noteBookArr[indexPath.row];
    cell.nameLabel.text = noteBook.title;
    cell.numberLabel.text = noteBook.noteNumber;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //调转到笔记列表页
    
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
    
    SZYNoteBookLocalmanager *manager = (SZYNoteBookLocalmanager *)[SZYLocalManagerFactory managerFactoryWithType:kNoteBookType];
    manager.solidater = [SZYSolidaterFactory solidaterFctoryWithType:kNoteBookType];
    
    if (alertView.tag == 101) { //提醒用户数据改变的alert
        if (buttonIndex == 1) {
            //数据库中删除
            [manager deleteModelById:self.selectNoteBook.noteBook_id];
            //数据源中删除(这一步容易遗忘)
            [self.noteBookArr removeObject:self.selectNoteBook];
            
            //局部刷新
            [self.tableView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }else{ //新建笔记本的alert
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            SZYNoteBookModel *newNoteBook = [[SZYNoteBookModel alloc]init];
            newNoteBook.noteBook_id = [NSString RandomString];
            newNoteBook.user_id_belonged = ApplicationDelegate.userSession.user_id;
            newNoteBook.title = tf.text;
            newNoteBook.isPrivate = @"NO";
            [manager save:newNoteBook];
            
            [self loadData];
            [self.tableView reloadData];

        }
    }
}

#pragma mark - 私有方法

-(void)setUpUI{
    
    //不需要系统自动处理顶部内容伸缩
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置标题
    self.title = @"笔记本";
    //设置底色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //添加笔记本按钮
    self.addNoteBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addNoteBookBtn.frame = CGRectMake((UIScreenWidth-100)/2, 7, 100, 30);
    [self.addNoteBookBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
    [self.addNoteBookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addNoteBookBtn addTarget:self action:@selector(addNoteBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.addNoteBookBtn.hidden = YES;
    [self.view addSubview:self.addNoteBookBtn];
    
    //分割线
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, UIScreenWidth, 1)];
    sepLine.backgroundColor = UIColorFromRGB(0xdddddd);
    [self.view addSubview:sepLine];
    
    //表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self clearExtraLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    //导航栏右侧按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, SIZ(40), SIZ(40));
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

}

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

//去掉下方多余的线
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


-(void)loadData{
    //查询到当前用户id下的所有笔记本信息
    if (!self.noteBookArr) {
        self.noteBookArr = [NSMutableArray array];
    }
    SZYNoteBookLocalmanager *noteBookLM = (SZYNoteBookLocalmanager *)[SZYLocalManagerFactory managerFactoryWithType:kNoteBookType];
    noteBookLM.solidater = [SZYSolidaterFactory solidaterFctoryWithType:kNoteBookType];
    self.noteBookArr = [noteBookLM noteBooksByUserId:ApplicationDelegate.userSession.user_id];
}

-(void)addNoteBookBtnClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"新建笔记本" message:@"请输入笔记本的标题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 102;
    [alert show];
}



@end
