//
//  SZYNoteSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.

#import "SZYNoteSolidater.h"
#import "SZYNoteModel.h"
#import "FMResultSet.h"


@interface SZYNoteSolidater ()
@property (nonatomic, strong) SZYDataBaseService *dbService;
@end

@implementation SZYNoteSolidater{
    NSString *tableName;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbService = [SZYDataBaseService getInstance];
        tableName = NSStringFromClass([SZYNoteModel class]);
    }
    return self;
}

#pragma mark - 数据库方法

//往数据库中写数据的时候，数据都必须时NSObject的子类。基本数据类型需要装箱

-(void)saveOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SZYNoteModel *note = (SZYNoteModel *)model;
    //构造sql查询语句
    NSString *sql = @"INSERT INTO SZYNoteModel(note_id,noteBook_id_belonged,user_id_belonged,title,mendTime,content,image,video,isFavorite) VALUES(?,?,?,?,?,?,?,?,?)";
    //将nil的属性转换成空字符串
    [note transferNilPropertiesToNullString];
    NSArray *valueArr = @[note.note_id,note.noteBook_id_belonged,note.user_id_belonged,note.title,note.mendTime,note.content,note.image,note.video,note.isFavorite];
    [_dbService executeSaveSql:sql insertValues:valueArr successHandler:success failureHandler:failure];
}

-(void)updateOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SZYNoteModel *note = (SZYNoteModel *)model;
    [note transferNilPropertiesToNullString];
    NSArray *valueArr = @[note.note_id,note.noteBook_id_belonged,note.user_id_belonged,note.title,note.mendTime,note.content,note.image,note.video,note.isFavorite,note.note_id];
    NSString * sql = @"UPDATE SZYNoteModel SET note_id = ?, noteBook_id_belonged = ?,user_id_belonged = ?,title = ?,mendTime = ?,content = ?,image = ?,video = ?,isFavorite = ? WHERE note_id = ?";
    [_dbService executeUpdateSql:sql updateValues:valueArr successHandler:success failureHandler:failure];
}

-(void)readByCriteria:(NSString *)criteria queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
    [_dbService executeReadSql:sql queryValue:queryValue successHandler:^(id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tempArr = [NSMutableArray array];
        while ([rs next]) {
            SZYNoteModel *tempNote = [[SZYNoteModel alloc]init];
            tempNote.note_id = [rs stringForColumn:@"note_id"];
            tempNote.noteBook_id_belonged = [rs stringForColumn:@"noteBook_id_belonged"];
            tempNote.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
            tempNote.title = [rs stringForColumn:@"title"];
            tempNote.mendTime = [rs stringForColumn:@"mendTime"];
            tempNote.content = [rs stringForColumn:@"content"];
            tempNote.image = [rs stringForColumn:@"image"];
            tempNote.video = [rs stringForColumn:@"video"];
            tempNote.isFavorite = [rs stringForColumn:@"isFavorite"];
            [tempArr addObject:tempNote];
        }
        //结果回调
        success(tempArr);
    } failureHandler:failure];
}

-(void)readOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE note_id = ?";
    [self readByCriteria:criteria queryValue:ID successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
        if ([noteArr count] < 1) {
            success(nil);
        }else{
            success([noteArr firstObject]);
        }
    } failureHandler:failure];
}

-(void)readOneByPID:(NSString *)PID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE noteBook_id_belonged = ?";
    [self readByCriteria:criteria queryValue:PID successHandler:success failureHandler:failure];
}

-(void)readAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    [self readByCriteria:@"" queryValue:nil successHandler:success failureHandler:failure];
}

-(void)deleteByCriteria:(NSString *)criteria deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@",tableName,criteria];
    [_dbService executeDeleteSql:sql deleteValue:deleteValue successHandler:success failureHandler:failure];
}

-(void)deleteOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE note_id = ?";
    [self deleteByCriteria:criteria deleteValue:ID successHandler:success failureHandler:failure];
}

-(void)deleteOneByPID:(NSString *)PID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE noteBook_id_belonged = ?";
    [self deleteByCriteria:criteria deleteValue:PID successHandler:success failureHandler:failure];
}

-(void)deleteAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    [self deleteByCriteria:@"" deleteValue:nil successHandler:success failureHandler:failure];
}

@end
