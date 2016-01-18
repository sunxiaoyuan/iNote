//
//  SZYNoteBookModel.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYBaseModel.h"

@interface SZYNoteBookModel : SZYBaseModel

//id
@property (nonatomic, strong) NSString *noteBook_id;
//所属用户id
@property (nonatomic, strong) NSString *user_id_belonged;
//标题
@property (nonatomic, strong) NSString *title;
//是否隐藏
@property (nonatomic, strong) NSString *isPrivate;
//拥有的笔记列表
@property (nonatomic, strong) NSMutableArray  *noteList;

//自定义初始化方法
- (instancetype)initWithID:(NSString *)noteBook_id Title:(NSString *)title UserID:(NSString *)user_id_belonged IsPrivate:(NSString *)isPrivate;

@end
