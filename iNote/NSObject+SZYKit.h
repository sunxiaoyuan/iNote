//
//  NSObject+SZYKit.h
//  iNote
//
//  Created by 金钟 on 16/1/11.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SZYKit)

+ (NSDictionary *)getPropertyInfoDict;

-(void)transferNilPropertiesToNullString;

@end
