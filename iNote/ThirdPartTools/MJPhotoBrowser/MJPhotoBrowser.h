//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
// 代理
@property (nonatomic, assign) id <MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger                    currentPhotoIndex;
@property (nonatomic, strong) UIAlertView                   *alertView;
@property (nonatomic, strong) UIButton                      *selectButton;
@property (nonatomic, assign) BOOL                          isZQ;
@property (nonatomic, strong) NSString                      *toolBarTitle;

// 显示
- (void)show;
- (id)initWithisZQ:(BOOL)isZQ ToolBarTitle:(NSString *)title;
- (void)disappear;
@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)selectImage:(UIImage *)image;
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end