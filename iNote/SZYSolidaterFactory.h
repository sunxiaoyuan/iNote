//
//  SZYSolidaterFactory.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/7.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYNoteSolidater.h"
#import "SZYNoteBookSolidater.h"

@interface SZYSolidaterFactory : NSObject
/**
 *  根据类名创建对应的数据库业务类
 *
 *  @param type 类名
 *
 *  @return 数据库业务类实例xxSolidater
 */
+(id)solidaterFctoryWithType:(NSString *)type;

@end
