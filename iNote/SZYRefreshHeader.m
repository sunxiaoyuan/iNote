//
//  SZYRefreshHeader.m
//  iNote
//
//  Created by 孙中原 on 15/9/29.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYRefreshHeader.h"
#import "UIImage+Size.h"

@implementation SZYRefreshHeader

#pragma mark - 重写方法
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [self imgArrFromImageIndex:1 toImageIndex:50];
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态
    NSMutableArray *redeayImages = [self imgArrFromImageIndex:50 toImageIndex:70];
    [self setImages:redeayImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [self imgArrFromImageIndex:70 toImageIndex:95];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}

-(NSMutableArray *)imgArrFromImageIndex:(int)beginingIndex toImageIndex:(int)endingIndex{
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSUInteger i = beginingIndex; i <= endingIndex; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%lu", (unsigned long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *sacaledImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [imageArr addObject:sacaledImage];
    }
    return imageArr;
}

@end
