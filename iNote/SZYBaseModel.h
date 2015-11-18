//
//  SZYBaseModel.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Random.h"
#import "SZYLocalFileManager.h"

@interface SZYBaseModel : NSObject

//初始化的类方法
+(instancetype)modelWithDict:(NSDictionary *)dict;

+(id)modalWithID;

@end
