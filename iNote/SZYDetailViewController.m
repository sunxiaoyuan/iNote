//
//  SZYDetailViewController.m
//  iNote
//
//  Created by 孙中原 on 15/10/21.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import "SZYDetailViewController.h"
#import "SZYToolView.h"
#import "SZYMenuView.h"
#import "SZYDetailNaviView.h"
#import "SZYNoteModel.h"
#import "SZYNoteBookModel.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PZPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SZYChooseViewController.h"
#import "NSDate+TimeStamp.h"
#import "SZYUser.h"
#import "SZYRecorderViewController.h"
#import "SZYPlayerViewController.h"
#import "UIImage+Size.h"
#import "SZYTextView.h"
#import "SZYPhotoChooseView.h"
#import "UITextView+Resize.h"
#import "UIAlertController+SZYKit.h"
#import "SZYMenuButton.h"

#define kLeadingSpacing      SIZ(10)
#define kNoteBookIconWidth   SIZ(80)
#define kNoteBookIconHeight  SIZ(20)
#define kTextAndImageSpacing SIZ(10)
#define kDefaultTitle        @"无标题笔记"
#define kVideoInfoAnimatedDuration 0.2

@interface SZYDetailViewController ()<SZYToolViewDelegate,SZYMenuViewDelegate,SZYCustomNaviViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MJPhotoBrowserDelegate,SZYChooseViewControllerDelegate,UIAlertViewDelegate,SZYRecorderViewControllerDelegate,SZYPhotoChooseViewDelegate>

//导航栏
@property (nonatomic, strong) SZYDetailNaviView *naviView;
//工具栏
@property (nonatomic, strong) SZYToolView       *toolView;
//右上角菜单栏
@property (nonatomic, strong) SZYMenuView       *menuView;
//标题
@property (nonatomic, strong) UITextField       *titleTextField;
//选择笔记本的icon
@property (nonatomic, strong) SZYMenuButton     *noteBookIcon;
//标题下分割线
@property (nonatomic, strong) UIView            *sepLine;
//底层滚动视图
@property (nonatomic, strong) UIScrollView      *bgScrollView;
//文本区域
@property (nonatomic, strong) SZYTextView       *textView;
//图片
@property (nonatomic, strong) UIImageView       *myImageView;
//slider底层图层
@property (nonatomic, strong) UIView            *optionView;
<<<<<<< HEAD

=======


@property (nonatomic, assign) BOOL                    isMenuOpen;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
@property (nonatomic, strong) SZYNoteModel            *currentNote;
@property (nonatomic, assign) BOOL                    isCamera;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UIImage                 *tempImage;//用户选择的图片
@property (nonatomic, strong) SZYPhotoChooseView      *photoChooseView;
@property (nonatomic, strong) NSData                  *videoFile;
@property (nonatomic, strong) MJPhotoBrowser          *browser;
@property (nonatomic, assign) CGRect                  latestTextViewFrame;//记录当前文本区域尺寸
@property (nonatomic, assign) BOOL                    isEditing;//当前页面的状态（编辑／查看）
@property (nonatomic, strong) SZYNoteBookModel        *belongedNoteBook;
@property (nonatomic, assign) BOOL                    isFavorite;
@property (nonatomic, assign) SZYFromType             sourceType;
@property (nonatomic, strong) SZYNoteSolidater        *solidater;
@property (nonatomic, strong) UIButton                *showVideoBtn;
@property (nonatomic, strong) UIView                  *videoInfoView;

@end

@implementation SZYDetailViewController

#pragma mark - life cycle

-(instancetype)initWithNote:(SZYNoteModel *)noteBook AndSourceType:(SZYFromType)type
{
    self = [super init];
    if (self) {
        _currentNote = noteBook;
        _sourceType = type;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
<<<<<<< HEAD
=======
    self.isMenuOpen = NO;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    self.latestTextViewFrame = CGRectZero;
    //加载工具
    self.solidater = (SZYNoteSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteModel class])];
    
    //加载数据源
    [self initData];

    //加载界面组件
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.noteBookIcon];
    [self.view addSubview:self.sepLine];
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.textView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.naviView];
    //一定要最后添加，工具栏位于最上层
    [self.view addSubview:self.toolView];
    
    

}

-(void)initData{

    if (self.sourceType == SZYFromAddType) {  //从首页“＋”按钮跳转过来的，新建笔记
        
        //默认存放在“默认笔记本”“当前用户”下
        self.currentNote = [[SZYNoteModel alloc]initWithNoteBookID:kDEFAULT_NOTEBOOK_ID UserID:ApplicationDelegate.userSession.user_id Title:kDefaultTitle];
        
    }else{  //其他情况，组织界面
        
        self.titleTextField.text = self.currentNote.title;
        self.textView.text = [self.currentNote contentAtLocal];
        [self lazyLoadImageView:[self.currentNote imageAtlocal]];
        //查询所属笔记本信息
        SZYNoteBookSolidater *noteBookSolidater = (SZYNoteBookSolidater *)[SZYSolidaterFactory solidaterFctoryWithType:NSStringFromClass([SZYNoteBookModel class])];
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
            [noteBookSolidater readOneByID:self.currentNote.noteBook_id_belonged successHandler:^(id result) {
                NSString *noteBook_title = [(SZYNoteBookModel *)result title];
                [self.noteBookIcon setTitle:noteBook_title forState:UIControlStateNormal];
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏
    self.naviView.frame = CGRectMake(0, 0, UIScreenWidth, NavigationBarHeight);
    //工具栏
    self.toolView.frame = CGRectMake(0, UIScreenHeight-SIZ(40), UIScreenWidth, SIZ(40));
    //菜单栏
<<<<<<< HEAD
    self.menuView.frame = CGRectMake(UIScreenWidth-SIZ(100), self.naviView.bottom - SIZ(60), SIZ(100), SIZ(60));
=======
    self.menuView.frame = CGRectMake(UIScreenWidth-SIZ(100), 0, SIZ(100), SIZ(60));
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    //标题输入框
    self.titleTextField.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.naviView.frame)+SIZ(5),UIScreenWidth-2*kLeadingSpacing-kNoteBookIconWidth-SIZ(5), SIZ(30));
    //选择笔记本按钮
    self.noteBookIcon.frame = CGRectMake(UIScreenWidth-kLeadingSpacing-kNoteBookIconWidth, CGRectGetMaxY(self.naviView.frame)+SIZ(5)+(SIZ(30)-kNoteBookIconHeight)/2, kNoteBookIconWidth, kNoteBookIconHeight);
    //分割线
    self.sepLine.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.titleTextField.frame)+SIZ(2), UIScreenWidth-2*kLeadingSpacing, SIZ(0.5));
    //底层滚动视图
    CGFloat bgScrollViewH = UIScreenHeight - self.sepLine.bottom - self.toolView.height - SIZ(10);
    self.bgScrollView.frame = CGRectMake(kLeadingSpacing, self.sepLine.bottom+SIZ(5), UIScreenWidth-2*kLeadingSpacing, bgScrollViewH);
    
    if (self.latestTextViewFrame.size.width == 0) { //首次进入这一页，textview初始尺寸
<<<<<<< HEAD
        //给一个初始高度
        self.textView.frame = CGRectMake(-SIZ(2), 0, self.bgScrollView.width+SIZ(4), SIZ(30));
=======
        
        CGFloat textViewH = [self.textView resize].height;
        if (textViewH > 0) {
            self.textView.frame = CGRectMake(-SIZ(2), 0, self.bgScrollView.width+SIZ(4), textViewH);
        }else{
            //给一个初始高度
            self.textView.frame = CGRectMake(-SIZ(2), 0, self.bgScrollView.width+SIZ(4), SIZ(30));
        }
        
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    }else{
        self.textView.frame = self.latestTextViewFrame;
    }
    if (self.myImageView.image) {
        
        CGFloat myImageViewW = self.bgScrollView.width;
        CGFloat myImageViewH = myImageViewW * self.myImageView.image.size.height / self.myImageView.image.size.width;
        self.myImageView.frame = CGRectMake( 0, self.textView.bottom+kTextAndImageSpacing, myImageViewW, myImageViewH);
        
    }
    if ([self.currentNote haveVideo]) [self.view addSubview:self.showVideoBtn];
    
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.myImageView.bottom +SIZ(10));
    
    [self registerNotification];
}

-(void)registerNotification{
    //注册 - 监听
    //TextView文本的变更
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    //标题输入框改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterEditingState)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    //字体变更
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fontDidChanged:)
                                                 name:@"TextViewFontNotification"
                                               object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)dealloc{
    
    //注销 - 监听
    //TextView文本的变更
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"TextViewFontNotification"
                                                  object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    //键盘收起
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 101) { //点击右上角“删除”，质询
        
        if (buttonIndex == 1) {
            //删除
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
                
                [_solidater deleteOneByID:self.currentNote.note_id successHandler:^(id result) {
                    //删除本地文件
                    [self.currentNote deleteContentAtLocal:^(NSError *error) {
                        if (!error) {
                            [self.currentNote deleteImageAtLocal:^(NSError *error) {
                                if (error){
                                    NSLog(@"delete image error = %@",error);
<<<<<<< HEAD
                                }else{
                                    [self.currentNote deleteVideoAtLocalWithDirClear:YES];
=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
                                }
                            }];
                        }else{
                            NSLog(@"delete content error = %@",error);
                        }
                    }];
<<<<<<< HEAD
=======
                    
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"error = %@",errorMsg);
                }];
            }];
            //退回上一页
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 102){ //点击左上角“返回”,质询
        
        if (buttonIndex == 1) {
            //退回上一页
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://照相机
        {
            self.isCamera = YES;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://本地相薄
        {
            self.isCamera = NO;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            [imagePicker.navigationBar setBarTintColor:ThemeColor];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]){
        
        UIImage *imge = [info objectForKey:UIImagePickerControllerOriginalImage];
        //修正方向
        self.tempImage = [UIImage fixOrientation:imge];
        
        if (self.isCamera) {
            
            if (self.tempImage) {
                //懒加载
                [self lazyLoadImageView:self.tempImage];
                //进入编辑状态
                [self enterEditingState];
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            self.imagePickerVC = picker;
            //查看已选择图片的界面
            self.photoChooseView = [[SZYPhotoChooseView alloc]initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, UIScreenHeight) AndImage:self.tempImage];
            self.photoChooseView.tag = 122;
            self.photoChooseView.delegate = self;
            [UIView animateWithDuration:0.3 animations:^{
                self.photoChooseView.transform = CGAffineTransformMakeTranslation(0, -UIScreenHeight);
            }];
            [picker.view addSubview:self.photoChooseView];
        }
  
    }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.videoFile = [NSData dataWithContentsOfFile:videoPath];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

}

#pragma mark - SZYPhotoChooseViewDelegate
-(void)chooseBtnDidClick:(UIButton *)sender{

    if (sender.tag == 100) {  //确定
        if (self.tempImage && self.imagePickerVC) {
            //懒加载
            [self lazyLoadImageView:self.tempImage];
            //进入编辑状态
            [self enterEditingState];
            [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.photoChooseView.transform = CGAffineTransformIdentity;
        [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3];
    }];
}

#pragma mark - MJPhotoBrowserDelegate
- (void)selectImage:(UIImage *)image {
    
    [self.myImageView removeFromSuperview];
    self.tempImage = nil;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.contentSize.height-self.myImageView.height);
    //进入编辑状态
    [self enterEditingState];
    [self.browser disappear];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

<<<<<<< HEAD
=======
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([textField.text isEqualToString:@""]) {
//        textField.text = kDefaultTitle;
//    }
//}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self enterEditingState];
}

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
#pragma mark - SZYDetailNaviViewDelegate

-(void)customNaviViewLeftMenuClick:(UIButton *)sender{
    
    if (self.isEditing) {
        //质询流程
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有完成编辑,返回将导致数据丢失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"执意要走", nil];
        alert.tag = 102;
        [alert show];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)moreBtnDidclick:(UIButton *)sender{

    if (sender.selected) {
        
        [self showMenu:NO];
        
    }else{
        
        [self showMenu:YES];
        
    }
<<<<<<< HEAD
    sender.selected = !sender.selected;
}

-(void)showMenu:(BOOL)isNeedShow{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.menuView.transform = isNeedShow ? CGAffineTransformMakeTranslation(0, SIZ(60)) : CGAffineTransformIdentity;

    }];
=======
    self.isMenuOpen = !self.isMenuOpen;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
}

//完成编辑后，点击右上角“完成”的响应事件
-(void)doneBtnDidClick:(UIButton *)sender{

    //退出编辑模式
    [self exitEditingState];
    
    //整合数据，准备存储
    if (!self.belongedNoteBook) {
        self.currentNote.noteBook_id_belonged = kDEFAULT_NOTEBOOK_ID;//默认放在“默认笔记本下”
    }else{
        self.currentNote.noteBook_id_belonged = self.belongedNoteBook.noteBook_id;
    }
<<<<<<< HEAD
    if ([self.titleTextField.text isEqualToString:@""]) {
        self.currentNote.title = kDefaultTitle;
    }else{
        self.currentNote.title = self.titleTextField.text;
    }
    self.currentNote.mendTime = [NSDate szyTimeStamp];
    [self.currentNote saveImage:self.tempImage];
    [self.currentNote saveContent:self.textView.text];
    self.currentNote.isFavorite = self.isFavorite ? @"YES" : @"NO";
=======
    if ([self.titleTextField.text isEqualToString:@""]) self.titleTextField.text = kDefaultTitle;
    self.currentNote.title = self.titleTextField.text;
    self.currentNote.mendTime = [NSDate szyTimeStamp];
    [self.currentNote saveImage:self.tempImage];
    [self.currentNote saveContent:self.textView.text];
    self.isFavorite ? (self.currentNote.isFavorite = @"YES") : (self.currentNote.isFavorite = @"NO");
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
        
        [_solidater readOneByID:self.currentNote.note_id successHandler:^(id result) {
            if (result) {
                //刷新数据
                [_solidater updateOne:self.currentNote successHandler:^(id result) {
                    //结束编辑状态
                    [self exitEditingState];
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"%@",errorMsg);
                    
                }];
            }else{
                //插入数据
                [_solidater saveOne:self.currentNote successHandler:^(id result) {
                    //结束编辑状态
                    [self exitEditingState];
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"%@",errorMsg);
                    //插入数据数据失败时，将当前的笔记归档存储到草稿箱
                }];
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
}

#pragma mark - SZYMenuViewDelegate

-(void)menuBtnDidClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 101: //点击收藏
        {
<<<<<<< HEAD
            self.currentNote.isFavorite = sender.selected?@"YES":@"NO";
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
                [self.solidater updateOne:self.currentNote successHandler:^(id result) {
                    //收起菜单栏
                    [self showMenu:NO];
=======
            if (self.isFavorite) {
                [sender setTitle:@"收 藏" forState:UIControlStateNormal];
            }else{
                [sender setTitle:@"已收藏" forState:UIControlStateNormal];
            }
            self.isFavorite = !self.isFavorite;
            self.currentNote.isFavorite = self.isFavorite?@"YES":@"NO";
   
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *db) {
                //刷新数据库
                [_solidater updateOne:self.currentNote successHandler:^(id result) {
                    //success
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"%@",errorMsg);
                }];
            }];
<<<<<<< HEAD
            sender.selected = !sender.selected;
=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
        }
            break;
        case 102: //点击删除
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 101;
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SZYToolViewDelegate

-(void)addPictureClick:(UIButton *)sender{
        
    [self.titleTextField resignFirstResponder];
    [self.textView resignFirstResponder];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    
    [actionSheet showInView:self.view];
    
}

-(void)addVideoClick:(UIButton *)sender{
    
    //跳转到录音界面
    SZYRecorderViewController *recordVC = [SZYRecorderViewController createFromStoryboardName:@"Recorder" withIdentifier:@"RecorderIB"];
    recordVC.currentNote = self.currentNote;
    recordVC.delegate = self;
    [self presentViewController:recordVC animated:YES completion:nil];
    
}

-(void)adjustFontClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) { //选中状态

        [self.view addSubview:self.optionView];

    }else{
        
        [self.optionView removeFromSuperview];
        self.optionView = nil;
    }
<<<<<<< HEAD
=======
}
-(void)sliderValueChanged:(UISlider *)slider{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextViewFontNotification" object:@(slider.value)];
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
}

-(void)hideKeyBoardClick{
    [self.textView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

#pragma mark - SZYChooseViewControllerDelegate

//获得选择的笔记本对象
-(void)didChooseNoteBook:(SZYNoteBookModel *)noteBookSelected{
<<<<<<< HEAD
=======
    //在更新当前笔记的noteBook_id之前首先判断，是否需要进入编辑模式
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    if (![self.currentNote.noteBook_id_belonged isEqualToString:noteBookSelected.noteBook_id]) {
        [self enterEditingState];
    }
    //更新当前笔记的noteBook_id
    self.currentNote.noteBook_id_belonged = noteBookSelected.noteBook_id;
    //更新界面
    self.belongedNoteBook = noteBookSelected;
    [self.noteBookIcon setTitle:noteBookSelected.title forState:UIControlStateNormal];
}

#pragma mark - SZYRecorderViewControllerDelegate

-(void)haveCompleteRecordAtTime:(NSString *)time{
    
    if ([self.currentNote haveVideo]) {
        //显示录音按钮
        [self.view addSubview:self.showVideoBtn];
        //进入编辑模式
        [self enterEditingState];
<<<<<<< HEAD
    }
}

#pragma mark - 响应事件

-(void)textDidChanged:(NSNotification *)noti{
    [self enterEditingState];
    [self refreshInterface];
}

-(void)fontDidChanged:(NSNotification *)noti{
    self.textView.font = [UIFont systemFontOfSize:[noti.object floatValue]];
    [self refreshInterface];
}

-(void)refreshInterface{
    //加入动态计算高度
    CGSize size = [self.textView resize];
    CGFloat deltaY = size.height - self.textView.height;
    self.textView.height = size.height;
    //记录最新的尺寸
    self.latestTextViewFrame = self.textView.frame;
    
=======
    }
}

-(void)showVideoBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        //展示录音信息面板
        [self.view insertSubview:self.videoInfoView belowSubview:self.showVideoBtn];
        //从左边移动进入
        [self showVideoInfoPad];
  
    }else{
        //收起面板
        [self hideVideoInfoPad];
    }
}

-(void)showVideoInfoPad{
    
    [UIView animateWithDuration:kVideoInfoAnimatedDuration animations:^{
        self.videoInfoView.transform = CGAffineTransformMakeTranslation(UIScreenWidth, 0);
    }];
}

-(void)hideVideoInfoPad{
    
    [UIView animateWithDuration:kVideoInfoAnimatedDuration animations:^{
        self.videoInfoView.transform = CGAffineTransformIdentity;
    }];
}

-(void)deleteVideo:(UIButton *)btn{
    
    [UIAlertController showAlertAtViewController:self withMessage:@"正在执行删除录音操作，您确定继续执行吗？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action){
        //do nothing
    } confirmHandler:^(UIAlertAction *action){
        //收起面板
        [self hideVideoInfoPad];
        [self.videoInfoView removeFromSuperview];
        self.videoInfoView = nil;
        [self.showVideoBtn removeFromSuperview];
        self.showVideoBtn = nil;
        //清空本地文件
        [self.currentNote deleteVideoAtLocalWithDirClear:YES];
        //进入编辑状态
        [self enterEditingState];
    }];
}

#pragma mark - 响应事件

-(void)textDidChanged:(NSNotification *)noti{
    [self enterEditingState];
    [self refreshInterface];
}

-(void)fontDidChanged:(NSNotification *)noti{
    self.textView.font = [UIFont systemFontOfSize:[noti.object floatValue]];
    [self refreshInterface];
}

-(void)refreshInterface{
    //加入动态计算高度
    CGSize size = [self.textView resize];
    CGFloat deltaY = size.height - self.textView.height;
    self.textView.height = size.height;
    //记录最新的尺寸
    self.latestTextViewFrame = self.textView.frame;
    
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
    //改变下方的图片位置
    self.myImageView.top += deltaY;
    //改变底层滚动视图滚动范围
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.contentSize.height+deltaY);
}

//进入编辑状态
-(void)enterEditingState{
    
    self.isEditing = YES;
    //右上角按钮－－>“完成”
    [self.naviView enterEditingState];
}

//退出编辑模式
-(void)exitEditingState{
    
    self.isEditing = NO;
    //右上角－－>“更多”
    [self.naviView exitEditingState];
    //去除光标
    [self.titleTextField resignFirstResponder];
    [self.textView resignFirstResponder];
}

-(void)chooseNoteBook{
    
    //点击笔记本icon，跳转选择笔记本的界面
    SZYChooseViewController *chooseVC = [[SZYChooseViewController alloc]initWithCurrentNote:self.currentNote];
    chooseVC.delegate = self;
    [self.navigationController pushViewController:chooseVC animated:YES];
}

-(void)keyboardWillShow:(NSNotification *)noti{

    // 根据弹出键盘的rect/弹出时间，对工具栏,选项栏进行位移
    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{

        CGAffineTransform upTransform = CGAffineTransformMakeTranslation(0, -deltaY);
        self.toolView.transform = upTransform;
        [self adaptViewLocation];

    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{

    //工具栏位移,选项栏复位
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.toolView.transform = CGAffineTransformIdentity;
        [self adaptViewLocation];

    }];
<<<<<<< HEAD
}

-(void)adaptViewLocation{
    if (self.optionView) self.optionView.top = self.toolView.top - SIZ(44);
    if (self.showVideoBtn) self.showVideoBtn.top = self.toolView.top - 32;
    if (self.videoInfoView && self.showVideoBtn) self.videoInfoView.top = self.showVideoBtn.top - 8;
}


-(void)lazyLoadImageView:(UIImage *)showImage{
    
    [self.bgScrollView addSubview:self.myImageView];
    self.myImageView.image = showImage;
}

-(void)sliderValueChanged:(UISlider *)slider{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextViewFontNotification" object:@(slider.value)];
=======
}

-(void)adaptViewLocation{
    if (self.optionView) self.optionView.top = self.toolView.top - SIZ(44);
    if (self.showVideoBtn) self.showVideoBtn.top = self.toolView.top - 32;
    if (self.videoInfoView && self.showVideoBtn) self.videoInfoView.top = self.showVideoBtn.top - 8;
}


-(void)lazyLoadImageView:(UIImage *)showImage{
    
    [self.bgScrollView addSubview:self.myImageView];
    self.myImageView.image = showImage;
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
}

- (void)removeView {
    [self.photoChooseView removeFromSuperview];
}

-(void)selectPicture:(UIButton *)sender{
    
    //1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc]init];
    if (self.sourceType == SZYFromAddType) {
        photo.image = self.tempImage;
    }else{
        photo.image = [self.currentNote imageAtlocal];
    }
    [photos addObject:photo];
    
    //2.显示相册
    self.browser = [[MJPhotoBrowser alloc]initWithisZQ:YES ToolBarTitle:@"删除图片"];
    self.browser.photos = photos;
    self.browser.delegate = self;
    [self.browser show];
}

<<<<<<< HEAD
-(void)showVideoBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        //展示录音信息面板
        [self.view insertSubview:self.videoInfoView belowSubview:self.showVideoBtn];
        //从左边移动进入
        [self showVideoInfoPad];
        
    }else{
        //收起面板
        [self hideVideoInfoPad];
    }
}

-(void)showVideoInfoPad{
    
    [UIView animateWithDuration:kVideoInfoAnimatedDuration animations:^{
        self.videoInfoView.transform = CGAffineTransformMakeTranslation(UIScreenWidth, 0);
    }];
}

-(void)hideVideoInfoPad{
    
    [UIView animateWithDuration:kVideoInfoAnimatedDuration animations:^{
        self.videoInfoView.transform = CGAffineTransformIdentity;
    }];
}

-(void)deleteVideo:(UIButton *)btn{
    
    [UIAlertController showAlertAtViewController:self withMessage:@"正在执行删除录音操作，您确定继续执行吗？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action){
        //do nothing
    } confirmHandler:^(UIAlertAction *action){
        //收起面板
        [self hideVideoInfoPad];
        [self.videoInfoView removeFromSuperview];
        self.videoInfoView = nil;
        [self.showVideoBtn removeFromSuperview];
        self.showVideoBtn = nil;
        //清空本地文件
        [self.currentNote deleteVideoAtLocalWithDirClear:YES];
        //进入编辑状态
        [self enterEditingState];
    }];
}

=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(void)jumpToVideoPlayer{

    //模态跳转播放界面
    SZYPlayerViewController *vc = [SZYPlayerViewController createFromStoryboardName:@"Player" withIdentifier:@"playerIB"];
    [vc setLocalAudioFilePath:self.currentNote.video];
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - getters

-(SZYDetailNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYDetailNaviView alloc]init];
        _naviView.delegate = self;
        //如果是新建笔记，则不会显示“更多”
        if(self.sourceType == SZYFromAddType){
            [_naviView removeMoreBtn];
        };
    }
    return _naviView;
}

-(SZYToolView *)toolView{
    if (_toolView == nil){
        _toolView = [[SZYToolView alloc]init];
        _toolView.delegate = self;
    }
    return _toolView;
}

-(SZYMenuView *)menuView{
    if (_sourceType == SZYFromAddType) {
        _menuView = nil;
    }else{
        if (_menuView == nil){
            _menuView = [[SZYMenuView alloc]init];
            _menuView.delegate = self;
        }
    }
    return _menuView;
}

-(UITextField *)titleTextField{
    if (_titleTextField == nil){
        _titleTextField = [[UITextField alloc]init];
        _titleTextField.textColor = [UIColor blackColor];
        _titleTextField.delegate = self;
        _titleTextField.textAlignment = NSTextAlignmentLeft;
        _titleTextField.font = FONT_14;
        _titleTextField.returnKeyType = UIReturnKeyDone;
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //修改placeholder颜色
        _titleTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:kDefaultTitle attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x888888)}];
    }
    return _titleTextField;
}
-(SZYMenuButton *)noteBookIcon{
    if (_noteBookIcon == nil){
        _noteBookIcon = [SZYMenuButton buttonWithType:UIButtonTypeCustom];
        _noteBookIcon.layer.masksToBounds = YES;
        _noteBookIcon.layer.borderWidth = 0.8f;
        _noteBookIcon.layer.borderColor = [ThemeColor CGColor];
        _noteBookIcon.layer.cornerRadius = 10.0f;
        [_noteBookIcon setTitle:@"默认笔记本" forState:UIControlStateNormal];
        _noteBookIcon.titleLabel.font = FONT_13;
        [_noteBookIcon setTitleColor:ThemeColor forState:UIControlStateNormal];
        _noteBookIcon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_noteBookIcon addTarget:self action:@selector(chooseNoteBook) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noteBookIcon;
}
-(UIView *)sepLine{
    if (_sepLine == nil){
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _sepLine;
}
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView){
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}
-(SZYTextView *)textView{
    if (_textView == nil){
        _textView = [[SZYTextView alloc]init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = FONT_16;
        _textView.textColor = [UIColor blackColor];
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
    }
    return _textView;
}
-(UIImageView *)myImageView{
    if (_myImageView == nil){
        _myImageView = [[UIImageView alloc]init];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;//保证图片比例不变
        _myImageView.backgroundColor = [UIColor clearColor];
        _myImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPicture:)];
        [_myImageView addGestureRecognizer:singleTap];
    }
    return _myImageView;
}

-(UIButton *)showVideoBtn{
    if (!_showVideoBtn){
        _showVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = 24;
        CGFloat btnH = 24;
        CGFloat btnMargin = 8;
        CGFloat btnY = UIScreenHeight - self.toolView.height - btnH - btnMargin;
        _showVideoBtn.frame = CGRectMake(btnMargin, btnY, btnW, btnH);
        [_showVideoBtn setBackgroundImage:[UIImage imageNamed:@"home_video"] forState:UIControlStateNormal];
        [_showVideoBtn addTarget:self action:@selector(showVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showVideoBtn;
}

<<<<<<< HEAD
//录音文件信息界面
=======
>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(UIView *)videoInfoView{
    if (!_videoInfoView){
        //底层面板
        _videoInfoView = [[UIView alloc]initWithFrame:CGRectMake(-UIScreenWidth, self.showVideoBtn.top-8, UIScreenWidth, 40)];
        _videoInfoView.backgroundColor = [UIColor whiteColor];
        _videoInfoView.layer.borderWidth = 0.5;
        _videoInfoView.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
        //录音时间
        UIButton *timeBtn = [[UIButton alloc]initWithFrame:CGRectMake((UIScreenWidth-150)/2, 0, 150, 40)];
        [timeBtn setTitle:@"点击播放录音" forState:UIControlStateNormal];
        [timeBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        timeBtn.titleLabel.font = FONT_13;
        timeBtn.backgroundColor = [UIColor clearColor];
        [timeBtn addTarget:self action:@selector(jumpToVideoPlayer) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView addSubview:timeBtn];
        //删除按钮
        UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(_videoInfoView.width-40, 0, 40, 40)];
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleBtn.backgroundColor = ThemeColor;
        [deleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleBtn.titleLabel.font = FONT_13;
        [deleBtn addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView addSubview:deleBtn];
    }
    return _videoInfoView;
}
<<<<<<< HEAD
//调节字体面板
=======

>>>>>>> f7cbcbc74662aa001615a19c2b8048029e0fbb61
-(UIView *)optionView{
    if (!_optionView){
        _optionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.toolView.top - SIZ(44), UIScreenWidth, SIZ(44))];
        _optionView.backgroundColor = [UIColor whiteColor];
        _optionView.layer.borderWidth = 0.5;
        _optionView.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
        UISlider *fontSlider = [[UISlider alloc]initWithFrame:CGRectMake(SIZ(5), SIZ(5), _optionView.width-SIZ(10), _optionView.height-SIZ(10))];
        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"detail_font"] imageByScalingToSize:CGSizeMake(SIZ(10), SIZ(10))];
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"detail_font"] imageByScalingToSize:CGSizeMake(SIZ(15), SIZ(15))];
        [fontSlider setMinimumValueImage:stetchLeftTrack];
        [fontSlider setMaximumValueImage:stetchRightTrack];
        fontSlider.minimumValue = 13;
        fontSlider.maximumValue = 19;
        fontSlider.value = 16;
        [fontSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //设置只有在离开滑动条的最后时刻才触发滑动事件
        fontSlider.continuous = NO;
        [_optionView addSubview:fontSlider];
    }
    return _optionView;
}

@end
