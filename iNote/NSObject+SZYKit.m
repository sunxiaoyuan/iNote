//
//  NSObject+SZYKit.m
//  iNote
//
//  Created by 金钟 on 16/1/11.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "NSObject+SZYKit.h"
#import <objc/runtime.h>

@implementation NSObject (SZYKit)

+ (NSDictionary *)getPropertyInfoDict{
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        [proTypes addObject:propertyType];
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"propertyName",proTypes,@"propertyType",nil];
}

-(void)transferNilPropertiesToNullString{
    
    NSMutableArray *proNames = [NSMutableArray array];
    unsigned int outCount, i;
    //获取一个属性信息结构体的数组
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [proNames addObject:propertyName];
    }
    free(properties);
    //过滤掉nil，实际上是置成空字符串
    for (NSString *proName in proNames) {
        if (![self valueForKey:proName]) {
            [self setValue:@"" forKey:proName];
        }
    }
}



@end
