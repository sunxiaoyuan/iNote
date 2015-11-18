//
//  SZYRecorderViewController.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/4.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZYNoteModel;

@protocol SZYRecorderViewControllerDelegate <NSObject>

-(void)haveCompleteRecord:(NSString *)path;

@end

@interface SZYRecorderViewController : UIViewController

@property (nonatomic, assign) id<SZYRecorderViewControllerDelegate> delegate;
@property (nonatomic, strong) SZYNoteModel *currentNote;

@end
