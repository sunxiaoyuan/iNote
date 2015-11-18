//
//  SZYNoteBookModel.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookModel.h"
#import "MJExtension.h"


@implementation SZYNoteBookModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    [SZYNoteBookModel setupObjectClassInArray:^NSDictionary *{
        return @{@"noteList":@"SZYNoteModel"};
    }];
    SZYNoteBookModel *noteBookModel = [SZYNoteBookModel objectWithKeyValues:dict];
    return noteBookModel;
}

+(id)modalWithID{
    
    SZYNoteBookModel *noteBook = [[SZYNoteBookModel alloc]init];
    noteBook.noteBook_id = [NSString RandomString];
    return noteBook;
}

@end
