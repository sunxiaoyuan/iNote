//
//  SZYSolidaterFactory.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/7.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSolidaterFactory.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"

@implementation SZYSolidaterFactory

+(id)solidaterFctoryWithType:(NSString *)type{
    
    id solidater = nil;
    if ([type isEqualToString:NSStringFromClass([SZYNoteModel class])]){
        solidater = [[SZYNoteSolidater alloc]init];
    }
    if ([type isEqualToString:NSStringFromClass([SZYNoteBookModel class])]) {
        solidater = [[SZYNoteBookSolidater alloc]init];
    }
    return solidater;
}

@end
