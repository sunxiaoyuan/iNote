//
//  SZYDataSolidater.m
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYDataSolidater.h"

static SZYDataSolidater *solidater = nil;

@implementation SZYDataSolidater

#pragma mark - 实现严格单例

+ (SZYDataSolidater *)sharedInstance{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        solidater = (SZYDataSolidater *)@"SZYDataSolidater";
        solidater = [[SZYDataSolidater alloc] init];
    });
    
    NSString *classStr = NSStringFromClass([self class]);
    if (![classStr isEqualToString:@"SZYDataSolidater"]) {
        
        NSParameterAssert(nil);
    }
    
    return solidater;
 
}

- (instancetype)init
{
    NSString *str = (NSString *)solidater;
    if ([str isKindOfClass:[NSString class]] || [str isEqualToString:@"SZYDataSolidater"]) {
        
        self = [super init];
        if (self) {
            NSString *classString = NSStringFromClass([self class]);
            if (![classString isEqualToString:@"SZYDataSolidater"]) {
                
                NSParameterAssert(nil);
            }
        }
        return self;
    }
    else{
        
        return nil;
    }
  
}

#pragma mark - 

- (void)solidateData:(id)data withKey:(NSString *)key{
    
    NSParameterAssert(data);
    NSParameterAssert(key);
    //当前的固化策略是 ：NSUserDefaults存储
    NSData *solidData = [FastCoder dataWithRootObject:data];
    if (solidData) {
        
        [[NSUserDefaults standardUserDefaults]setObject:solidData forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (id)dataByKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    return [FastCoder objectWithData:data];
}


@end
