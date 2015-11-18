//
//  SZYMemento.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYMementoProtocol.h"

@interface SZYMemento : NSObject

+(void)createMementoForObject:(id<SZYMementoProtocol>)object WithKey:(NSString *)key;

+(id)fetchObjectFromMementoWithKey:(NSString *)key;

@end
