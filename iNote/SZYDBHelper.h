//
//  SZYDBHelper.h
//  iNote
//
//  Created by sunxiaoyuan on 16/1/9.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "FMDatabasePool.h"

@interface SZYDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (SZYDBHelper *)shareInstance;

+ (NSString *)dbPath;

@end
