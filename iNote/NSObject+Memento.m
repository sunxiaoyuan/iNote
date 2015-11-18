//
//  NSObject+Memento.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "NSObject+Memento.h"
#import "SZYMemento.h"

@implementation NSObject (Memento)

- (void)saveStateWithKey:(NSString *)key {
    
    NSParameterAssert(key);

    id <SZYMementoProtocol> obj = (id <SZYMementoProtocol>)self;
    [SZYMemento createMementoForObject:obj WithKey:key];
    
}

- (void)recoverFromStateWithKey:(NSString *)key {
    
    NSParameterAssert(key);
    
    id state = [SZYMemento fetchObjectFromMementoWithKey:key];
    id <SZYMementoProtocol> obj = (id <SZYMementoProtocol>)self;
    [obj recoverFromState:state];

}

@end
