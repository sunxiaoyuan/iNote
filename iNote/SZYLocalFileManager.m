//
//  SZYLocalFileManager.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYLocalFileManager.h"


@interface SZYLocalFileManager ()

@property (nonatomic, strong) NSString *documentsDir;
@property (nonatomic, strong) NSString *cacheDir;
@property (nonatomic, strong) NSString *libraryDir;
@property (nonatomic, strong) NSString *tempDir;
@property (nonatomic, strong) NSFileManager *manager;

@end

static SZYLocalFileManager *manager = nil;

@implementation SZYLocalFileManager


+(SZYLocalFileManager *)sharedInstance{
    
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        manager = (SZYLocalFileManager *)@"SZYLocalFileManager";
        manager = [[SZYLocalFileManager alloc]init];
    });
    
    NSString *classStr = NSStringFromClass([self class]);
    if (![classStr isEqualToString:@"SZYLocalFileManager"]) {
        NSParameterAssert(nil);
    }
    return manager;
    
}

- (instancetype)init
{
    
    NSString *str = (NSString *)manager;
    if ([str isKindOfClass:[NSString class]] || [str isEqualToString:@"SZYLocalFileManager"]) {
        self = [super init];
        if (self) {
            NSString *classStr = NSStringFromClass([self class]);
            if (![classStr isEqualToString:@"SZYLocalFileManager"]) {
                NSParameterAssert(nil);
            }
            
            self.documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            self.cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            self.libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            self.tempDir = NSTemporaryDirectory();
            
            self.manager = [NSFileManager defaultManager];
            
        }
        return self;
        
    }else{
        
        return nil;
    }
}

//创建各级目录
-(NSString *)setUpLocalFileDir:(SZYSecondFolderType)type{
        
    NSString *userFolderPath = [_documentsDir stringByAppendingPathComponent:[ApplicationDelegate.userSession phone_number]];
    
    NSString *resultPath = nil;
    
    switch (type) {
            
        case kUserFolderType:
        {
            [self creatDir:userFolderPath];
            resultPath = userFolderPath;
        }
            break;
            
        case kNoteImageFolderType:
        {
            
            NSString *noteImagePath = [userFolderPath stringByAppendingPathComponent:kNoteImageDir];
            [self creatDir:noteImagePath];
            resultPath = noteImagePath;
            
        }
            break;
            
        case kNoteContentFolderType:
        {
            
            NSString *noteContentPath = [userFolderPath stringByAppendingPathComponent:kNoteContentDir];
            [self creatDir:noteContentPath];
            resultPath = noteContentPath;
            
        }
            break;
        case kNoteVideoFolderType:
        {
            NSString *noteVideoPath = [userFolderPath stringByAppendingPathComponent:kNoteVideoDir];
            [self creatDir:noteVideoPath];
            resultPath = noteVideoPath;
            
        }
            break;
        case kUserImageFolderType:
        {
            NSString *userAvaterPath = [userFolderPath stringByAppendingPathComponent:kUserImageDir];
            [self creatDir:userAvaterPath];
            resultPath = userAvaterPath;
            
        }
            break;
        case kUserIntervalFolderType:
        {
            
            NSString *userIntervalPath = [userFolderPath stringByAppendingPathComponent:kUserIntervalDir];
            [self creatDir:userIntervalPath];
            resultPath = userIntervalPath;
        }
            break;

        default:
            break;
    }
    
    
    return resultPath;
}

//创建目录
-(void)creatDir:(NSString *)dir{
    
    if (![self.manager fileExistsAtPath:dir]) {
        NSError *error;
        [self.manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


#pragma mark - 笔记业务

//保存笔记的图片到本地
-(NSString *)saveNoteImage:(UIImage *)image NoteID:(NSString *)noteID IsFake:(BOOL)isFake{
    
    //图片转成NSData格式
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    //文件名称
    NSString *imageFileName = [NSString stringWithFormat:@"%@-%@.jpg",noteID,kNoteImageFileSuffix];
    
    NSString* fullPathToFile = [[self setUpLocalFileDir:kNoteImageFolderType] stringByAppendingPathComponent:imageFileName];
    
    if (!isFake) {
        
        if ([self.manager fileExistsAtPath:fullPathToFile]) {
            //如果存在同名文件，首先删除
            NSError *error;
            [self.manager removeItemAtPath:fullPathToFile error:&error];
        }
        //写入图片文件
        [imageData writeToFile:fullPathToFile atomically:NO];
    }

    return fullPathToFile;
}

//保存笔记正文到本地
-(NSString *)saveNoteContent:(NSString *)content NoteID:(NSString *)noteID isFake:(BOOL)isFake{
   
    NSString *textFileName = [NSString stringWithFormat:@"%@-%@.txt",noteID,kNoteContentFileSuffix];
    
    NSString* fullPathToFile = [[self setUpLocalFileDir:kNoteContentFolderType] stringByAppendingPathComponent:textFileName];
    
    if (!isFake) {
        if ([self.manager fileExistsAtPath:fullPathToFile]) {
            NSError *error;
            [self.manager removeItemAtPath:fullPathToFile error:&error];
        }
        [self.manager createFileAtPath:fullPathToFile contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }

    return fullPathToFile;
}

//返回笔记录音可用地址
-(NSString *)noteVideoPathWithNoteID:(NSString *)noteID{
    
    NSString *videoFileName = [NSString stringWithFormat:@"%@-%@.caf",noteID,kNoteVideoFileSuffix];
    NSString* fullPathToFile = [[self setUpLocalFileDir:kNoteVideoFolderType] stringByAppendingPathComponent:videoFileName];
    return fullPathToFile;
}

-(NSString *)contentFileAtPath:(NSString *)path{
    
    NSError *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return contentStr;
}

-(UIImage *)imageFileAtPath:(NSString *)path{
    
    return  [UIImage imageWithContentsOfFile:path];
}


#pragma mark - 用户信息业务


-(NSString *)saveUserAvater:(UIImage *)image UserID:(NSString *)userID isFake:(BOOL)isFake{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    NSString *imageName = [NSString stringWithFormat:@"%@-%@.jpg",userID,kUserAvaterSuffix];
    
    NSString* fullPathToFile = [[self setUpLocalFileDir:kUserImageFolderType] stringByAppendingPathComponent:imageName];
    
    if (!isFake) {
        if ([self.manager fileExistsAtPath:fullPathToFile]) {
            //如果存在同名文件，首先删除
            NSError *error;
            [self.manager removeItemAtPath:fullPathToFile error:&error];
        }
        [imageData writeToFile:fullPathToFile atomically:NO];
    }
    return fullPathToFile;
}

-(NSString *)saveUserImage:(UIImage *)image UserID:(NSString *)userID isFake:(BOOL)isFake{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    //加时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@-%@.jpg",timeStr,userID,kUserImageSuffix];
    
    NSString* fullPathToFile = [[self setUpLocalFileDir:kUserImageFolderType] stringByAppendingPathComponent:imageName];
    
    if (!isFake) {
        if ([self.manager fileExistsAtPath:fullPathToFile]) {
            //如果存在同名文件，首先删除
            NSError *error;
            [self.manager removeItemAtPath:fullPathToFile error:&error];
        }
        [imageData writeToFile:fullPathToFile atomically:NO];
    }
    return fullPathToFile;
    
}

#pragma mark - 其他业务

//获取temp文件夹下,所有文件的大小
-(float)fileSizeAtTempFolder{
    
    NSString *tempDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:tempDirectory]) {
        //拿到含有文件的数组
        NSArray *childerFiles = [fileManager subpathsAtPath:tempDirectory];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [tempDirectory stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fullPath];
        }
    }
    return folderSize;
}

//计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//清除temp文件夹下的缓存
-(void)cleanTempFolder{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
}

@end
