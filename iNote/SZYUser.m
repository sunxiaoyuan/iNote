//
//  SZYUser.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYUser.h"
#import "SZYLocalFileManager.h"
#import "NSDate+TimeStamp.h"

@implementation SZYUser

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber AndUserID:(NSString *)user_id
{
    self = [super init];
    if (self) {
        self.phone_number = phoneNumber;
        self.user_id = user_id;
        self.image_url_list = [NSMutableArray array];
    }
    return self;
}

-(void)cleanLocalSaveData{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDUserSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveAvater:(UIImage *)img {
    
    
    [[SZYLocalFileManager sharedInstance] saveFile:img fileName:[NSString stringWithFormat:@"%@-%@.jpg",_user_id,kUserAvaterSuffix] withType:kUserImageFolderType successHandler:^(NSString *filePath) {
        
        self.head_portrait_url = filePath;
        
    } failureHandler:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)saveImages:(NSMutableArray *)imgArr {
    
    for (UIImage *img in imgArr) {
        NSString *imageName = [NSString stringWithFormat:@"%ld%@-%@.jpg",[NSDate currentTimeStampWithLongFormat],_user_id,kUserImageSuffix];
        [[SZYLocalFileManager sharedInstance] saveFile:img fileName:imageName withType:kUserImageFolderType successHandler:^(NSString *filePath) {
            [self.image_url_list addObject:filePath];
        } failureHandler:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

-(NSMutableArray *)photosAtLocal{
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (NSString *imgURL in self.image_url_list) {
        [imgArr addObject:[[SZYLocalFileManager sharedInstance] imageFileAtPath:imgURL]];
    }
    return imgArr;
}

-(UIImage *)avaterAtLocal{
    
    return [[SZYLocalFileManager sharedInstance] imageFileAtPath:self.head_portrait_url];
    
}

@end
