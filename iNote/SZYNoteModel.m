//
//  SZYNoteModel.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYNoteModel.h"
#import "MJExtension.h"


@implementation SZYNoteModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    SZYNoteModel *noteModel = [SZYNoteModel objectWithKeyValues:dict];
    return noteModel;
}


+(id)modalWithID{
    
    SZYNoteModel *note = [[SZYNoteModel alloc]init];
    note.note_id = [NSString RandomString];
    return note;
    
}

#pragma mark - 本地资源写入方法
-(void)saveImage:(UIImage *)image IsFake:(BOOL)isFake{
    
    if (image) {
        
        self.image = [[SZYLocalFileManager sharedInstance] saveNoteImage:image NoteID:self.note_id IsFake:isFake];
    }
}

-(void)saveContent:(NSString *)content IsFake:(BOOL)isFake{
    
    if (content) {
        
        self.content = [[SZYLocalFileManager sharedInstance] saveNoteContent:content NoteID:self.note_id isFake:isFake];
    }
}

-(NSString *)videoPath{
    
    self.video = [[SZYLocalFileManager sharedInstance] noteVideoPathWithNoteID:self.note_id];
    return self.video;

}

#pragma mark - 读取本地资源方法

-(NSString *)contentAtLocal{
    
    return [[SZYLocalFileManager sharedInstance] contentFileAtPath:self.content];
    
}

-(UIImage *)imageAtlocal{
    
    return [[SZYLocalFileManager sharedInstance] imageFileAtPath:self.image];
}



@end
