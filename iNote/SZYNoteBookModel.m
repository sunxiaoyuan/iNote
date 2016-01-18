//
//  SZYNoteBookModel.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookModel.h"

@implementation SZYNoteBookModel

//重写父类初始化方法
+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    [SZYNoteBookModel setupObjectClassInArray:^NSDictionary *{
        return @{@"noteList":@"SZYNoteModel"};
    }];
    SZYNoteBookModel *noteBookModel = [SZYNoteBookModel objectWithKeyValues:dict];
    return noteBookModel;
}

//子类扩展的初始化方法
- (instancetype)initWithID:(NSString *)noteBook_id Title:(NSString *)title UserID:(NSString *)user_id_belonged IsPrivate:(NSString *)isPrivate
{
    self = [super init];
    if (self) {
        (noteBook_id) ? (_noteBook_id = noteBook_id) : (_noteBook_id = [NSString stringOfUUID]);
        _title = title;
        _user_id_belonged = user_id_belonged;
        _isPrivate = isPrivate;
    }
    return self;
}

@end
