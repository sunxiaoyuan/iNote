//
//  SZYUser.h
//  iNote
//
//  Created by 孙中原 on 15/10/28.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZYUser : NSObject

//id
@property (nonatomic, copy  ) NSString       *user_id;
//注册时间
@property (nonatomic, copy  ) NSString       *regist_date;
//昵称
@property (nonatomic, copy  ) NSString       *user_nickname;
//性别
@property (nonatomic, copy  ) NSString       *user_sex;
//签名
@property (nonatomic, copy  ) NSString       *user_status;
//手机号码
@property (nonatomic, copy  ) NSString       *phone_number;
//密码
@property (nonatomic, copy  ) NSString       *login_password;
//生日
@property (nonatomic ,strong) NSString       *user_birth;
//头像
@property (nonatomic, copy  ) NSString       *head_portrait_url;


- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber AndUserID:(NSString *)user_id;
-(void)cleanLocalSaveData;

-(void)saveAvater:(UIImage *)img;

-(UIImage *)avaterAtLocal;

@end
