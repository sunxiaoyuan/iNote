//
//  SZYLocalFileManager.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    kUserFolderType,
    kNoteImageFolderType ,
    kNoteContentFolderType,
    kNoteVideoFolderType,
    kUserImageFolderType,
    kUserIntervalFolderType,
    
} SZYSecondFolderType;

@interface SZYLocalFileManager : NSObject

+(SZYLocalFileManager *)sharedInstance;

//创建各级目录
-(NSString *)setUpLocalFileDir:(SZYSecondFolderType)type;
//保存笔记的图片到本地
-(NSString *)saveNoteImage:(UIImage *)image NoteID:(NSString *)noteID IsFake:(BOOL)isFake;
//保存笔记正文到本地
-(NSString *)saveNoteContent:(NSString *)content NoteID:(NSString *)noteID isFake:(BOOL)isFake;
//读取笔记的内容
-(NSString *)contentFileAtPath:(NSString *)path;
//读取笔记的图片
-(UIImage *)imageFileAtPath:(NSString *)path;
//返回录音本地可用地址
-(NSString *)noteVideoPathWithNoteID:(NSString *)noteID;

//保存用户头像
-(NSString *)saveUserAvater:(UIImage *)image UserID:(NSString *)userID isFake:(BOOL)isFake;
//保存用户图片
-(NSString *)saveUserImage:(UIImage *)image UserID:(NSString *)userID isFake:(BOOL)isFake;

-(float)fileSizeAtTempFolder;
-(void)cleanTempFolder;

@end
