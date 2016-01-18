//
//  SZYLocalFileManager.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^completedHandler) (NSError *error);
typedef void (^successHandler)   (NSString *filePath);
typedef void (^failureHandler)   (NSError  *error);


typedef NS_ENUM (NSInteger, SZYSecondFolderType) {
    kUserFolderType,
    kNoteImageFolderType, //创建笔记信息文件夹
    kNoteContentFolderType,
    kNoteVideoFolderType,
    kUserImageFolderType, //创建用户信息文件夹
    kUserIntervalFolderType,
};

@interface SZYLocalFileManager : NSObject

//初始化
+(SZYLocalFileManager *)sharedInstance;

//创建各级目录
-(NSString *)setUpLocalFileDir:(SZYSecondFolderType)type;

//保存文件到本地
-(void)saveFile:(id)file fileName:(NSString *)fileName withType:(SZYSecondFolderType)type successHandler:(successHandler)success failureHandler:(failureHandler)failure;

//获取缓存文件夹大小
-(float)fileSizeAtTempFolder;

//清理缓存文件夹
-(void)cleanTempFolderHandler:(completedHandler)block;

//读取文本文件
-(NSString *)contentFileAtPath:(NSString *)path;

//读取图片文件
-(UIImage *)imageFileAtPath:(NSString *)path;

//删除本地文件
-(void)deleteFileWithPath:(NSString *)filePath completionHandler:(completedHandler)handler;

//创建数据库文件目录
-(NSString *)createDataBaseLocalFileDir;

@end
