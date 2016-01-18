//
//  SZYOpenListView.h
//  iNote
//
//  Created by 孙中原 on 15/10/10.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYOpenListViewDelegate <NSObject>
//点击下拉列表或者阴影部分
-(void)openListShouldDisappear:(NSInteger)selectedIndex;

@end

@interface SZYOpenListView : UIView

@property (nonatomic, assign) id<SZYOpenListViewDelegate> delegate;
-(void)refreshOpenList:(NSMutableArray *)dataArr;
-(void)makeTranslateAnimation:(BOOL)isUp;
@end
