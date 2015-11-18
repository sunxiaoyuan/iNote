//
//  SZYLocalManagerFactory.m
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYLocalManagerFactory.h"

@implementation SZYLocalManagerFactory


+(SZYBaseLocalManager <SZYLocalManagerProtocol> *)managerFactoryWithType:(SZYLocalManagerType)type
{
    SZYBaseLocalManager <SZYLocalManagerProtocol> *manager = nil;
    switch (type) {
        case kNoteType:
        {
            manager = [[SZYNoteLocalManager alloc]init];
        }
            break;
        case kNoteBookType:
        {
            manager = [[SZYNoteBookLocalmanager alloc]init];
        }
            break;
    }
    return manager;
    
}

@end
