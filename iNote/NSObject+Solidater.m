//
//  NSObject+Solidater.m
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "NSObject+Solidater.h"


@implementation NSObject (Solidater)

- (void)solidateDataWithKey:(NSString *)key{
    
    [[SZYDataSolidater sharedInstance] solidateData:self withKey:key];
    
}

+(id)unsolidateByKey:(NSString *)key{
    
    return [[SZYDataSolidater sharedInstance] dataByKey:key];
}


@end
