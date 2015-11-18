//
//  SZYSolidaterFactory.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/7.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYSolidaterFactory.h"
#import "SZYNoteSolidater.h"
#import "SZYNoteBookSolidater.h"

@implementation SZYSolidaterFactory

+(id)solidaterFctoryWithType:(SZYLocalManagerType)type{
    
    switch (type) {
            
        case kNoteType:
        {
            SZYNoteSolidater *solidater = [[SZYNoteSolidater alloc]init];
            return solidater;
        }
            break;
        case kNoteBookType:
        {
            SZYNoteBookSolidater *solidater = [[SZYNoteBookSolidater alloc]init];
            return solidater;
        }
            break;
    }
}

@end
