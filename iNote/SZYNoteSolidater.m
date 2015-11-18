//
//  SZYNoteSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteSolidater.h"
#import "SZYNoteModel.h"
#import "FMDatabase.h"
#import "SZYDataBaseDef.h"

@implementation SZYNoteSolidater

#pragma mark - 笔记数据的操作

-(id)loadCommand:(EBDCommand)command WithParam:(id)param{
    
    switch (command) {
        case EBDCommand_Save:
        {
            return [self saveOneNoteToDB:param];
        }
            break;
        case EBDCommand_QueryAll:
        {
            return [self getAllNotesFromDB];
        }
            break;
        case EBDCommand_QueryByCondition:
        {
            return [self getNotesByNoteBookId:param];
        }
            break;
        case EBDCommand_QueyrOne:
        {
            return [self getOneNoteFromDB:param];
        }
            break;
        case EBDCommand_QueryFavorite:
        {
            return [self getNotesByFavorite];
        }
            break;
        case EBDCommand_Update:
        {
            [self updateOneNoteWithID:param[@"id"] WithData:param[@"data"]];
            return nil;
        }
            break;
        case EBDCommand_DeleteAll:
        {
            [self deleteAllNotes];
            return nil;
        }
            break;
        case EBDCommand_DeleteOne:
        {
            [self deleteOneNoteWithID:param];
            return nil;
        }
            break;
    }
}

-(NSString *)saveOneNoteToDB:(SZYNoteModel *)note{
    if (self.dataBase == nil) {
        return @"NO";
    }
    BOOL insert = [self.dataBase executeUpdate:INSERT_ONE_NOTE,note.note_id,note.noteBook_id_belonged,note.user_id_belonged,note.title,note.mendTime,note.content,note.image,note.video,note.isFavorite];
    return insert?@"YES":@"NO";
}

-(NSMutableArray *)getAllNotesFromDB{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_ALL_NOTES];
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
        [tempArray addObject:tempNote];
    }
    return tempArray;
}

-(NSMutableArray *)getNotesByNoteBookId:(NSString *)noteBook_id{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_NOTES_BY_NOTEBOOKID,noteBook_id];
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
    return tempArr;
}

-(NSMutableArray *)getNotesByFavorite{
    NSMutableArray *tempArr = [NSMutableArray array];
    FMResultSet *rs = [self.dataBase executeQuery:Select_Notes_By_Favorite,@"YES"];
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
    return tempArr;
}

-(SZYNoteModel *)getOneNoteFromDB:(NSString *)note_id{
    FMResultSet *rs = [self.dataBase executeQuery:SELECT_ONE_NOTE,note_id];
    while ([rs next]){
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
        return tempNote;
    }
    return nil;
}

-(BOOL)updateOneNoteWithID:(NSString *)note_id WithData:(SZYNoteModel *)note{
    if (self.dataBase == nil) {
        NSLog(@"kongde");
    }
    BOOL result = [self.dataBase executeUpdate:UPDATE_NOTE,note.note_id,note.noteBook_id_belonged,note.user_id_belonged,note.title,note.mendTime,note.content,note.image,note.video,note.isFavorite,note_id];
    return result;

}

-(BOOL)deleteAllNotes{
    return [self.dataBase executeUpdate:DELETE_ALL_NOTES];
}

-(BOOL)deleteOneNoteWithID:(NSString *)note_id{
    BOOL success = [self.dataBase executeUpdate:DELETE_ONE_NOTE,note_id];
    return success;
}

@end
