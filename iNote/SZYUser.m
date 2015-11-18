//
//  SZYUser.m
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYUser.h"
#import "SZYLocalFileManager.h"


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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"user_session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveAvater:(UIImage *)img IsFake:(BOOL)isFake{
    
    NSParameterAssert(img);
    
    self.head_portrait_url = [[SZYLocalFileManager sharedInstance] saveUserAvater:img UserID:self.user_id isFake:isFake];
    
}

-(void)saveImages:(NSMutableArray *)imgArr IsFake:(BOOL)isFake{
    
    NSParameterAssert(imgArr);
    
    for (UIImage *img in imgArr) {
        NSString *imgURL = [[SZYLocalFileManager sharedInstance] saveUserImage:img UserID:self.user_id isFake:isFake];
        [self.image_url_list addObject:imgURL];
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
