//
//  SZYDataSolidater.h
//  iNote
//
//  Created by 孙中原 on 15/10/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//
//
////////////////////////////////////////////////////////////////////////////////


          //单例实现，注意严格的单例的实现



////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "FastCoder.h"

@interface SZYDataSolidater : NSObject

+ (SZYDataSolidater *)sharedInstance;

- (void)solidateData:(id)data withKey:(NSString *)key;
- (id)dataByKey:(NSString *)key;


@end
