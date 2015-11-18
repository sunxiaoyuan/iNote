//
//  SZYBaseSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/7.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYBaseSolidater.h"
#import "SZYDataBaseService.h"

@implementation SZYBaseSolidater

-(instancetype)init
{
    self = [super init];
    if (self) {
        _dataBase = [[SZYDataBaseService getInstance] fmDataBase];
    }
    return self;
}

-(id)loadCommand:(EBDCommand)command WithParam:(id)param{
    return nil;
}

@end
