//
//  SZYDBHelper.m
//  iNote
//
//  Created by sunxiaoyuan on 16/1/9.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "SZYDBHelper.h"
@interface SZYDBHelper ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end
@implementation SZYDBHelper

static SZYDBHelper *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}

+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"SZYBD"];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"szydb.sqlite"];
    return dbpath;
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [SZYDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [SZYDBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif
@end
