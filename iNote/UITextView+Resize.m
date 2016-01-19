//
//  UITextView+Resize.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/30.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "UITextView+Resize.h"

@implementation UITextView (Resize)

- (CGSize)resize{
    
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    =  ( self.contentInset.left//滚动边距
                            + self.contentInset.right
                            + self.textContainerInset.left//页边距
                            + self.textContainerInset.right
                            + self.textContainer.lineFragmentPadding//边距
                            + self.textContainer.lineFragmentPadding);
    
    CGFloat broadHeight  =  ( self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize inSize = CGSizeMake(contentWidth, MAXFLOAT);
    //设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    //折行文本的高度
    CGSize calculatedSize =  [self.text boundingRectWithSize:inSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:dic context:nil].size;
    //新的size
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);
    
    return adjustedSize;
}

@end
