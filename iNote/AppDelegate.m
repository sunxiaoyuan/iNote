//
//  AppDelegate.m
//  iNote
//
//  Created by 孙中原 on 15/9/23.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "SZYNoteBookModel.h"
#import "SZYNoteBookLocalmanager.h"
#import "SZYLocalFileManager.h"
#import "SZYUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //修改控制器的tatusBar样式,需要注意在info.plist里配置一下
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //初始化本地信息
    [self setUpLocalInfo];
   
    return YES;
}

-(void)setUpLocalInfo{
    
//    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"user_session"]) {
        //创建临时用户
        self.userSession = [[SZYUser alloc]initWithPhoneNumber:@"TempUser" AndUserID:@"TempUser"];
        [self.userSession solidateDataWithKey:@"user_session"];
        //为临时用户创建本地目录
        [[SZYLocalFileManager sharedInstance] setUpLocalFileDir:kUserFolderType];
        self.isLoggedin = NO;
    } else {
        //从本地读取用户信息
        NSData *data = [defaults objectForKey:@"user_session"];
        self.userSession = [FastCoder objectWithData:data];
        self.isLoggedin = ![self.userSession.user_id isEqualToString:@"TempUser"];
    }
    //创建默认笔记本
    [self createDefaultNoteBook];
}

-(void)createDefaultNoteBook{
    
    SZYNoteBookLocalmanager *noteBookLM = (SZYNoteBookLocalmanager *)[SZYLocalManagerFactory managerFactoryWithType:kNoteBookType]; //工厂模式取得实例
    noteBookLM.solidater = [SZYSolidaterFactory solidaterFctoryWithType:kNoteBookType];
    //保证本地必须有默认文件夹
    if (![noteBookLM modelById:kDEFAULT_NOTEBOOK_ID]) {
        SZYNoteBookModel *defaultNoteBook = [[SZYNoteBookModel alloc]init];
        defaultNoteBook.noteBook_id = kDEFAULT_NOTEBOOK_ID;
        defaultNoteBook.title = @"默认笔记本";
        defaultNoteBook.user_id_belonged = self.userSession.user_id;
        defaultNoteBook.isPrivate = @"NO";
        //保存“默认笔记本”
        [noteBookLM save:defaultNoteBook];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
