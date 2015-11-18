//
//  SZYOpenListView.h
//  iNote
//
//  Created by 孙中原 on 15/10/10.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZYOpenListViewDelegate <NSObject>

-(void)haveTouchedShadowView;

@end

@interface SZYOpenListView : UIView

@property (nonatomic, copy  ) NSMutableArray          *noteBookListData;//数据源
@property (nonatomic, assign) NSInteger               selectedIndex;
@property (nonatomic, assign) id<SZYOpenListViewDelegate> delegate;

-(void)refreshOpenList:(NSMutableArray *)dataArr;

@end
