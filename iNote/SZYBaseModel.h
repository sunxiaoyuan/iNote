//
//  SZYBaseModel.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SZYKit.h"
#import "SZYLocalFileManager.h"
#import "MJExtension.h"

@interface SZYBaseModel : NSObject

//根据字典初始化对象
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
