//
//  SZYPhotoScrollView.m
//  iNote
//
//  Created by 孙中原 on 15/10/16.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYPhotoScrollView.h"

@interface SZYPhotoScrollView ()

@property (nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation SZYPhotoScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoArray  = [[NSMutableArray alloc]init];
        
        self.addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addPhotoBtn setImage:[UIImage imageNamed:@"personal_add_default.png"] forState:UIControlStateNormal];
        [self.addPhotoBtn addTarget:self action:@selector(addPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addPhotoBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat h = self.frame.size.height;
    self.addPhotoBtn.frame = CGRectMake(SIZ(10), (h-SIZ(60))/2, SIZ(70), SIZ(60));
  
}

-(NSMutableArray *)setPhoto:(NSMutableArray *)photoList{
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:self.addPhotoBtn];
    if (self.photoArray != nil) {
        [self.photoArray removeAllObjects];
    }
    for (int i = 0; i < [photoList count]; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn addTarget:self action:@selector(selectThisImage:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat h = self.frame.size.height;
        UIImageView *imageView;
        if (self.addPhotoBtn.hidden) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIZ(10)+i * (SIZ(70)), (h-SIZ(60))/2, SIZ(60), SIZ(60))];
        }else{
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIZ(80) + i * (SIZ(70)), (h-SIZ(60))/2, SIZ(60), SIZ(60))];
        }
        imageView.image = photoList[i];
        [self.photoArray addObject:imageView];
        [imageView.layer setCornerRadius:3];
        imageView.layer.masksToBounds = YES;
        btn.frame = imageView.frame;
        
        [self addSubview:imageView];
        [self addSubview:btn];
    }
    self.contentSize = CGSizeMake(SIZ(11) + photoList.count * SIZ(82) + SIZ(82) , 0);
    return self.photoArray;
}

#pragma mark - 通知代理
-(void)addPhotoClick:(UIButton *)sender{
    [self.aDelegate addPhotoBtnDidClick:sender];
}

-(void)selectThisImage:(UIButton *)sender{
    [self.aDelegate selectPhotoDidClick:sender];
}


@end
