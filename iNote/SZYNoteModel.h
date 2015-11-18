//
//  SZYNoteModel.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  这个是使用MJExtension构造的模型

#import "SZYBaseModel.h"

@interface SZYNoteModel : SZYBaseModel

//id
@property (nonatomic, copy  ) NSString *note_id;
//所属笔记本id
@property (nonatomic, copy  ) NSString *noteBook_id_belonged;
//所属用户
@property (nonatomic, copy  ) NSString *user_id_belonged;
//标题
@property (nonatomic, copy  ) NSString *title;
//最近的修改时间（包括创建）
@property (nonatomic, copy  ) NSString *mendTime;
//文本正文
@property (nonatomic, copy  ) NSString *content;
//图片
@property (nonatomic, copy  ) NSString *image;
//录音文件
@property (nonatomic, copy  ) NSString *video;
//是否被收藏
@property (nonatomic, copy  ) NSString *isFavorite;

//子类的扩展方法
-(void)saveImage:(UIImage *)image IsFake:(BOOL)isFake;
-(void)saveContent:(NSString *)content IsFake:(BOOL)isFake;
-(NSString *)contentAtLocal;
-(UIImage *)imageAtlocal;
-(NSString *)videoPath;

@end
