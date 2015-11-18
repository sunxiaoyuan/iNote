//
//  SZYMementoProtocol.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZYMementoProtocol <NSObject>

- (id)currentState;

- (void)recoverFromState:(id)state;


@end
