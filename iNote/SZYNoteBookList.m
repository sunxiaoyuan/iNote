//
//  SZYNoteBookList.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/10.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookList.h"

@interface SZYNoteBookList ()


@end

@implementation SZYNoteBookList

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.noteBookList = array;
    }
    return self;
}


- (id)currentState{
    
    return @{@"NoteBookList":self.noteBookList};
}

- (void)recoverFromState:(id)state{
    
    self.noteBookList = state[@"NoteBookList"];
}

@end
