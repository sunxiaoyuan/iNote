//
//  SZYNoteBookModel.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYBaseModel.h"

@interface SZYNoteBookModel : SZYBaseModel

//id
@property (nonatomic, copy  ) NSString *noteBook_id;
//所属用户id
@property (nonatomic, copy  ) NSString *user_id_belonged;
//标题
@property (nonatomic, copy  ) NSString *title;
//笔记数量
@property (nonatomic, copy  ) NSString *noteNumber;
//是否隐藏
@property (nonatomic, copy  ) NSString *isPrivate;
//拥有的笔记列表
@property (nonatomic, copy  ) NSMutableArray  *noteList;


@end
