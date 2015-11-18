//
//  SZYBaseLocalManager.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYBaseLocalManager.h"
#import "SZYSolidaterFactory.h"
#import "SZYSolidaterFactory.h"


@implementation SZYBaseLocalManager


-(BOOL)save:(id)model{
    
    return [self.solidater loadCommand:EBDCommand_Save WithParam:model];
}

-(NSMutableArray *)allModels{
    
    return [self.solidater loadCommand:EBDCommand_QueryAll WithParam:nil];
}

-(id)modelById:(NSString *)modelId{
    
    return [self.solidater loadCommand:EBDCommand_QueyrOne WithParam:modelId];
}

-(void)updateModelById:(NSString *)modelId WithData:(id)model{
    
    NSDictionary *paramDict = @{@"id":modelId,
                                @"data":model};
    [self.solidater loadCommand:EBDCommand_Update WithParam:paramDict];
}

-(void)deleteAllModels{
    
    [self.solidater loadCommand:EBDCommand_DeleteAll WithParam:nil];
}

-(void)deleteModelById:(NSString *)modelId{
    
    [self.solidater loadCommand:EBDCommand_DeleteOne WithParam:modelId];
}


@end
