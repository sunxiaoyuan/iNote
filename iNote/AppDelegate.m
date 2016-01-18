//
//  AppDelegate.m
//  iNote
//
//  Created by 孙中原 on 15/9/23.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "SZYNoteBookModel.h"
#import "SZYLocalFileManager.h"
#import "SZYUser.h"
#import "FMDatabaseQueue.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"

@interface AppDelegate ()
@property (nonatomic ,strong) SZYNoteModel *tempNote;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //修改控制器的tatusBar样式,需要注意在info.plist里配置一下
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //加载数据库路径
    self.dbasePath = [[SZYLocalFileManager sharedInstance] createDataBaseLocalFileDir];
    //加载数据库安全队列
    //一般在App中应该保持一个FMDatabaseQueue的实例，并在所有的线程中都只使用这一个实例。这里我们选择AppDelegate这个单例持有这个实例，可以实现这一需求
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbasePath];
    //初始化本地信息
    [self setUpLocalInfo];
   
    return YES;
}

-(void)setUpLocalInfo{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:UDUserSession]) {
        //创建临时用户
        self.userSession = [[SZYUser alloc]initWithPhoneNumber:TempUserPhoneNumber AndUserID:TempUserID];
        [self.userSession solidateDataWithKey:UDUserSession];
        //为临时用户创建本地一级目录
        [[SZYLocalFileManager sharedInstance] setUpLocalFileDir:kUserFolderType];
        self.isLoggedin = NO;
    } else {
        //从本地读取用户信息
        self.userSession = [SZYUser unsolidateByKey:UDUserSession];
        self.isLoggedin = ![self.userSession.user_id isEqualToString:TempUserID];
    }
    //创建默认笔记本
    [self createDefaultNoteBook];
}

-(void)createDefaultNoteBook{
    
    SZYNoteBookSolidater *solidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
    //思考这样一个情景：如果后台在执行大量的更新，而主线程也需要访问数据库，虽然要访问的数据量很少，但是在后台执行完之前，还是会阻塞主线程
    //所以在大多数时候，应该把从主线程调用inDatabase和inTransaction放在异步里
    //但是实际上，这种方式能解决不依赖于数据库返回的结果的情况，如果对返回结果有依赖，就需要考虑UI上的体验了
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            //保证本地必须有默认文件夹
            [solidater readOneByID:kDEFAULT_NOTEBOOK_ID successHandler:^(id result) {
                if (!result) {
                    SZYNoteBookModel *defaultNoteBook = [[SZYNoteBookModel alloc]initWithID:kDEFAULT_NOTEBOOK_ID Title:@"默认笔记本" UserID:self.userSession.user_id IsPrivate:@"NO"];
                    [solidater saveOne:defaultNoteBook successHandler:^(id result) {
                        
                    } failureHandler:^(NSString *errorMsg) {
                        NSLog(@"error = %@",errorMsg);
                    }];
                }
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"error = %@",errorMsg);
            }];
        }];
    });
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
