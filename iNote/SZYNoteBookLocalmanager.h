//
//  SZYNoteBookLocalmanager.h
//  iNote
//
//  Created by 孙中原 on 15/10/27.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYBaseLocalManager.h"

@interface SZYNoteBookLocalmanager : SZYBaseLocalManager

-(NSMutableArray *)noteBooksByUserId:(NSString *)userID;

@end
