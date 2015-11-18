//
//  SZYDataBaseService.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////


                   //单例实现，注意严格的单例的实现



////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "SZYDataBaseDef.h"
@class FMDatabase;

@interface SZYDataBaseService : NSObject

+(SZYDataBaseService*) getInstance;

@property (nonatomic, strong) FMDatabase *fmDataBase;

@end
