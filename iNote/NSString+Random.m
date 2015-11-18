//
//  NSString+Random.m
//  GameEmulator
//
//  Created by 孙中原 on 15/10/27.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "NSString+Random.h"

@implementation NSString (Random)

+(NSString *)RandomString{
    
    char data[20];
    for (int i = 0; i < 20; data[i++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc]initWithBytes:data length:20 encoding:NSUTF8StringEncoding];
    
}

@end
