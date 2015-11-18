//
//  SZYNoteBookLocalmanager.m
//  iNote
//
//  Created by 孙中原 on 15/10/27.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteBookLocalmanager.h"
#import "SZYNoteLocalManager.h"
#import "SZYNoteModel.h"

@interface SZYNoteBookLocalmanager ()

@end

@implementation SZYNoteBookLocalmanager


-(NSMutableArray *)noteBooksByUserId:(NSString *)userID{
    
    return [self.solidater loadCommand:EBDCommand_QueryByCondition WithParam:userID];
}




@end
