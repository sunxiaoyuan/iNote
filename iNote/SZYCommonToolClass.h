//
//  SZYCommonToolClass.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//  公共方法类

#import <Foundation/Foundation.h>

@interface SZYCommonToolClass : NSObject

/**
 *  处理时间戳，获取相应的时间显示
 *
 *  @param createTime 时间戳字符串
 *
 *  @return xxx前
 */
-(NSString *)createDate:(NSString *)createTime;
/**
 *  根据label的内容，字体等信息计算label的尺寸
 *
 *
 *  @return cgsize
 */
-(CGSize)newLabelSizeWithContent:(NSString *)text Font:(UIFont *)font IsSngle:(BOOL)isSingle Width:(CGFloat)width;



/**
 *  手机照片，翻转修正
 *
 */
- (UIImage *)fixOrientation:(UIImage *)aImage;




/**
 *  模糊照片方法
 *
 */
-(UIImage *)blurImageWithImage:(UIImage *)inputImage;
/**
 *  计算textview文本尺寸
 *
 */
-(CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;

@end
