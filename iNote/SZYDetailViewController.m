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
#import "NSString+Random.h"
#import "NSDate+TimeStamp.h"
#import "SZYUser.h"
#import "SZYRecorderViewController.h"
#import "SZYPlayerViewController.h"
#import "UIImage+Size.h"

#define kLeadingSpacing SIZ(15)
#define kNoteBookIconWidth SIZ(80)
#define kNoteBookIconHeight SIZ(20)
#define kTextAndImageSpacing SIZ(10)

@interface SZYDetailViewController ()<SZYToolViewDelegate,SZYMenuViewDelegate,SZYDetailNaviViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MJPhotoBrowserDelegate,SZYChooseViewControllerDelegate,UIAlertViewDelegate,SZYRecorderViewControllerDelegate>

//导航栏
@property (nonatomic, strong) SZYDetailNaviView *naviView;
//工具栏
@property (nonatomic, strong) SZYToolView       *toolView;
//右上角菜单栏
@property (nonatomic, strong) SZYMenuView       *menuView;
//标题
@property (nonatomic, strong) UITextField       *titleTextField;
//选择笔记本的icon
@property (nonatomic, strong) UIButton          *noteBookIcon;
//标题下分割线
@property (nonatomic, strong) UIView            *sepLine;
//文本区域
@property (nonatomic, strong) UITextView        *textView;
//图片
@property (nonatomic, strong) UIImageView       *myImageView;
//图片上的覆盖按钮
@property (nonatomic, strong) UIButton          *myImageBtn;


@property (nonatomic, assign) BOOL                    isMenuOpen;
@property (nonatomic, strong) SZYCommonToolClass      *commTool;
@property (nonatomic, assign) BOOL                    isKeyBoardSow;
@property (nonatomic, assign) CGFloat                 keyBoardHeight;
@property (nonatomic, strong) SZYNoteModel            *currentNote;
@property (nonatomic, assign) BOOL                    isCamera;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UIImage                 *tempImage;
@property (nonatomic, strong) UIImage                 *finalImage;
@property (nonatomic, strong) UIView                  *tempView;
@property (nonatomic, strong) NSData                  *videoFile;
@property (nonatomic, strong) MJPhotoBrowser          *browser;
@property (nonatomic, strong) NSString                *defaultTitle;
@property (nonatomic, assign) CGRect                  latestTextViewFrame;

@property (nonatomic, assign) BOOL                    isEditing;//当前页面的状态（编辑／查看）
@property (nonatomic, strong) SZYNoteBookModel        *belongedNoteBook;
@property (nonatomic, assign) NSInteger               belongedNoteBookRow;
@property (nonatomic, strong) SZYNoteModel            *currentNoteBook;
@property (nonatomic, assign) BOOL                    isFavorite;
@property (nonatomic, assign) BOOL                    haveVideo;//限制录音次数
@property (nonatomic, strong) NSString                *videoPath;
@property (nonatomic, assign) SZYFromType             sourceType;
@property (nonatomic, strong) SZYNoteLocalManager     *noteLM;


@end

@implementation SZYDetailViewController

#pragma mark - life cycle

-(instancetype)initWithNote:(SZYNoteModel *)noteBook AndSourceType:(SZYFromType)type
{
    self = [super init];
    if (self) {
        self.currentNote = noteBook;
        self.sourceType = type;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //加载数据源
    [self initData];

    
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.noteBookIcon];
    [self.view addSubview:self.sepLine];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.myImageView];
    [self.view addSubview:self.myImageBtn];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.naviView];
    //一定要最后添加，工具栏位于最上层
    [self.view addSubview:self.toolView];

}

-(void)initData{
    
    self.commTool = [[SZYCommonToolClass alloc]init];
    self.isKeyBoardSow = NO;
    self.isMenuOpen = NO;
    self.isEditing = YES;
    self.defaultTitle = @"无标题笔记";
    self.latestTextViewFrame = CGRectZero;
    self.belongedNoteBookRow = 0;
    self.noteLM = (SZYNoteLocalManager *)[SZYLocalManagerFactory managerFactoryWithType:kNoteType];
    self.noteLM.solidater = [SZYSolidaterFactory solidaterFctoryWithType:kNoteType];
    
    if (self.sourceType == SZYFromAddType) {  //从首页“＋”按钮跳转过来的
        
        self.currentNote = [SZYNoteModel modalWithID];
        //默认设置存放在“默认笔记本”中
        self.currentNote.noteBook_id_belonged = kDEFAULT_NOTEBOOK_ID;
        self.currentNote.user_id_belonged = ApplicationDelegate.userSession.user_id;
        self.currentNote.title = self.defaultTitle;
        
        //控件数据源
        self.titleTextField.text = self.currentNote.title;
        
    }else{  //其他情况
        
        self.titleTextField.text = self.currentNote.title;
        self.textView.text = [self.currentNote contentAtLocal];
        self.myImageView.image = [self.currentNote imageAtlocal];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏
    self.naviView.frame = CGRectMake(0, 0, UIScreenWidth, NavigationBarHeight);
    //工具栏
    self.toolView.frame = CGRectMake(0, UIScreenHeight-SIZ(44), UIScreenWidth, SIZ(44));
    //菜单栏
    self.menuView.frame = CGRectMake(UIScreenWidth-SIZ(100), 0, SIZ(100), SIZ(60));
    
    self.titleTextField.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.naviView.frame)+SIZ(5),UIScreenWidth-2*kLeadingSpacing-kNoteBookIconWidth-SIZ(5), SIZ(30));
    
    self.noteBookIcon.frame = CGRectMake(UIScreenWidth-kLeadingSpacing-kNoteBookIconWidth, CGRectGetMaxY(self.naviView.frame)+SIZ(5)+(SIZ(30)-kNoteBookIconHeight)/2, kNoteBookIconWidth, kNoteBookIconHeight);
    
    self.sepLine.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.titleTextField.frame)+SIZ(2), UIScreenWidth-2*kLeadingSpacing, SIZ(0.5));
    
    if (self.latestTextViewFrame.size.width == 0) { //首次进入这一页，textview初始尺寸
        self.textView.frame = CGRectMake(kLeadingSpacing, self.sepLine.bottom+SIZ(5), UIScreenWidth-2*kLeadingSpacing, SIZ(30));
    }else{
        self.textView.frame = self.latestTextViewFrame;
    }
    
    self.myImageView.frame = CGRectMake(kLeadingSpacing, self.textView.bottom+kTextAndImageSpacing, UIScreenWidth-2*kLeadingSpacing, SIZ(160));
    self.myImageBtn.frame = self.myImageView.frame;
    
    
    
    //注册 - 监听
    //TextView文本的变更
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
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
            //删除操作
            [self.noteLM deleteModelById:self.currentNote.note_id];
            
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
        UIImage *fixedImage = [self.commTool fixOrientation:imge];
        
        if (self.isCamera) {
            
            //虚业务
            [self.currentNote saveImage:fixedImage IsFake:YES];
            self.finalImage = fixedImage;
            //展示(注意此时的位置)
            self.myImageView.image = [fixedImage imageByScalingToSize:CGSizeMake(self.myImageView.frame.size.width, self.myImageView.frame.size.height)];
            self.myImageBtn.enabled = YES;
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            self.imagePickerVC = picker;
            self.tempImage = fixedImage;
            if (self.tempView == nil) {
                
                self.tempView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, UIScreenHeight)];
                self.tempView.backgroundColor = UIColorFromRGB(0xc333333);
                PZPhotoView *imageView = [[PZPhotoView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SIZ(44))];
                imageView.tag = 22;
                [imageView displayImage:imge];
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tempView.frame.size.height - SIZ(44), UIScreenWidth, SIZ(44))];
                bottomView.backgroundColor = ThemeColor;
                //确定按钮
                UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                enterButton.tag = 100;
                enterButton.frame = CGRectMake(UIScreenWidth - SIZ(50), 0, SIZ(50), SIZ(44));
                [enterButton setTitle:@"确定" forState:UIControlStateNormal];
                [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [enterButton addTarget:self action:@selector(selectImageclick:) forControlEvents:UIControlEventTouchUpInside];
                //取消按钮
                UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                cancelButton.tag = 101;
                cancelButton.frame = CGRectMake(0, 0, SIZ(50), SIZ(44));
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cancelButton addTarget:self action:@selector(selectImageclick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.tempView addSubview:imageView];
                [self.tempView addSubview:bottomView];
                [bottomView addSubview:enterButton];
                [bottomView addSubview:cancelButton];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.tempView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
                }];
            }else{
                UIView *view = [self.tempView viewWithTag:22];
                if ([view isKindOfClass:[PZPhotoView class]]) {
                    PZPhotoView *image = (PZPhotoView *)view;
                    [image displayImage:imge];
                }
                [UIView animateWithDuration:0.3 animations:^{
                    self.tempView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
                }];
            }
            [picker.view addSubview:self.tempView];
        }
  
    }else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.videoFile = [NSData dataWithContentsOfFile:videoPath];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

}


#pragma mark - MJPhotoBrowserDelegate
- (void)selectImage:(UIImage *)image {
    
    self.myImageView.image = nil;
    self.finalImage = nil;
    self.myImageBtn.enabled = NO;
    [self.browser disappear];
    
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:self.defaultTitle]) {
        textField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        textField.text = self.defaultTitle;
    }
}


#pragma mark - UITextViewDelegate

-(void)textDidChanged:(NSNotification *)noti{
    //加入动态计算高度
    CGSize size = [self.commTool getStringRectInTextView:self.textView.text InTextView:self.textView];
    CGFloat deltaY = size.height - self.textView.height;
    self.textView.height = size.height;
    self.latestTextViewFrame = self.textView.frame;
    
    //改变下方的图片位置
    self.myImageView.top += deltaY;
    //图片上的按钮
    self.myImageBtn.top += deltaY;
}

#pragma mark - SZYDetailNaviViewDelegate

-(void)backBtnDidClick{
    
    if (self.isEditing) {
        //质询流程
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有完成编辑,返回将导致数据丢失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"执意要走", nil];
        alert.tag = 102;
        [alert show];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(void)moreBtnDidclick{

    if (self.isMenuOpen) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.frame = CGRectMake(UIScreenWidth-SIZ(100), 0, SIZ(100), SIZ(60));
            
        } completion:^(BOOL finished) {
            self.menuView.hidden = YES;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.frame = CGRectMake(UIScreenWidth-SIZ(100), NavigationBarHeight, SIZ(100), SIZ(60));
            self.menuView.hidden = NO;
        }];
        
    }
    self.isMenuOpen = !self.isMenuOpen;
 
}

//完成编辑后，点击右上角“完成”的响应事件
-(void)doneBtnDidClick{

    //退出编辑模式
    [self exitEditingState];
    
    //整合数据，准备存储
    if (!self.belongedNoteBook) {
        self.currentNote.noteBook_id_belonged = kDEFAULT_NOTEBOOK_ID;
    }else{
        self.currentNote.noteBook_id_belonged = self.belongedNoteBook.noteBook_id;
    }
    self.currentNote.title = self.titleTextField.text;
    self.currentNote.mendTime = [NSDate szyTimeStamp];
    [self.currentNote saveImage:self.finalImage IsFake:NO];
    [self.currentNote saveContent:self.textView.text IsFake:NO];
    self.isFavorite ? (self.currentNote.isFavorite = @"YES") : (self.currentNote.isFavorite = @"NO");
    //存入数据库

    if ([self.noteLM modelById:self.currentNote.note_id]) {
        //刷新数据
        [self.noteLM updateModelById:self.currentNote.note_id WithData:self.currentNote];
    }else{
        //插入数据
        [self.noteLM save:self.currentNote];
    }
}

#pragma mark - SZYMenuViewDelegate

-(void)menuBtnDidClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 101: //点击收藏
        {
            if (self.isFavorite) {
                [sender setTitle:@"收 藏" forState:UIControlStateNormal];
            }else{
                [sender setTitle:@"已收藏" forState:UIControlStateNormal];
            }
            self.isFavorite = !self.isFavorite;
            self.currentNote.isFavorite = self.isFavorite?@"YES":@"NO";
   
            //刷新数据库
            [self.noteLM updateModelById:self.currentNote.note_id WithData:self.currentNote];
        }
            break;
        case 102: //点击删除
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除笔记将导致数据丢失，您确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 101;
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SZYToolViewDelegate

-(void)addPictureClick{
    
    [self enterEditingState];
    
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

-(void)addVideoClick{
    
    [self enterEditingState];
    //跳转到录音界面
    SZYRecorderViewController *recordVC = [SZYRecorderViewController createFromStoryboardName:@"Recorder" withIdentifier:@"RecorderIB"];
    recordVC.currentNote = self.currentNote;
    recordVC.delegate = self;
    [self presentViewController:recordVC animated:YES completion:nil];
    
}

-(void)adjustFontClick{
    
    [self enterEditingState];
    
}

-(void)hideKeyBoardClick{
    [self.textView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

#pragma mark - SZYChooseViewControllerDelegate

//获得选择的笔记本对象
-(void)didChooseNoteBook:(SZYNoteBookModel *)noteBookSelected AtRow:(NSInteger)row{
    
    self.belongedNoteBook = noteBookSelected;
    self.belongedNoteBookRow = row;
}

#pragma mark - SZYRecorderViewControllerDelegate

-(void)haveCompleteRecord:(NSString *)path{
    
    if (path && ![path isEqualToString:@""]) {
        
        self.haveVideo = YES;
        self.videoPath = path;
        //展示录音播放按钮
        UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.myImageBtn.enabled) {//有图片
            videoBtn.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.myImageView.frame)+SIZ(10), SIZ(150), SIZ(50));
        }else{
            //没图片
            videoBtn.frame = CGRectMake(kLeadingSpacing, CGRectGetMaxY(self.textView.frame)+SIZ(10), SIZ(150), SIZ(50));
        }
        videoBtn.layer.cornerRadius = 8.0;
        videoBtn.layer.masksToBounds = YES;
        [videoBtn setTitle:@"video" forState:UIControlStateNormal];
        [videoBtn setBackgroundColor:UIColorFromRGB(0x888888)];
        [videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:videoBtn];
        
    }else{
        
        self.haveVideo = NO;
    }
}

#pragma mark - 触屏事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textView becomeFirstResponder];
    
}

//进入编辑状态
-(void)enterEditingState{
    
    self.isEditing = YES;
    //右上角按钮－－>“完成”
    self.naviView.doneBtn.hidden = NO;
    self.naviView.doneBtn.enabled = YES;
    
    self.naviView.moreBtn.hidden = YES;
    self.naviView.moreBtn.enabled = NO;
}

//退出编辑模式
-(void)exitEditingState{
    
    self.isEditing = NO;
    //右上角－－>“更多”
    self.naviView.moreBtn.hidden = NO;
    self.naviView.moreBtn.enabled = YES;
    self.naviView.doneBtn.hidden = YES;
    self.naviView.doneBtn.enabled = NO;
    //去除光标
    [self.titleTextField resignFirstResponder];
    [self.textView resignFirstResponder];
}

#pragma mark - 响应事件

-(void)chooseNoteBook{
    
    //点击笔记本icon，跳转选择笔记本的界面
    SZYChooseViewController *chooseVC = [[SZYChooseViewController alloc]initWithSelectedRow:self.belongedNoteBookRow];
    chooseVC.delegate = self;
    [self.navigationController pushViewController:chooseVC animated:YES];
    
}

-(void)keyboardWillShow:(NSNotification *)noti{

    // 根据弹出键盘的rect/弹出时间，对工具栏进行位移
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.toolView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
        
    }];
    
    //进入编辑模式
    [self enterEditingState];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    //工具栏位移复位
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.toolView.transform=CGAffineTransformIdentity;
    }];
    
}

-(void)selectImageclick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {  //确定
        if (self.tempImage && self.imagePickerVC) {
            
            //虚保存
            [self.currentNote saveImage:self.tempImage IsFake:YES];
            self.finalImage = self.tempImage;
            //刷新界面
            self.myImageView.image = [self.tempImage imageByScalingToSize:CGSizeMake(self.myImageView.frame.size.width, self.myImageView.frame.size.height)];
            self.myImageBtn.enabled = YES;
            [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.tempView.frame = CGRectMake(0, UIScreenHeight, self.tempView.frame.size.width, self.tempView.frame.size.height);
                [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3];
            }];
        }
    } else {  //取消
        [UIView animateWithDuration:0.2 animations:^{
            self.tempView.frame = CGRectMake(0, UIScreenHeight, self.tempView.frame.size.width, self.tempView.frame.size.height);
            [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3];
        }];
    }
}

- (void)removeView {
    [self.tempView removeFromSuperview];
}

-(void)selectPicture:(UIButton *)sender{
    
    //1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
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

-(void)playVideo{

    //模态跳转播放界面
    SZYPlayerViewController *vc = [SZYPlayerViewController createFromStoryboardName:@"Player" withIdentifier:@"playerIB"];
    vc.videoPath = self.videoPath;
    [self presentViewController:vc animated:YES completion:nil];

}


#pragma mark - getters

-(SZYDetailNaviView *)naviView{
    if (_naviView == nil){
        _naviView = [[SZYDetailNaviView alloc]init];
        _naviView.delegate = self;
        //如果是新建笔记，则不会显示“更多”
        if(self.sourceType == SZYFromAddType){
            [_naviView.moreBtn removeFromSuperview];
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
    if (_menuView == nil){
        _menuView = [[SZYMenuView alloc]init];
        _menuView.delegate = self;
        _menuView.hidden = YES;
    }
    return _menuView;
}

-(UITextField *)titleTextField{
    if (_titleTextField == nil){
        _titleTextField = [[UITextField alloc]init];
        _titleTextField.textColor = UIColorFromRGB(0x888888);
        _titleTextField.delegate = self;
        _titleTextField.textAlignment = NSTextAlignmentLeft;
        _titleTextField.font = FONT_14;
        _titleTextField.returnKeyType = UIReturnKeyDone;
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _titleTextField;
}
-(UIButton *)noteBookIcon{
    if (_noteBookIcon == nil){
        _noteBookIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noteBookIcon setTitle:@"默认笔记本" forState:UIControlStateNormal];
        _noteBookIcon.titleLabel.font = FONT_14;
        [_noteBookIcon setTitleColor:ThemeColor forState:UIControlStateNormal];
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
-(UITextView *)textView{
    if (_textView == nil){
        _textView = [[UITextView alloc]init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = FONT_14;
        _textView.textColor = UIColorFromRGB(0x888888);
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
    }
    return _myImageView;
}

-(UIButton *)myImageBtn{
    if (_myImageBtn == nil){
        _myImageBtn = [[UIButton alloc]init];
        _myImageBtn.backgroundColor = [UIColor clearColor];
        [_myImageBtn addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchUpInside];
        _myImageBtn.enabled = self.myImageView.image;
    }
    return _myImageBtn;
}

@end
