//
//  SZYCustomNaviView.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZYOpenListView.h"
#import "SZYCustomNaviViewDelegate.h"


@interface SZYCustomNaviView : UIView<SZYOpenListViewDelegate>

@property (nonatomic, assign  ) id<SZYCustomNaviViewDelegate> delegate;

-(void)setNoteBooksData:(NSMutableArray *)noteBookArr;

@end
