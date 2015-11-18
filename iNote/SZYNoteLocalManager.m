//
//  SZYNoteLocalManager.m
//  iNote
//
//  Created by 孙中原 on 15/10/27.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteLocalManager.h"

@implementation SZYNoteLocalManager

#pragma mark - 扩展方法

-(NSMutableArray *)notesByNoteBookId:(NSString *)noteBookId{
    
    return [self.solidater loadCommand:EBDCommand_QueryByCondition WithParam:noteBookId];
    
}

-(NSMutableArray *)notesWithFavorite{
    
    return [self.solidater loadCommand:EBDCommand_QueryFavorite WithParam:nil];
}


@end
