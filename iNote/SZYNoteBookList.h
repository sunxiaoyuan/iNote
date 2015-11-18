//
//  SZYNoteBookList.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYMementoProtocol.h"

@interface SZYNoteBookList : NSObject<SZYMementoProtocol>

- (instancetype)initWithArray:(NSArray *)array;

@property (nonatomic, strong) NSArray *noteBookList;

@end
