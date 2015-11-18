//
//  SZYMemento.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYMemento.h"

@implementation SZYMemento

+(void)createMementoForObject:(id<SZYMementoProtocol>)object WithKey:(NSString *)key{
    
    NSParameterAssert(object);
    NSParameterAssert(key);
    
    id data    = [object currentState];
    NSData *tmpData = [FastCoder dataWithRootObject:data];
    
    // 进行存储
    if (tmpData) {
        
        [[NSUserDefaults standardUserDefaults] setObject:tmpData
                                                  forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

+(id)fetchObjectFromMementoWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    
    id data = nil;
    NSData *tmpData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (tmpData) {
        
        data = [FastCoder objectWithData:tmpData];
    }
    
    return data;
}

@end
