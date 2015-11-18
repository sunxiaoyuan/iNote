//
//  NSObject+Memento.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Memento)


- (void)saveStateWithKey:(NSString *)key;


- (void)recoverFromStateWithKey:(NSString *)key;


@end
