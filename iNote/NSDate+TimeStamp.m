//
//  NSDate+TimeStamp.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "NSDate+TimeStamp.h"

@implementation NSDate (TimeStamp)

+(NSString *)szyTimeStamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return str;
}

@end
