//
//  SZYBaseLocalManager.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYLocalManagerProtocol.h"
#import "SZYLocalManagerType.h"
#import "SZYBaseSolidater.h"

@interface SZYBaseLocalManager : NSObject<SZYLocalManagerProtocol>

@property (nonatomic, strong) SZYBaseSolidater *solidater;

@end
