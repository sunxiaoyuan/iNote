//
//  SZYBaseCell.m
//  iNote
//
//  Created by 孙中原 on 15/10/22.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYBaseCell.h"

@implementation SZYBaseCell


+(id)loadFromXib{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
}

-(void)setNote:(SZYNoteModel *)note FrameInfo:(SZYNoteFrameInfo *)info{
    
}


@end
