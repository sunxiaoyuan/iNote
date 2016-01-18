//
//  SZYChooseViewController.h
//  iNote
//
//  Created by 孙中原 on 15/10/26.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZYNoteBookModel;
@class SZYNoteModel;

@protocol SZYChooseViewControllerDelegate <NSObject>

@required
-(void)didChooseNoteBook:(SZYNoteBookModel *)noteBookSelected;

@end

@interface SZYChooseViewController : UIViewController

@property (nonatomic, assign) id<SZYChooseViewControllerDelegate> delegate;

- (instancetype)initWithCurrentNote:(SZYNoteModel *)note;

@end
