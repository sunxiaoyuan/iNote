//
//  SZYNoteModel.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteModel.h"
#import "FMResultSet.h"

@implementation SZYNoteModel


#pragma mark - 重写父类方法
+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    SZYNoteModel *noteModel = [SZYNoteModel objectWithKeyValues:dict];
    return noteModel;
}

#pragma mark - 子类扩展的初始化方法
- (instancetype)initWithNoteBookID:(NSString *)noteBook_id_belonged UserID:(NSString *)user_id_belonged Title:(NSString *)title
{
    self = [super init];
    if (self) {
        _note_id = [NSString stringOfUUID];
        _noteBook_id_belonged = noteBook_id_belonged;
        _user_id_belonged = user_id_belonged;
        _title = title;
    }
    return self;
}

#pragma mark - 本地资源写入方法
-(void)saveImage:(UIImage *)image {
    
    if (image) {
        [[SZYLocalFileManager sharedInstance] saveFile:image fileName:[NSString stringWithFormat:@"%@-%@.jpg",_note_id,kNoteImageFileSuffix] withType:kNoteImageFolderType successHandler:^(NSString *filePath) {
            self.image = filePath;
        } failureHandler:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        //当传递nil参数时，说明需要清除笔记图片，属性＋本地资源文件
        [self deleteImageAtLocal:^(NSError *error) {
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
        }];
        self.image = nil;
    }
}

-(void)saveContent:(NSString *)content {
    
    if (content) {
        [[SZYLocalFileManager sharedInstance] saveFile:content fileName:[NSString stringWithFormat:@"%@-%@.txt",_note_id,kNoteContentFileSuffix] withType:kNoteContentFolderType successHandler:^(NSString *filePath) {
            self.content = filePath;
        } failureHandler:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

-(NSString *)videoPath{
    
    NSString *videoFileName = [NSString stringWithFormat:@"%@-%@.caf",_note_id,kNoteVideoFileSuffix];
   self.video = [[[SZYLocalFileManager sharedInstance] setUpLocalFileDir:kNoteVideoFolderType] stringByAppendingPathComponent:videoFileName];
    return self.video;
}

#pragma mark - 读取本地资源方法

-(NSString *)contentAtLocal{
    
    return [[SZYLocalFileManager sharedInstance] contentFileAtPath:self.content];
    
}

-(UIImage *)imageAtlocal{
    
    UIImage *image = [[SZYLocalFileManager sharedInstance] imageFileAtPath:self.image];
    return image;
}

-(void)deleteVideoAtLocalWithDirClear:(BOOL)isDirClear{
    
    [[SZYLocalFileManager sharedInstance] deleteFileWithPath:self.video completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    if (isDirClear) {
        self.video = nil;
    }
}

-(void)deleteContentAtLocal:(completedHandler)handler{
    [[SZYLocalFileManager sharedInstance] deleteFileWithPath:self.content completionHandler:^(NSError *error) {
        handler(error);
    }];
}

-(void)deleteImageAtLocal:(completedHandler)handler{
    [[SZYLocalFileManager sharedInstance] deleteFileWithPath:self.image completionHandler:^(NSError *error) {
        handler(error);
    }];
}

-(BOOL)haveVideo{
    return (self.video && ![self.video isEqualToString:@""]);
}


@end
