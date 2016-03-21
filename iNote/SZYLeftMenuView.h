//
//  SZYLeftMenuView.h
//  iNote
//
//  Created by 孙中原 on 15/10/8.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//LeftView按钮类型
typedef NS_ENUM(NSInteger, SZYleftButtonType) {
    SZYleftButtonTypeHome,
    SZYleftButtonTypeNotes,
    SZYleftButtonTypeFavorite,
    SZYleftButtonTypeSeting,
    SZYleftButtonTypeLogin,
};

@protocol SZYLeftMenuViewDelegate <NSObject>
@required
//左边按钮被点击时调用
- (void)switchViewControllerFrom:(SZYleftButtonType)fromIndex To:(SZYleftButtonType)toIndex;
@end

@interface SZYLeftMenuView : UIView

@property (nonatomic, weak) id <SZYLeftMenuViewDelegate> delegate;
@property (weak, nonatomic  ) IBOutlet UIButton           *loginBtn;


@end