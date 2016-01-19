//
//  SZYTextView.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/30.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYTextView.h"


#define kCursorVelocity 1.0f/8.0f

@interface SZYTextView ()
@property (nonatomic, strong) UIPanGestureRecognizer *singleFingerPanRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *doubleFingerPanRecognizer;
@property (nonatomic, assign) NSRange startRange;
@end

@implementation SZYTextView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _singleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleFingerPanHappend:)];
        _singleFingerPanRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:_singleFingerPanRecognizer];
        
        _doubleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doubleFingerPanHappend:)];
        _doubleFingerPanRecognizer.minimumNumberOfTouches = 2;
        [self addGestureRecognizer:_doubleFingerPanRecognizer];
    }
    return self;
}

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer*)gestureRecognizer{
    
    [self.singleFingerPanRecognizer requireGestureRecognizerToFail:gestureRecognizer];
    [self.doubleFingerPanRecognizer requireGestureRecognizerToFail:gestureRecognizer];
}

- (void)singleFingerPanHappend:(UIPanGestureRecognizer*)sender{
    //检测到手势开始，获取光标初始位置
    if (sender.state == UIGestureRecognizerStateBegan) self.startRange = self.selectedRange;
    //根据手势确定新光标位置
    CGFloat cursorLocation = MAX(self.startRange.location + (NSInteger)([sender translationInView:self].x * kCursorVelocity), 0);
    NSRange selectedRange = {cursorLocation, 0};
    self.selectedRange = selectedRange;
}

- (void)doubleFingerPanHappend:(UIPanGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) self.startRange = self.selectedRange;
    CGFloat cursorLocation = MAX(self.startRange.location + (NSInteger)([sender translationInView:self].x*kCursorVelocity), 0);
    //光标起始位置
    CGFloat startLocation = (cursorLocation > self.startRange.location) ? self.startRange.location : cursorLocation;
    NSRange selectedRange  = NSMakeRange(startLocation, fabs(self.startRange.location - cursorLocation));
    self.selectedRange = selectedRange;
}

@end
