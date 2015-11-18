//
//  SZYLocalManagerFactory.h
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  简单工厂类

#import <Foundation/Foundation.h>
#import "SZYBaseLocalManager.h"
#import "SZYNoteLocalManager.h"
#import "SZYNoteBookLocalmanager.h"
#import "SZYLocalManagerType.h"


@interface SZYLocalManagerFactory : NSObject


+(SZYBaseLocalManager <SZYLocalManagerProtocol> *)managerFactoryWithType:(SZYLocalManagerType)type;

@end
