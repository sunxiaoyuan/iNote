//
//  SZYNoteBookSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookSolidater.h"
#import "SZYNoteBookModel.h"
#import "SZYNoteSolidater.h"


@interface SZYNoteBookSolidater ()
@property (nonatomic, strong) SZYDataBaseService *dbService;
@property (nonatomic, strong) SZYNoteSolidater *noteSolidater;
@end

@implementation SZYNoteBookSolidater{
    NSString *tableName;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbService = [SZYDataBaseService getInstance];
        _noteSolidater = [[SZYNoteSolidater alloc]init];
        tableName = NSStringFromClass([SZYNoteBookModel class]);
    }
    return self;
}


-(void)saveOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SZYNoteBookModel *noteBook = (SZYNoteBookModel *)model;
    [noteBook transferNilPropertiesToNullString];
    NSArray *valueArr = @[noteBook.noteBook_id,noteBook.user_id_belonged,noteBook.title,noteBook.isPrivate];
    NSString *sql = @"INSERT INTO SZYNoteBookModel(noteBook_id,user_id_belonged,title,isPrivate) VALUES(?,?,?,?)";
    [_dbService executeSaveSql:sql insertValues:valueArr successHandler:success failureHandler:failure];
}

-(void)updateOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SZYNoteBookModel *noteBook = (SZYNoteBookModel *)model;
    [noteBook transferNilPropertiesToNullString];
    NSArray *valueArr = @[noteBook.noteBook_id,noteBook.user_id_belonged,noteBook.title,noteBook.isPrivate,noteBook.noteBook_id];
    NSString * sql = @"UPDATE SZYNoteBookModel SET noteBook_id = ?,user_id_belonged = ?,title = ?,isPrivate = ? WHERE noteBook_id = ?";
    [_dbService executeUpdateSql:sql updateValues:valueArr successHandler:success failureHandler:failure];
}

-(void)readByCriteria:(NSString *)criteria queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
    [_dbService executeReadSql:sql queryValue:queryValue successHandler:^(id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tempArr = [NSMutableArray array];
        __block BOOL isError = NO;
        while ([rs next]) {
            SZYNoteBookModel *tempNoteBook = [[SZYNoteBookModel alloc]init];
            tempNoteBook.noteBook_id = [rs stringForColumn:@"noteBook_id"];
            tempNoteBook.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
            tempNoteBook.title = [rs stringForColumn:@"title"];
            tempNoteBook.isPrivate = [rs stringForColumn:@"isPrivate"];
            
            [_noteSolidater readOneByPID:tempNoteBook.noteBook_id successHandler:^(id result) {
                tempNoteBook.noteList = (NSMutableArray *)result;
            } failureHandler:^(NSString *errorMsg) {
                failure(errorMsg);
                isError = YES;
            }];
            if (isError) {
                break;
            }else{
                [tempArr addObject:tempNoteBook];
            }
        }
        if (!isError) success(tempArr);
    } failureHandler:failure];
}

-(void)readOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE noteBook_id = ?";
    [self readByCriteria:criteria queryValue:ID successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
        if ([noteArr count] < 1) {
            success(nil);
        }else{
            success([noteArr firstObject]);
        }
    } failureHandler:failure];
}

-(void)readAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    [self readByCriteria:@"" queryValue:nil successHandler:success failureHandler:failure];
}

-(void)readAllWithoutNoteListSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    [_dbService executeReadSql:sql queryValue:nil successHandler:^(id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tempArr = [NSMutableArray array];
        while ([rs next]) {
            SZYNoteBookModel *tempNoteBook = [[SZYNoteBookModel alloc]init];
            tempNoteBook.noteBook_id = [rs stringForColumn:@"noteBook_id"];
            tempNoteBook.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
            tempNoteBook.title = [rs stringForColumn:@"title"];
            tempNoteBook.isPrivate = [rs stringForColumn:@"isPrivate"];
            [tempArr addObject:tempNoteBook];
        }
        success(tempArr);
    } failureHandler:failure];
    
}

-(void)deleteByCriteria:(NSString *)criteria deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    [self readByCriteria:criteria queryValue:deleteValue successHandler:^(id result) {
        __block BOOL isError = NO;
        for (SZYNoteBookModel *tempNoteBook in (NSArray *)result) {
            NSString *noteBook_id = tempNoteBook.noteBook_id;
            [_noteSolidater deleteOneByPID:noteBook_id successHandler:^(id result) {
                
            } failureHandler:^(NSString *errorMsg){
                failure(errorMsg);
                isError = YES;
            }];
            if (isError) break;
        }
        if (!isError) {
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@",tableName,criteria];
            [_dbService executeDeleteSql:sql deleteValue:deleteValue successHandler:success failureHandler:failure];
        }
    } failureHandler:failure];
}

-(void)deleteOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    NSString *criteria = @"WHERE noteBook_id = ?";
    [self deleteByCriteria:criteria deleteValue:ID successHandler:^(id result) {
        //在删除笔记本成功的回调，执行删除所有子级笔记
        [_noteSolidater deleteOneByPID:ID successHandler:success failureHandler:failure];
    } failureHandler:failure];
}

//-(void)deleteAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
//    
//    NSString *sql = @"DELETE FROM SZYNoteBookModel";
//    [_dbService executeDeleteSql:sql deleteValue:nil successHandler:^(id result) {
//        [_noteSolidater deleteAllSuccessHandler:success failureHandler:failure];
//    } failureHandler:failure];
//    
////    [self deleteByCriteria:@"" deleteValue:nil successHandler:^(id result) {
////        [_noteSolidater deleteAllSuccessHandler:success failureHandler:failure];
//////        success(result);;
////    } failureHandler:^(NSString *errorMsg) {
////        failure(errorMsg);
////    }];
//}


@end
