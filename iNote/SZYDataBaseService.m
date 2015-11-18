//
//  SZYDataBaseService.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYDataBaseService.h"
#import "FMDatabase.h"

#define kDefaultDataBaseName   @"iNoteLocal.sqlite3"


#pragma mark - 初始化方法，单例模式

static SZYDataBaseService* instance_ = nil;

@implementation SZYDataBaseService{
    // 数据库路径
    NSString* dbasePath;

}

+(SZYDataBaseService *)getInstance{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance_ = (SZYDataBaseService *)@"SZYDataBaseService";
        instance_ = [[SZYDataBaseService alloc]init];
    });

    return instance_;
}

-(id)init{
    
    NSString *str = (NSString *)instance_;
    if ([str isKindOfClass:[NSString class]] || [str isEqualToString:@"SZYDataBaseService"]) {
        
        if (self = [super init]) {
            
            NSArray *arrayForDocument = NSSearchPathForDirectoriesInDomains( NSDocumentationDirectory, NSUserDomainMask, YES);
            NSString *documentPathString = [arrayForDocument objectAtIndex:0];
            NSMutableString *returnStringPath = [[NSMutableString alloc] init];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[documentPathString stringByAppendingString:returnStringPath]]){
                
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:[documentPathString stringByAppendingString:returnStringPath] withIntermediateDirectories:YES attributes:nil error:&error];
            }
            [returnStringPath appendFormat:@"/%@",kDefaultDataBaseName];
            dbasePath = [documentPathString stringByAppendingPathComponent:returnStringPath];
            [self createDatabase];
            
        }
        return self;
 
    }else{
        
        return nil;
    }
   
}

-(void)createDatabase{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbasePath]) {
        self.fmDataBase = [[FMDatabase alloc]initWithPath:dbasePath];
        if ([self.fmDataBase openWithFlags: SQLITE_OPEN_READWRITE]){
            [self.fmDataBase executeUpdate:CREATE_NOTE_TABLE];
            [self.fmDataBase executeUpdate:CREATE_NOTE_BOOK_TABLE];
        }
    }else{
        self.fmDataBase = [[FMDatabase alloc]initWithPath:dbasePath];
        if ([self.fmDataBase open]) {
        }
        [self.fmDataBase executeUpdate:CREATE_NOTE_TABLE];
        [self.fmDataBase executeUpdate:CREATE_NOTE_BOOK_TABLE];
    }
}


//#pragma mark - 私有方法
//-(NSString* )dbMsg:(NSDictionary* )templeDic AndDB:(NSString* )DBMSG
//{
//    NSArray* templeArray = [templeDic allKeys];
//    NSString* keyStr=@"";
//    NSString* valueStr=@"";
//    for (int i=0; i<[templeArray count]; i++) {
//        NSString* templeStr = [templeArray objectAtIndex:i];
//        if (i==[templeArray count]-1) {
//            keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@",templeStr]];
//        }else
//        {
//            keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@,",templeStr]];
//        }
//        
//        if (i==[templeArray count]-1) {
//            valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@":%@",templeStr]];
//        }else
//        {
//            valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@":%@,",templeStr]];
//        }
//    }
//    
//    return [NSString stringWithFormat:@"%@(%@) VALUES(%@)",DBMSG,keyStr,valueStr];
//}

@end
