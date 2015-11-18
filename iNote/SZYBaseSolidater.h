//
//  SZYBaseSolidater.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/7.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

typedef NS_ENUM(NSUInteger , EBDCommand){
    EBDCommand_Save,
    EBDCommand_Update,
    EBDCommand_QueryAll,
    EBDCommand_QueyrOne,
    EBDCommand_QueryByCondition,
    EBDCommand_QueryFavorite,
    EBDCommand_DeleteOne,
    EBDCommand_DeleteAll,
};

@interface SZYBaseSolidater : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

-(id)loadCommand:(EBDCommand)command WithParam:(id)param;

@end
