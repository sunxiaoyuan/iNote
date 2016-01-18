//
//  SZYLocalFileManager.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYLocalFileManager.h"

@interface SZYLocalFileManager ()

@property (nonatomic, strong) NSString      *documentsDir;
@property (nonatomic, strong) NSString      *cacheDir;
@property (nonatomic, strong) NSString      *libraryDir;
@property (nonatomic, strong) NSString      *tempDir;
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
    
    //一级目录：用户手机号
    NSString *userFirFolderPath = [_documentsDir stringByAppendingPathComponent:[ApplicationDelegate.userSession phone_number]];
    //二级目录
    NSString *userSecFolderPath = nil;
    switch (type) {
            
        case kUserFolderType://用户文件夹
        {
            userSecFolderPath = userFirFolderPath;
        }
            break;
        case kNoteImageFolderType://笔记图片文件夹
        {
            userSecFolderPath = [userFirFolderPath stringByAppendingPathComponent:kNoteImageDir];
        }
            break;
        case kNoteContentFolderType://笔记正文文件夹
        {
            userSecFolderPath = [userFirFolderPath stringByAppendingPathComponent:kNoteContentDir];
        }
            break;
        case kNoteVideoFolderType://笔记录音文件夹
        {
            userSecFolderPath = [userFirFolderPath stringByAppendingPathComponent:kNoteVideoDir];
        }
            break;
        case kUserImageFolderType://用户图片文件夹
        {
            userSecFolderPath = [userFirFolderPath stringByAppendingPathComponent:kUserImageDir];
        }
            break;
        case kUserIntervalFolderType://用户心情文件夹
        {
            userSecFolderPath = [userFirFolderPath stringByAppendingPathComponent:kUserIntervalDir];
        }
            break;
            
        default:
            break;
    }
    
    [self creatDir:userSecFolderPath];
    return userSecFolderPath;
}

//创建指定目录
-(void)creatDir:(NSString *)dir{
    
    if (![self.manager fileExistsAtPath:dir]) {
        NSError *error;
        [self.manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

//存储文件到本地
-(void)saveFile:(id)file fileName:(NSString *)fileName withType:(SZYSecondFolderType)type successHandler:(successHandler)success failureHandler:(failureHandler)failure{
    
    NSString* fullPathToFile = [[self setUpLocalFileDir:type] stringByAppendingPathComponent:fileName];
    NSError *error = nil;
    NSData *fileData = nil;
    //图片
    if ([file isKindOfClass:[UIImage class]]) fileData = UIImageJPEGRepresentation((UIImage *)file, 0.5f);
    //文字
    if ([file isKindOfClass:[NSString class]]) fileData = [(NSString *)file dataUsingEncoding:NSUTF8StringEncoding];
    //如果存在同名文件，首先删除
    if ([self.manager fileExistsAtPath:fullPathToFile]) [self.manager removeItemAtPath:fullPathToFile error:&error];
    //写入图片文件
    if ([self.manager createFileAtPath:fullPathToFile contents:fileData attributes:nil]) {
        success(fullPathToFile);
    }else{
        failure(error);
    }
}

-(void)deleteFileWithPath:(NSString *)filePath completionHandler:(completedHandler)handler{
    
    if ([self.manager fileExistsAtPath:filePath]) {
        NSError *error;
        [self.manager removeItemAtPath:filePath error:&error];
        handler(error);
    }
}

-(NSString *)contentFileAtPath:(NSString *)path{
    
    NSError *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return contentStr;
}

-(UIImage *)imageFileAtPath:(NSString *)path{
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

-(float)fileSizeAtTempFolder{
    
    float folderSize;
    if ([self.manager fileExistsAtPath:self.cacheDir]) {
        //拿到含有文件的数组
        NSArray *childerFiles = [self.manager subpathsAtPath:self.cacheDir];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [self.cacheDir stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fullPath];
        }
    }
    return folderSize;
}

-(float)fileSizeAtPath:(NSString *)path{
    
    if([self.manager fileExistsAtPath:path]){
        long long size = [self.manager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

-(void)cleanTempFolderHandler:(completedHandler)block{
    
    NSError *error = nil;
    BOOL isDir;
    if ([self.manager fileExistsAtPath:self.cacheDir isDirectory:&isDir]) {
        //path下的所有子文件夹
        NSArray *childerFiles = [self.manager contentsOfDirectoryAtPath:self.cacheDir error:&error];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [self.cacheDir stringByAppendingPathComponent:fileName];
            [self.manager removeItemAtPath:absolutePath error:&error];
        }
        block(error);
    }
}

-(NSString *)createDataBaseLocalFileDir{

    //获取项目info文件
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取项目Bundle Name
    NSString *key = (NSString *)kCFBundleNameKey;
    NSString *bundleName = infoDict[key];
    //拼接数据库名
    NSString *dbName = [NSString stringWithFormat:@"%@%@",bundleName,@".sqlite3"];

    NSString *documentationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentationPath stringByAppendingPathComponent:dbName];
    [self creatDir:documentationPath];
    return dbPath;
}


@end
