//
//  SZYLocalManagerProtocol.h
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  统一数据持久化类的接口

#import <Foundation/Foundation.h>

@protocol SZYLocalManagerProtocol <NSObject>

@required

//插入
-(BOOL)save:(id)model;
//查询
-(NSMutableArray *)allModels;
-(id)modelById:(NSString *)modelId;
//更新，修改
-(void)updateModelById:(NSString *)modelId WithData:(id)model;
//删除
-(void)deleteAllModels;
-(void)deleteModelById:(NSString *)modelId;


@end
