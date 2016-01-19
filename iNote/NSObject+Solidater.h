//
//  NSObject+Solidater.h
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYDataSolidater.h"

@interface NSObject (Solidater)

//完成任何对象的一键固化
-(void)solidateDataWithKey:(NSString *)key;

+(id)unsolidateByKey:(NSString *)key;

@end
