//
//  SZYNoteBookSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookSolidater.h"
#import "SZYNoteBookModel.h"
#import "FMDatabase.h"
#import "SZYNoteSolidater.h"
#import "SZYDataBaseDef.h"

@implementation SZYNoteBookSolidater

#pragma mark - 笔记本数据的操作

-(id)loadCommand:(EBDCommand)command WithParam:(id)param{
    
    switch (command) {
        case EBDCommand_Save:
        {
            return [self saveOneNoteBookToDB:param];
        }
            break;
        case EBDCommand_QueryAll:
        {
            return [self getAllNoteBooksFromDB];
        }
            break;
        case EBDCommand_QueryByCondition:
        {
            return [self getNoteBooksByUserId:param];
        }
            break;
        case EBDCommand_QueyrOne:
        {
            return [self getOneNoteBookFromDB:param];
        }
            break;
        case EBDCommand_QueryFavorite:
        {
            return nil;
        }
            break;
        case EBDCommand_Update:
        {
            [self updateOneNoteBookWithID:param[@"id"] WithData:param[@"data"]];
            return nil;
        }
            break;
        case EBDCommand_DeleteAll:
        {
            [self deleteAllNoteBooks];
            return nil;
        }
            break;
        case EBDCommand_DeleteOne:
        {
            [self deleteOneNoteBookWithID:param];
            return nil;
        }
            break;

    }
 
}


-(NSString *)saveOneNoteBookToDB:(SZYNoteBookModel *)noteBook{
    if (self.dataBase == nil) {
        return @"NO";
    }
    BOOL insert = [self.dataBase executeUpdate:INSERT_ONE_NOTE_BOOK,noteBook.noteBook_id,noteBook.user_id_belonged,noteBook.title,noteBook.noteNumber,noteBook.isPrivate];
    return insert?@"YES":@"NO";
}

-(NSMutableArray *)getAllNoteBooksFromDB{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_ALL_NOTE_BOOKS];
    SZYNoteSolidater *noteSolidater = [[SZYNoteSolidater alloc]init];
    while ([rs next]) {
        SZYNoteBookModel *tempNoteBook = [[SZYNoteBookModel alloc]init];
        tempNoteBook.noteBook_id = [rs stringForColumn:@"noteBook_id"];
        tempNoteBook.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
        tempNoteBook.title = [rs stringForColumn:@"title"];
        tempNoteBook.isPrivate = [rs stringForColumn:@"isPrivate"];
        tempNoteBook.noteList = [noteSolidater loadCommand:EBDCommand_QueryByCondition WithParam:[rs stringForColumn:@"noteBook_id"]];
        tempNoteBook.noteNumber = [NSString stringWithFormat:@"%lu",(unsigned long)[tempNoteBook.noteList count]];
        [tempArray addObject:tempNoteBook];
    }
    return tempArray;
}

-(NSMutableArray *)getNoteBooksByUserId:(NSString *)userId{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_NOTE_BOOK_BY_USERID,userId];
    SZYNoteSolidater *noteSolidater = [[SZYNoteSolidater alloc]init];
    while ([rs next]) {
        SZYNoteBookModel *tempNoteBook = [[SZYNoteBookModel alloc]init];
        tempNoteBook.noteBook_id = [rs stringForColumn:@"noteBook_id"];
        tempNoteBook.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
        tempNoteBook.title = [rs stringForColumn:@"title"];
        tempNoteBook.isPrivate = [rs stringForColumn:@"isPrivate"];
        tempNoteBook.noteList = [noteSolidater loadCommand:EBDCommand_QueryByCondition WithParam:[rs stringForColumn:@"noteBook_id"]];
        tempNoteBook.noteNumber = [NSString stringWithFormat:@"%lu",(unsigned long)[tempNoteBook.noteList count]];
        [tempArr addObject:tempNoteBook];
    }
    return tempArr;
}

-(SZYNoteBookModel *)getOneNoteBookFromDB:(NSString *)noteBook_id{
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_ONE_NOTE_BOOK,noteBook_id];
    SZYNoteSolidater *noteSolidater = [[SZYNoteSolidater alloc]init];
    while ([rs next]){
        SZYNoteBookModel *tempNoteBook = [[SZYNoteBookModel alloc]init];
        tempNoteBook.noteBook_id = [rs stringForColumn:@"noteBook_id"];
        tempNoteBook.user_id_belonged = [rs stringForColumn:@"user_id_belonged"];
        tempNoteBook.title = [rs stringForColumn:@"title"];
        tempNoteBook.noteNumber = [rs stringForColumn:@"noteNumber"];
        tempNoteBook.isPrivate = [rs stringForColumn:@"isPrivate"];
        tempNoteBook.noteList = [noteSolidater loadCommand:EBDCommand_QueryByCondition WithParam:[rs stringForColumn:@"noteBook_id"]];
        return tempNoteBook;
    }
    return nil;
}

-(void)updateOneNoteBookWithID:(NSString *)noteBook_id WithData:(SZYNoteBookModel *)noteBook{
    if (self.dataBase == nil) {
        NSLog(@"kongde");
    }
    [self.dataBase executeUpdate:UPDATE_NOTE_BOOK,noteBook.noteBook_id,noteBook.user_id_belonged,noteBook.title,noteBook.noteNumber,noteBook.isPrivate];
}

-(void)deleteAllNoteBooks{
    [self.dataBase executeUpdate:DELETE_ALL_NOTE_BOOKS];
}

-(void)deleteOneNoteBookWithID:(NSString *)noteBook_id{
    [self.dataBase executeUpdate:DELETE_ONE_NOTE_BOOK,noteBook_id];
    
}

@end
