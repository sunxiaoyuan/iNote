//
//  UIImage+Size.h
//  iNote
//
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

//修改image的大小
-(UIImage *)imageByScalingToSize:(CGSize)targetSize;
-(UIImage *)compressToSize:(CGSize)size;
// 控件截屏
+(UIImage *)imageWithCaputureView:(UIView *)view;
//截取部分图像
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;

//修正方向
+(UIImage *)fixOrientation:(UIImage *)aImage;

@end
