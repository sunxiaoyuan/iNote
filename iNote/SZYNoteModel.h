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
@property (nonatomic, strong  ) NSString *note_id;
//所属笔记本id
@property (nonatomic, strong  ) NSString *noteBook_id_belonged;
//所属用户
@property (nonatomic, strong  ) NSString *user_id_belonged;
//标题
@property (nonatomic, strong  ) NSString *title;
//最近的修改时间（包括创建）
@property (nonatomic, strong  ) NSString *mendTime;
//文本正文
@property (nonatomic, strong  ) NSString *content;
//图片
@property (nonatomic, strong  ) NSString *image;
//录音文件
@property (nonatomic, strong  ) NSString *video;
//是否被收藏
@property (nonatomic, strong  ) NSString *isFavorite;

//自定义初始化方法
- (instancetype)initWithNoteBookID:(NSString *)noteBook_id_belonged UserID:(NSString *)user_id_belonged Title:(NSString *)title;
//子类的扩展方法
/*写入本地时，我们需要设置一种虚假业务手段，只有用户“确认”存储我们才会将
 文件写入本地，否则只是在对象内部存储一个本地索引*/
-(void)saveImage:(UIImage *)image;
-(void)saveContent:(NSString *)content;
-(NSString *)contentAtLocal;
-(UIImage *)imageAtlocal;
-(NSString *)videoPath;
-(void)deleteContentAtLocal:(completedHandler)handler;
-(void)deleteImageAtLocal:(completedHandler)handler;
-(void)deleteVideoAtLocalWithDirClear:(BOOL)isDirClear;
-(BOOL)haveVideo;

@end
