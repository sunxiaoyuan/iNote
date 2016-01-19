//
//  AppDelegate.h
//  iNote
//
//  Created by 孙中原 on 15/9/23.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMDatabaseQueue;
@class SZYUser;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow        *window;
@property (nonatomic, strong) SZYUser         *userSession;
@property (nonatomic, assign) BOOL            isLoggedin;
@property (nonatomic ,strong) NSString        *dbasePath;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

