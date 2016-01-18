//
//  SZYCommonToolClass.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYCommonToolClass.h"

#define MAX_LIMIT_NUMS     5000

@implementation SZYCommonToolClass

-(NSString *)createDate:(NSString *)createTime{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [formatter dateFromString:createTime];
    NSTimeInterval aTimer = [now timeIntervalSinceDate:destDate];
    float Year = aTimer/(60*60*24*365);
    float Day = aTimer/(60*60*24);
    float Hour = aTimer/(60*60);
    float Minut = aTimer/(60);
    if (Year>=1.0) {
        return [NSString stringWithFormat:@"%d",(int)Year];
    }else if (Day>=3.0)
    {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"MM-dd"];
        return [formatter1 stringFromDate:destDate];
    }else if (Day>=1.0)
    {
        return [NSString stringWithFormat:@"%d天前",(int)Day];
    }
    else if (Hour>1.0)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)Hour];
    }else if (Minut>1.0)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)Minut];
    }else
    {
        return @"刚刚";
    }
    return @" ";
}

-(CGSize)newLabelSizeWithContent:(NSString *)text Font:(UIFont *)font IsSngle:(BOOL)isSingle Width:(CGFloat)width{
    
    CGSize requiredSize;
    if (isSingle) {
        //计算单行文本数据的显示
        requiredSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    }else{
        //计算多行文本数据的显示
        CGSize boundSize = CGSizeMake(width, CGFLOAT_MAX);
        requiredSize = [text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    return requiredSize;
}




- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}




-(UIImage *)blurImageWithImage:(UIImage *)inputImage{
    
    CIImage *ciImage = [[CIImage alloc]initWithImage:inputImage];
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    
    [blurFilter setValue:@(20) forKey:@"inputRadius"];
    
    CIImage *outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
    
    UIImage *blurImage = [UIImage imageWithCGImage:outCGImage];
    
    CGImageRelease(outCGImage);
    
    return blurImage;
    
}

- (CGSize)resizeTextView:(UITextView *)textView{
    
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    CGSize calculatedSize =  [textView.text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);
    return adjustedSize;
}





@end
