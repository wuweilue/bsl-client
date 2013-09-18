//
//  XMPPTalkViewController.m
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import "XMPPTalkViewController.h"
#import "Base64.h"
#import "SVProgressHUD.h"
#import "AudioView.h"
//#import "Config.h"
#import "JSONKit.h"
#import "XMPPShowImageViewController.h"
#import "MySelfView.h"
//气泡的背景图片
#define kBallonImageViewTag 100
//显示消息内容的label
#define kChatContentLabelTag 101
//显示日期的label
#define kDateLabelTag 102
//显示消息正在发送的view的tag
#define kLoadingViewTag 103


#define BEGIN_FLAG @"[/:"
#define END_FLAG @"]"

#define inputFromeFroDefault  CGRectMake(75, 7, 165.5,30)
#define inputCentorForDefault CGRectMake(0, 372, 320,44)

#define inputCentorI5ForDefault CGRectMake(0, 373, 320,44)

#define tableIphone CGRectMake(0, 0, 320,375)
#define tableIphone5 CGRectMake(0, 0, 320,465)

#define tablePad CGRectMake(0, 0, 514, 650)
#define inputCentorPad CGRectMake(0, 367, 512, 50)


#define SEND_IMAGE_ACTION @"sendImageAction"
#define IMAGE_DOWNLOAD_READY @"imageDownloadReady"
#define IMAGE_DOWNLOAD_FAILED @"imageDownloadFailed"
enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;


@interface XMPPTalkViewController (){
    NSURL* urlVoiceFile;
    int recordEncoding;
    UIButton* selectBtn;
    AudioView *audioView;
    NSTimer *timer;
}
@end

@implementation XMPPTalkViewController
@synthesize chatWithUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    fetchController.delegate = nil;
    fetchController = nil;
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }
    UIImageView* imageViewOld = (UIImageView* )[selectBtn viewWithTag:selectBtn.tag+1];
    [imageViewOld stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled  = YES;
    
    
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        self.messageTableView.frame = tablePad;
        
        if (!self.inputContent) {
            self.inputContent  = [[UIImageView alloc]init];
            [self.view addSubview:self.inputContent];
        }
        self.inputContent.frame = inputCentorPad;
        
    }else if (iPhone5){
        self.messageTableView.frame = tableIphone5;
    }else{
        self.messageTableView.frame=tableIphone;
    }
    
    
    recordEncoding = ENC_AAC;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotionResource" ofType:@"plist"];
    dictionary = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    messageArray = [[NSMutableArray alloc]init];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置输入框 发送按钮
    _inputContent.userInteractionEnabled = YES;
    
    [self initTextSendView];
    
    if (iPhone5) {
        _inputContent.frame = inputCentorI5ForDefault;
    }
    
    [_inputContent addSubview:textSendView];
    
    //监测键盘位置的变化，让输入框显示在键盘上面
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendImage:) name:SEND_IMAGE_ACTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshTableView) name:IMAGE_DOWNLOAD_READY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageFailed) name:IMAGE_DOWNLOAD_FAILED object:nil];
    //当前登陆用户的jid
    NSString *selfUserName = [[[[ShareAppDelegate xmpp]xmppStream] myJID]bare];
    //取出当前用户的entity
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sendUser=%@ and receiver = %@) or (sendUser=%@ and receiver = %@)",selfUserName,chatWithUser,chatWithUser,selfUserName];
    NSFetchRequest *fetechRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageEntity"];
    [fetechRequest setPredicate:predicate];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"sendDate" ascending:YES];
    [fetechRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    //viewController之间互相传递数据的方法之一
    fetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetechRequest
                                                         managedObjectContext:appDelegate.xmpp.managedObjectContext
                                                           sectionNameKeyPath:nil cacheName:nil];
    fetchController.delegate = self;
    [fetchController performFetch:NULL];
    //把消息都保存在messageArray中
    NSArray *contentArray = [fetchController fetchedObjects];
    messageArray = [[NSMutableArray alloc]initWithArray:contentArray];
    [_messageTableView reloadData];
    //设置contentOffset才能完整显示最后一条消息,scrollToRect,scrollToIndexPath都不行
    
    if ([messageArray count] >0) {
        [_messageTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [messageArray count] - 1 inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
  
}

-(void)sendImage:(NSNotification*)notification
{
    NSString *fileId = notification.object;
    [self sendMessage:fileId type:@"image"];
    if(!fetchController)
    {
        //当前登陆用户的jid
        NSString *selfUserName = [[[[ShareAppDelegate xmpp]xmppStream] myJID]bare];
        //取出当前用户的entity
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sendUser=%@ and receiver = %@) or (sendUser=%@ and receiver = %@)",selfUserName,chatWithUser,chatWithUser,selfUserName];
        NSFetchRequest *fetechRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageEntity"];
        [fetechRequest setPredicate:predicate];
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"sendDate" ascending:YES];
        [fetechRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
        
        fetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetechRequest
                                                             managedObjectContext:appDelegate.xmpp.managedObjectContext
                                                               sectionNameKeyPath:nil cacheName:nil];
        fetchController.delegate = self;
        [fetchController performFetch:NULL];
        //把消息都保存在messageArray中
        NSArray *contentArray = [fetchController fetchedObjects];
        messageArray = [[NSMutableArray alloc]initWithArray:contentArray];
        [_messageTableView reloadData];
        NSIndexPath  *index;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            index = [NSIndexPath indexPathForItem:(messageArray.count -1) inSection:0];
        }
        else
        {
            index = [NSIndexPath indexPathForRow:messageArray.count -1 inSection:0];
        }
        //        NSIndexPath *index = [NSIndexPath indexPathForItem:messageArray.count -1 inSection:0];
        [_messageTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    else{
        NSArray *contentArray = [fetchController fetchedObjects];
        messageArray = [[NSMutableArray alloc]initWithArray:contentArray];
        [_messageTableView reloadData];
        
    }
}

-(void)freshTableView
{
    [self.messageTableView reloadData];
}
-(void)showImageFailed
{
    //    self.downloadflag = true;
    //    [self.messageTableView reloadData];
}

-(void)initTextSendView{
    
    textSendView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _inputContent.frame.size.width, _inputContent.frame.size.height)];
    
    inputView = [[UIExpandingTextView alloc]initWithFrame:inputFromeFroDefault];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        inputView.frame = CGRectMake(75, 7, 360,30);
    }
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      
    inputView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [inputView.internalTextView setReturnKeyType:UIReturnKeySend];
    inputView.maximumNumberOfLines=5;
    
    [textSendView addSubview:inputView];
    inputView.font = [UIFont systemFontOfSize:16];
    
    inputView.layer.cornerRadius = 4;
    inputView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    inputView.layer.borderWidth = 1;
    inputView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(_inputContent.frame.size.width-70, 5, 59, 33);
    [sendButton addTarget:self
                   action:@selector(sendButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [sendButton setImage:[UIImage imageNamed:@"send2.png"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"send1.png"] forState:UIControlStateHighlighted];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ((BOOL)[defaults objectForKey:@"offLineSwitch"]) {
        sendButton.enabled = NO;
    }
    textSendView.backgroundColor = [UIColor clearColor];
    [textSendView addSubview:sendButton];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame = CGRectMake(7.5, 7.5, 32, 32);
    plusButton.backgroundColor = [UIColor clearColor];
    [plusButton setImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(showImageSendView:) forControlEvents:UIControlEventTouchUpInside];
    [textSendView addSubview:plusButton];
    
    
    UIButton *dissmissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dissmissButton.frame = CGRectMake(40, 7.5, 31, 31);
    //    [dissmissButton setBackgroundImage:nil forState:UIControlStateNormal];
    dissmissButton.backgroundColor = [UIColor clearColor];
    [dissmissButton setImage:[UIImage imageNamed:@"voicebtn.png"] forState:UIControlStateNormal];
    [dissmissButton addTarget:self action:@selector(changeSendView) forControlEvents:UIControlEventTouchUpInside];
    [textSendView addSubview:dissmissButton];
    
    
    
}

-(void)showImageSendView:(id)sender
{
    [self changeTextSend];
    [inputView resignFirstResponder];
    if(self.showFlag)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [inputView resignFirstResponder];
                             [[self.view viewWithTag:2013] setHidden:YES];
                             [[self.view viewWithTag:2014] removeFromSuperview];
                             
                             CGRect newframe = _inputContent.frame;
                             newframe.origin.y = self.view.frame.size.height - _inputContent.frame.size.height;
                             _inputContent.frame = newframe;
                             CGRect frame  = self.messageTableView.frame;
                             frame.size.height = frame.size.height+90;
                             self.messageTableView.frame = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? frame : tablePad ;
                             if ([messageArray count] >0) {
                                 [_messageTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [messageArray count] - 1 inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                             }
                             
                         }completion:^(BOOL finish){
                             self.showFlag = NO;
                             
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [inputView resignFirstResponder];
                             CGRect inputframe = _inputContent.frame;
                             inputframe.origin.y = self.view.frame.size.height - 100 - _inputContent.frame.size.height;
                             _inputContent.frame = inputframe;
                             CGRect frame  = self.messageTableView.frame;
                             frame.size.height -=  90;
                             self.messageTableView.frame = frame;
                             if ([messageArray count] >0) {
                                 [_messageTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [messageArray count] - 1 inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                             }
                             
                         }completion:^(BOOL finish){
                             self.showFlag = YES;
                             
                             if([self.view viewWithTag:2013])
                             {
                                 if([self.view viewWithTag:2013].isHidden)
                                 {
                                     [[self.view viewWithTag:2013] setHidden:NO];
                                 }
                                 
                             }
                             else
                             {
                                 UIView *pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
                                 [self.view addSubview:pictureView];
                                 pictureView.tag = 2013;
                                 UIImageView *emotionView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
                                 //                                 UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
                                 //                                 UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(155, 10, 60, 60)];
                                 [emotionView setImage:[UIImage imageNamed:@"emotions_big.png"]];
                                 
                                 //                                 [photoView setImage:[UIImage imageNamed:@"photo_icon_big.png"]];
                                 //                                 [picView setImage:[UIImage imageNamed:@"local_pic_big.png"]];
                                 [pictureView addSubview:emotionView];
                                 //                                 [pictureView addSubview:photoView];
                                 //                                 [pictureView addSubview:picView];
                                 [emotionView setUserInteractionEnabled:YES];
                                 //                                 [photoView setUserInteractionEnabled:YES];
                                 //                                 [picView setUserInteractionEnabled:YES];
                                 UITapGestureRecognizer *emotionGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEmotionView)];
                                 [emotionView addGestureRecognizer:emotionGesture];
                                 
                                 //                                 UITapGestureRecognizer *photoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoView)];
                                 //                                 [photoView addGestureRecognizer:photoGesture];
                                 //
                                 //                                 UITapGestureRecognizer *picGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPictureView)];
                                 //                                 [picView addGestureRecognizer:picGesture];
                                 //                                 [photoView release];
                                 //                                 [picView release];
                                 //
                             }
                             
                             
                         }];
    }
    
}

-(void) showEmotionView
{
   [inputView resignFirstResponder]; 
    count = 1;
    int number = dictionary.count;
    if(number % 29 == 0)
    {
        count = number/29;
    }
    else
    {
        count = number /29  + 1;
    }
    
    UIView *emotionsView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 90)];
    emotionsView.backgroundColor = [UIColor whiteColor];
    emotionsView.tag = 2014;
    [self.view addSubview:emotionsView];
    swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    swipeView.alignment = SwipeViewAlignmentCenter;
    swipeView.pagingEnabled = YES;
    swipeView.wrapEnabled = NO;
    swipeView.itemsPerPage = 1;
    swipeView.truncateFinalPage = YES;
    swipeView.delegate = self;
    swipeView.dataSource = self;
    
    pager = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 10)];
    pager.backgroundColor= [UIColor grayColor];
    [pager setNumberOfPages:count];
    [pager setCurrentPage:0];
    [emotionsView addSubview:pager];
    [emotionsView addSubview:swipeView];
}


#pragma mark - SwipeView Delegate

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    for (int j= 0;j<3;j++)
    {
        for(int i=0;i<10;i++)
        {
            MySelfView *pView = [[MySelfView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
            int tag = index * 29 + 10*j +i;
            NSString *name = [NSString stringWithFormat:@"%d",tag];
            if(name.length == 1)
            {
                name = [NSString stringWithFormat:@"f00%@",name ];
            }
            else if(name.length == 2)
            {
                name = [NSString stringWithFormat:@"f0%@",name ];
            }
            else{
                name = [NSString stringWithFormat:@"f%@",name ];
            }
            //            NSLog(@"%@--------------------%d",name,tag);
            [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]]];
            [pView setFileName:name];
            CGRect frame = pView.frame;
            if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
                frame.origin.x = 52*i;
                
            }else{
                frame.origin.x = 32*i;
            }
            frame.origin.y = 30*j;
            pView.frame = frame;
            pView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEmotion:)];
            
            if(10*j +i == 29)
            {
                [imageview setImage:[UIImage imageNamed:@"del_icon_dafeult.png"]];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteEmotion)];
                [pView addGestureRecognizer:tapGesture];
            }
            else
            {
                [pView addGestureRecognizer:tapGesture];
            }
            [pView addSubview:imageview];
            [myView addSubview:pView];
        }
    }
    return myView;
}

-(void)deleteEmotion
{
    NSString *text = inputView.text;
    
    if(text.length >0)
    {
        inputView.text = [text substringWithRange:NSMakeRange(0, text.length -1)];
    }
}

-(void)showEmotion:(id)sender
{
    NSLog(@"%@",sender);
    UITapGestureRecognizer *gs = (UITapGestureRecognizer*)sender;
    MySelfView *view  = (MySelfView*)gs.view;
    //    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:view.fileName]];
    NSString *text = inputView.text;
    inputView.text = [text stringByAppendingString:[NSString stringWithFormat:@"[/:%@]",[dictionary valueForKey:view.fileName] ]];
    
}

-(void)swipeViewDidScroll:(SwipeView *)swipeView
{
    
}
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipe
{
    [pager setCurrentPage:swipe.currentItemIndex];
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected item at index %i", index);
}

-(void)showPhotoView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问相机出错"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)showPictureView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage* img = image;
    [self performSelectorOnMainThread:@selector(uploadImageToServer:) withObject:img  waitUntilDone:NO];
    //    [self uploadImageToServer:img];
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)uploadImageToServer:(UIImage*)image
{
    //把图片转换成imageDate格式
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //传送路径
    NSString *urlString = kFileUploadUrl;
    NSURL *requestURL = [NSURL URLWithString:urlString];
    FormDataRequest * request = [FormDataRequest requestWithURL:requestURL];
    request.delegate = self;
    [request setDidFailSelector:@selector(fileUploadFailed:)];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dict setObject:imageData forKey:@"file"];
    [request setUserInfo:dict];
    [request setDidFinishSelector:@selector(fileUploadFinished:)];
    [request setData:imageData forKey:@"file"];
    [request startSynchronous];
    
}
-(void)fileUploadFinished:(id)request
{
    NSString *resultStr = [request responseString];
    NSData *imageData = [[request userInfo] valueForKey:@"file"];
    NSDictionary *dict = [resultStr objectFromJSONString];
    NSString *fileId = [dict valueForKey:@"id"];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"sendFiles"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:path])
    {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:fileId];
    [imageData writeToFile:path atomically:YES];
    self.filePath = path;
    [[NSNotificationCenter defaultCenter] postNotificationName:SEND_IMAGE_ACTION object:fileId];
    
}
-(void)fileUploadFailed:(id)request
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"图片发送失败"
                          message:@""
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


-(void)changeSendView{
 [inputView resignFirstResponder];
    if (!voiceSendView) {
        [self initVoiceSendView];
        [_inputContent addSubview:voiceSendView];
        textSendView.hidden = YES;
    }else{
        voiceSendView.hidden = NO;
        textSendView.hidden = YES;
    }
}

-(void)initVoiceSendView{
    voiceSendView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _inputContent.frame.size.width, _inputContent.frame.size.height)];
    
    //添加按钮  发送语音文件
    UIButton *dissmissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ((BOOL)[defaults objectForKey:@"offLineSwitch"]) {
        dissmissButton.enabled = NO;
    }
    dissmissButton.frame = CGRectMake(75, 7.5, 532/2 - 30, 30);
    
    [dissmissButton setImage:[UIImage imageNamed:@"voiceSend.png"] forState:UIControlStateNormal];
    [dissmissButton setImage:[UIImage imageNamed:@"voiceSend_select.png"] forState:UIControlStateHighlighted];
    [dissmissButton addTarget:self
                       action:@selector(dismissButtonClick)
             forControlEvents:UIControlEventTouchUpInside];
    //当按下语音按钮时 开始录音
    [dissmissButton addTarget:self
                       action:@selector(dismissButtonTouchDown)
             forControlEvents:UIControlEventTouchDown];
    //如果点击按钮取消  则删除文件 不发送录音
    [dissmissButton addTarget:self
                       action:@selector(dismissButtonTouchCancle)
             forControlEvents:UIControlEventTouchUpOutside];
    
    [voiceSendView addSubview:dissmissButton];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(7.5, 7.5, 30, 30);
    plusBtn.backgroundColor = [UIColor clearColor];
    [plusBtn setImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(showImageSendView:) forControlEvents:UIControlEventTouchUpInside];
    [voiceSendView addSubview:plusBtn];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(40, 7.5, 30, 30);
    changeBtn.backgroundColor = [UIColor clearColor];
    [changeBtn setImage:[UIImage imageNamed:@"textBtn.png"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeTextSend) forControlEvents:UIControlEventTouchUpInside];
    [voiceSendView addSubview:changeBtn];
}

-(void)changeTextSend{
    if (!textSendView) {
        [self initTextSendView];
        [_inputContent addSubview:textSendView];
        voiceSendView.hidden = YES;
    }else{
        voiceSendView.hidden = YES;
        textSendView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    scoket = nil;
    fetchController = nil;
    [self setMessageTableView:nil];
    [self setInputContent:nil];
    textSendView = nil;
    voiceSendView = nil;
    [super viewDidUnload];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messageArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [inputView resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算聊天内容需要的高度
    CGFloat rowHeight = 0;
    id messageObject = [messageArray objectAtIndex:indexPath.row];
    //因为messageArray有日期和MessageEntity两种对象
    if ([messageObject isKindOfClass:[MessageEntity class]]) {
        MessageEntity *messageEntity = (MessageEntity*)messageObject;
        if ([messageEntity.type isEqualToString:@"voice"]) {
            rowHeight = 60;
        }else if([messageEntity.type isEqualToString:@"image"]){
            rowHeight = 150;
        }else{
            CGSize contentSize =  [messageEntity.content sizeWithFont:[UIFont systemFontOfSize:14]
                                                    constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)];
            rowHeight = contentSize.height+50;
        }
    }else if ([messageObject isKindOfClass:[NSDate class]]) {
        //用于显示日期的label
        rowHeight = 0;
    }
    return rowHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    //右边的cell，显示自己发送的消息
    id messageObject = [messageArray objectAtIndex:indexPath.row];
    //判断数组中的是否messageEntity，因为还有可能是时间
    if ([messageObject isKindOfClass:[MessageEntity class]]) {
        //判断消息应该显示在左边还是右边
        MessageEntity *messageEntity = (MessageEntity*)messageObject;
        //取出这条消息的发送者的jid，和当前用户的jid进行比较，判断是否一致
        //NSLog(@"sender:%@,self:%@",messageEntity.sender.name,selfEntity.name);
        if ([messageEntity.sendUser isEqualToString:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare]]) {
            //要显示在右边
            //NSLog(@"content:%@,sender:%@",messageEntity.content,messageEntity.sender.name);
            UITableViewCell *rightCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"rightCell"];
            if (rightCell != nil) {
                rightCell = nil;
            }
            
            if (rightCell==nil) {
                rightCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"rightCell"];
                //高度定制的cell，通常都不能默认的方式选中
                rightCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ([messageEntity.type isEqualToString:@"voice"]) {
                UIButton* btn = [[UIButton alloc]initWithFrame: CGRectMake(self.view.frame.size.width-145, 5, 80, 35)];
                [btn setBackgroundImage:[[UIImage imageNamed:@"ChatBubbleGreen"]resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11,18, 24) ] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didTapButton:)   forControlEvents:UIControlEventTouchUpInside];
                btn.tag = indexPath.row;
                
                UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_record_m_3"]];
                imageView.animationImages =[NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"chat_record_m_1.png"],
                                            [UIImage imageNamed:@"chat_record_m_2.png"],
                                            [UIImage imageNamed:@"chat_record_m_3.png"],nil];
                imageView.animationDuration = 0.5;//设置动画时间
                imageView.animationRepeatCount = 0;
                imageView.tag = indexPath.row+1;
                imageView.frame = CGRectMake(47, 5,15, 19);
                [btn addSubview:imageView];
                
                [rightCell addSubview:btn];
                
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(self.view.frame.size.width-55, 10, 45, 45);
                [rightCell addSubview:user];
                
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-210,30, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [rightCell addSubview:timeTextView];
                
            }else if([messageEntity.type isEqualToString:@"image"]){
                
                //设置可拉伸的区域,通常不可拉伸的区域是圆角，尖角
                UIImage *ballonImageRight = [[UIImage imageNamed:@"ChatBubbleGreen"]resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11,18, 24)];
                //ballon的frame会随消息内容而变化,所以在初始化的过程中设置frame没有意义
                
                UIImageView *ballonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-145, 0,118, 125)];
                ballonImageView.image = ballonImageRight;
                //                ballonImageView.tag = kBallonImageViewTag;
                [rightCell addSubview:ballonImageView];
                
                UIImageView* sendView = [[UIImageView alloc]initWithFrame: CGRectMake(145, 7, 100, 100)];
                [sendView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGersture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
                [sendView addGestureRecognizer:tapGersture];
                [sendView setImage:[UIImage imageNamed:@"pic_bg_02.png" ]];
                [rightCell addSubview:sendView];
                [sendView setUserInteractionEnabled:YES];
                sendView.tag = indexPath.row;
                [self performSelectorInBackground:@selector(loadImage:) withObject:sendView];
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(self.view.frame.size.width-55, 60, 45, 45);
                [rightCell addSubview:user];
                
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(110,115, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [rightCell addSubview:timeTextView];
                
            } else{
                //设置可拉伸的区域,通常不可拉伸的区域是圆角，尖角
                UIImage *ballonImageRight = [[UIImage imageNamed:@"ChatBubbleGreen"]resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11,18, 24)];
                //ballon的frame会随消息内容而变化,所以在初始化的过程中设置frame没有意义
                
                UIImageView *ballonImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
                ballonImageView.image = ballonImageRight;
                ballonImageView.tag = kBallonImageViewTag;
                [rightCell.contentView addSubview:ballonImageView];
                
                NSString *content = messageEntity.content;
                //计算消息显示需要的frame
                //靠右显示，最大宽度200,如果不够200,靠右显示,如果超过200，换行
                CGSize contentSize =  [messageEntity.content sizeWithFont:[UIFont systemFontOfSize:14]
                                                        constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)];
                //contentLabel的frame比气泡小
                CGRect contentFrame =CGRectMake(self.view.frame.size.width-contentSize.width-80, 7, contentSize.width+10, contentSize.height+10);
                
                if([content rangeOfString:BEGIN_FLAG].location != NSNotFound && [content rangeOfString:END_FLAG].location !=NSNotFound)
                {
                    //分割线－－－－－－－图文混排－－－－－－－－－－－－begin
                    ///////////////////////////////////////////////////////////////////////////////
                    UIView *subView = [self assembleMessageAtIndex:content from:YES];
                    CGRect subFrame = subView.frame;
                    subFrame.origin.x = self.view.frame.size.width - 13- subView.frame.size.width - 80;
                    subFrame.origin.y = 7;
                    subView.frame = subFrame;
                    [rightCell addSubview:subView];
                    
                    CGRect ballonFrame1 = CGRectMake(self.view.frame.size.width -20 -subFrame.size.width-80, 5, subFrame.size.width + 35, contentSize.height+20);
                    ballonImageView.frame = ballonFrame1;
                    
                    /////////////////////////////////////////////////////////////////////////////////
                    // 分割线－－－－－－－－图文混排－－－－－－－－－－－end
                    
                }
                else
                {
                    //显示消息内容的label
                    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    contentLabel.font = [UIFont systemFontOfSize:14];
                    contentLabel.textAlignment = UITextAlignmentCenter;
                    contentLabel.numberOfLines = NSIntegerMax;
                    contentLabel.tag = kChatContentLabelTag;
                    [rightCell.contentView addSubview:contentLabel];
                    
                    //气泡比显示的文字大
                    //直接使用contentSize做frame的size，上边留5像素空白
                    CGRect ballonFrame = CGRectMake(self.view.frame.size.width -20-contentSize.width-65, 5, contentSize.width+25, contentSize.height+20);
                    ballonImageView.frame = ballonFrame;
                    
                    contentLabel.frame = contentFrame;
                    contentLabel.text = messageEntity.content;
                    
                }
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(self.view.frame.size.width-55, contentSize.height, 45, 45);
                [rightCell addSubview:user];
                //添加消息时间
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-210, contentSize.height+15, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [rightCell addSubview:timeTextView];
            }
            cell = rightCell;
        }
        else{
            //别人发的消息，显示在左边
            UITableViewCell *leftCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"leftCell"];
            if (leftCell != nil) {
                leftCell = nil;
            }
            if (leftCell==nil) {
                leftCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"leftCell"];
                //高度定制的cell，通常都不能默认的方式选中
                leftCell.selectionStyle = UITableViewCellSelectionStyleNone;
                //设置不可拉伸的区域,通常不可拉伸的区域是圆角，尖角
                //因为图片的尖角在左边，所以左边的不可拉伸区域大一些
                UIImage *ballonImageRight = [[UIImage imageNamed:@"ChatBubbleGray"]resizableImageWithCapInsets:UIEdgeInsetsMake(11,19, 21, 18)];
                //ballon的frame会随消息内容而变化,所以在初始化的过程中设置frame没有意义
                
                UIImageView *ballonImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
                ballonImageView.image = ballonImageRight;
                ballonImageView.tag = kBallonImageViewTag;
                [leftCell.contentView addSubview:ballonImageView];
                //显示消息内容的label
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                contentLabel.backgroundColor = [UIColor clearColor];
                contentLabel.font = [UIFont systemFontOfSize:14];
                contentLabel.textAlignment = UITextAlignmentCenter;
                contentLabel.numberOfLines = NSIntegerMax;
                contentLabel.tag = kChatContentLabelTag;
                [leftCell.contentView addSubview:contentLabel];
            }
            UIImageView *ballonImageView = (UIImageView*)[leftCell.contentView viewWithTag:kBallonImageViewTag];
            
            if ([messageEntity.type isEqualToString:@"voice"]) {
                UIButton* btn = [[UIButton alloc]initWithFrame: CGRectMake(75, 5, 80, 35)];
                [btn setBackgroundImage:[[UIImage imageNamed:@"ChatBubbleGray"]resizableImageWithCapInsets:UIEdgeInsetsMake( 11,19, 21, 18)] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didTapButton:)   forControlEvents:UIControlEventTouchUpInside];
                
                btn.tag = indexPath.row;
                [leftCell addSubview:btn];
                
                UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_record_f_3"]];
                imageView.frame = CGRectMake(14, 5,15, 19);
                imageView.animationImages =[NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"chat_record_f_1.png"],
                                            [UIImage imageNamed:@"chat_record_f_2.png"],
                                            [UIImage imageNamed:@"chat_record_f_3.png"],nil];
                imageView.tag =indexPath.row+1;
                imageView.animationDuration = 0.5;//设置动画时间
                imageView.animationRepeatCount = 0;
                [btn addSubview:imageView];
                
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(15, 10, 45, 45);
                [leftCell addSubview:user];
                
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(95, 30, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [leftCell addSubview:timeTextView];
            }else if ([messageEntity.type isEqualToString:@"image"]) {
                
                UIImageView* recView = [[UIImageView alloc]initWithFrame: CGRectMake(75, 0, 118, 125)];
                [recView setImage:[[UIImage imageNamed:@"ChatBubbleGray"]resizableImageWithCapInsets:UIEdgeInsetsMake( 11,19, 21, 18)]];
                [leftCell addSubview:recView];
                
                
                UIImageView* sendView = [[UIImageView alloc]initWithFrame: CGRectMake(83, 8, 100, 100)];
                [sendView setImage:[UIImage imageNamed:@"pic_bg_02.png" ]];
                [leftCell addSubview:sendView];
                [sendView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGersture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
                [sendView addGestureRecognizer:tapGersture];
                
                sendView.tag = indexPath.row;
                [self performSelectorInBackground:@selector(loadImage:) withObject:sendView];
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(15, 60, 45, 45);
                [leftCell addSubview:user];
                
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(95, 115, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [leftCell addSubview:timeTextView];
                
            }else{
                //计算消息显示需要的frame
                //靠右显示，最大宽度200,如果不够200,靠右显示,如果超过200，换行
                CGSize contentSize =  [messageEntity.content sizeWithFont:[UIFont systemFontOfSize:14]
                                                        constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)];
                //气泡比显示的文字大
                //直接使用contentSize做frame的size，上边留5像素空白
                CGRect ballonFrame = CGRectMake(75, 5, contentSize.width+25, contentSize.height+20);
                ballonImageView.frame = ballonFrame;
                if([messageEntity.content rangeOfString:BEGIN_FLAG].location != NSNotFound && [messageEntity.content rangeOfString:END_FLAG].location !=NSNotFound)
                {
                    //分割线－－－－－－－图文混排－－－－－－－－－－－－begin
                    ///////////////////////////////////////////////////////////////////////////////
                    UIView *subView = [self assembleMessageAtIndex:messageEntity.content from:YES];
                    CGRect subFrame = subView.frame;
                    subFrame.origin.x = 75;
                    subFrame.origin.y = 7;
                    subView.frame = subFrame;
                    [leftCell.contentView addSubview:subView];
                    //                    NSLog(@"---------%.f",subFrame.size.width);
                    CGRect ballonFrame1 = CGRectMake(65, 5, subFrame.size.width+ 35, contentSize.height+20);
                    ballonImageView.frame = ballonFrame1;
                    
                    /////////////////////////////////////////////////////////////////////////////////
                    // 分割线－－－－－－－－图文混排－－－－－－－－－－－end
                }
                else
                {
                    UILabel *contentLabel = (UILabel*)[leftCell.contentView viewWithTag:kChatContentLabelTag];
                    //contentLabel的frame比气泡小
                    CGRect contentFrame = CGRectMake(13+75, 7, contentSize.width, contentSize.height+5);
                    contentLabel.frame = contentFrame;
                    contentLabel.text = messageEntity.content;
                    
                }
                
                UIImageView* user = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_user"]];
                user.frame = CGRectMake(15, contentSize.height, 45, 45);
                [leftCell addSubview:user];
                
                UILabel* timeTextView = [[UILabel alloc]initWithFrame:CGRectMake(95, contentSize.height+15, 150, 20)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeTextView.text =[dateFormatter stringFromDate: messageEntity.sendDate];
                timeTextView.textColor = [UIColor lightGrayColor];
                timeTextView.backgroundColor = [UIColor clearColor];
                timeTextView.font = [UIFont systemFontOfSize:13];
                [leftCell addSubview:timeTextView];
            }
            cell = leftCell;
        }
    }else if ([messageObject isKindOfClass:[NSDate class]]) {
        //用于显示日期的label
        UITableViewCell *dateCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"dateCell"];
        if (dateCell==nil) {
            dateCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"dateCell"];
            dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //居中显示发送日期
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 160, 20)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.font = [UIFont systemFontOfSize:14];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.textAlignment = UITextAlignmentCenter;
            dateLabel.tag = kDateLabelTag;
            [dateCell.contentView addSubview:dateLabel];
        }
        UILabel *dateLabel = (UILabel*)[dateCell.contentView viewWithTag:kDateLabelTag];
        NSDate *messageSendDate = (NSDate*)messageObject;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateLabel.text = [dateFormatter stringFromDate:messageSendDate];
        cell = dateCell;
    }
    //避免cell为空,比直接在每个分支中返回cell要安全
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"cell"];
    }
    return cell;
    
}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}




#define KFacialSizeWidth  20
#define KFacialSizeHeight 20
#define MAX_WIDTH 180
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 3;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 200;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *imageName=[str substringWithRange:NSMakeRange(3, str.length - 4)];
                int index = [[dictionary allValues] indexOfObject:imageName];
                if([[dictionary allValues] indexOfObject:imageName] ==NSNotFound)
                {
                    for (int j = 0; j < [imageName length]; j++) {
                        NSString *temp = [imageName substringWithRange:NSMakeRange(j, 1)];
                        NSLog(@"str(str)---->%@",str);
                        NSLog(@"str(trm)---->%@",temp);
                        if (upX >= MAX_WIDTH)
                        {
                            upY = upY + KFacialSizeHeight;
                            upX = 0;
                            X = MAX_WIDTH;
                            Y =upY;
                        }
                        CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(200,CGFLOAT_MAX)];
                        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                        la.font = fon;
                        la.text = temp;
                        la.lineBreakMode = UILineBreakModeWordWrap;
                        la.textAlignment = UITextAlignmentCenter;
                        la.numberOfLines=0;
                        la.backgroundColor = [UIColor clearColor];
                        [returnView addSubview:la];
                        upX=upX+size.width;
                        if (X<MAX_WIDTH) {
                            X = upX;
                        }
                        else
                        {
                            X = MAX_WIDTH;
                        }
                        
                    }
                }
                else
                {
                    NSString * fileName = [[dictionary allKeys] objectAtIndex:index];
                    
                    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",fileName]]];
                    img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                    [returnView addSubview:img];
                    upX=KFacialSizeWidth+upX;
                    if (X<150) X = upX;
                }
                
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    NSLog(@"str(str)---->%@",str);
                    NSLog(@"str(trm)---->%@",temp);
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(200,CGFLOAT_MAX)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.lineBreakMode = UILineBreakModeWordWrap;
                    la.textAlignment = UITextAlignmentCenter;
                    la.numberOfLines=0;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<MAX_WIDTH) {
                        X = upX;
                    }
                    else
                    {
                        X = MAX_WIDTH;
                    }
                    
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}



-(void)showBigImage:(UITapGestureRecognizer*)gesture
{
    UIImageView *imageView = (UIImageView*)gesture.view;
    int index = imageView.tag;
    MessageEntity *entity = [messageArray objectAtIndex:index];
    NSString *path = entity.content;
    UIImage *image  = [UIImage imageWithContentsOfFile:path];
    XMPPShowImageViewController *controller = [[XMPPShowImageViewController alloc]initWithNibName:@"XMPPShowImageViewController" bundle:nil];
    controller.image = image;
    [self.navigationController pushViewController:controller animated:YES];
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


-(void)loadImage:(UIImageView *)imageView
{
    int tag = imageView.tag;
    MessageEntity *message = [messageArray objectAtIndex:tag];
    NSString* path = message.content;
    if(!message.content)
    {
        NSString *url = [kFileDownloadUrl stringByAppendingString:message.fileId];
         HTTPRequest *request = [HTTPRequest requestWithURL:[NSURL URLWithString:url ]];
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"receiveFiles"];
        NSFileManager *manager = [NSFileManager defaultManager];
        if(![manager fileExistsAtPath:path])
        {
            [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        path = [path stringByAppendingPathComponent:message.fileId];
        NSMutableDictionary *dictonary = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dictonary setObject:message forKey:@"message"];
        [dictonary setObject:imageView forKey:@"view"];
        [request setDownloadDestinationPath:path];
        [request setDelegate:self];
        [request setUserInfo:dictonary];
        [request setDidFinishSelector:@selector(requestFileDidFinished:)];
        [request setDidFailSelector:@selector(requestFileDidFailed:)];
        [request startAsynchronous];
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if(image)
        {
            [imageView setImage:image];
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:@"pic_bg_03.png"]];
        }
    }
    
}

-(void)requestFileDidFinished:(HTTPRequest*)request
{
    NSString *path = [request downloadDestinationPath];
    NSDictionary *dict = [request userInfo];
    MessageEntity *entity = [dict valueForKey:@"message"];
    UIImageView *imageView = [dict valueForKey:@"view"];
    entity.content = path;
    [entity didChangeValueForKey:@"content"];
    UIImage *image = [UIImage imageNamed:path];
    [imageView setImage:image];
    
}

-(void)requestFileDidFailed:(HTTPRequest*)request
{
    NSError *error = [request error];
    if(error)
    {
        NSDictionary *dict = [request userInfo];
        UIImageView *imageView = [dict valueForKey:@"view"];
        [imageView setImage:[UIImage imageNamed:@"pic_bg_03.png"]];
        
    }
}

- (void)didTapButton:(UIButton *)sender{
    UIButton* btn = sender;
    UIImageView* imageView = (UIImageView* )[btn viewWithTag:btn.tag+1];
    
    // 1. 之前选中的btn 跟当前选中btn 先判断之前选择红btn
    // 2.
    if (selectBtn) {
        
        [imageView stopAnimating];
        [imageView startAnimating];
    }
    
    if (selectBtn == sender) {
        [imageView stopAnimating];
        [imageView startAnimating];
    }else{
        UIImageView* imageViewOld = (UIImageView* )[selectBtn viewWithTag:selectBtn.tag+1];
        if(imageViewOld){
            [imageViewOld stopAnimating];
            [imageView startAnimating];
        }
    }
    
    selectBtn = sender;
    id messageObject = [messageArray objectAtIndex:sender.tag];
    if ([messageObject isKindOfClass:[MessageEntity class]]) {
        MessageEntity *messageEntity = (MessageEntity*)messageObject;
        if ([messageEntity.type isEqualToString:@"voice"]) {
            [self playAudio:[NSURL URLWithString:messageEntity.content]   sendid:sender];
        }
    }
}



#pragma mark chat
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    if ([anObject isKindOfClass:[MessageEntity class]]&&type==NSFetchedResultsChangeInsert) {
        MessageEntity *messageEntity = (MessageEntity*)anObject;
        NSIndexPath *dateIndexPath = nil;
        
        [messageArray addObject:anObject];
        
        //[DataTable reloadData];
        //在最后一行添加聊天内容
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:messageArray.count-1 inSection:0];
        //bottom代表动画从下到上
        NSMutableArray *indexPathArray = [NSMutableArray array];
        if (dateIndexPath!=nil) {
            [indexPathArray addObject:dateIndexPath];
        }
        [indexPathArray addObject:insertIndexPath];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        UserInfo* userInfo = [appDelegate.xmpp fetchUserFromJid:messageEntity.sendUser];
        if(userInfo!= nil){
            userInfo.userLastMessage = @"";
            userInfo.userMessageCount = @"0";
            [appDelegate.xmpp saveContext];
        }
        [self.messageTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.messageTableView scrollToRowAtIndexPath:insertIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else if (type==NSFetchedResultsChangeUpdate) {
        //fetchResultsController的indexPath不是DataTable的indexPath,因为messageArray中有日期
        NSIndexPath *messageIndexPath = [NSIndexPath indexPathForRow:[messageArray indexOfObject:anObject] inSection:0];
        [self.messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:messageIndexPath]
                                     withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if(messageArray.count > 0)
    {
        NSIndexPath  *indexpath;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            indexpath = [NSIndexPath indexPathForItem:(messageArray.count -1) inSection:0];
        }
        else
        {
            indexpath = [NSIndexPath indexPathForRow:messageArray.count -1 inSection:0];
        }
        
        [self.messageTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
}

#pragma mark keybord
// Prepare to resize for keyboard.
- (void)keyboardWillShow:(NSNotification *)notification
{
    //NSLog(@"keyboardWillShow");
 	NSDictionary *userInfo = [notification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    //NSLog(@"keyboardEndFrame:%@",NSStringFromCGRect(keyboardEndFrame));
    
    
    //重新设置inputContainer高度，让输入框出现在键盘上面
    
    CGRect inputFrame = _inputContent.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        inputFrame.origin.y = keyboardEndFrame.origin.y - inputFrame.size.height-64;
    }else{
        int offset = CGRectGetHeight(self.view.frame)- keyboardEndFrame.size.width-inputFrame.size.height;
        inputFrame.origin.y=offset;
        
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         _inputContent.frame = inputFrame;
                         
                         CGRect tableFrame = _messageTableView.frame;
                         tableFrame.size.height = inputFrame.origin.y;
                         _messageTableView.frame = tableFrame;
                     }completion:^(BOOL finish){
                         if (messageArray.count>0) {
                             [_messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArray.count-1 inSection:0]
                                                      atScrollPosition:UITableViewScrollPositionBottom
                                                              animated:YES];
                         }
                         
                     }];
    //	keyboardIsShowing = YES;
    
    //    [self slideFrame:YES
    //               curve:animationCurve
    //            duration:animationDuration];
}

// Expand textview on keyboard dismissal
- (void)keyboardWillHide:(NSNotification *)notification
{
	//NSLog(@"keyboardWillHide");
 	NSDictionary *userInfo = [notification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    //把输入框位置下移
    CGRect inputFrame = _inputContent.frame;
    
    inputFrame.origin.y = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone?(keyboardEndFrame.origin.y - inputFrame.size.height-64): (CGRectGetHeight(self.view.frame) -inputFrame.size.height) ;
    
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         _inputContent.frame = inputFrame;
                         
                         if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
                             self.messageTableView.frame = tablePad;
                         }else if (iPhone5){
                             self.messageTableView.frame = tableIphone5;
                         }else{
                             self.messageTableView.frame=tableIphone;
                         }
                         
                     }completion:^(BOOL finish){
                         if (messageArray.count>0) {
                             [_messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArray.count-1 inSection:0]
                                                      atScrollPosition:UITableViewScrollPositionBottom
                                                              animated:YES];
                         }
                     }];
    
    if(![self.view viewWithTag:2013].isHidden)
    {
        [[self.view viewWithTag:2013] setHidden:YES];
        self.showFlag = NO;
    }
    if(![self.view viewWithTag:2014].isHidden)
    {
        [[self.view viewWithTag:2014] removeFromSuperview];
        self.showFlag = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //tableview滑动代表用户想要看到所有的聊天内容，键盘隐藏
    //    [inputView resignFirstResponder];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (inputView.frame.size.height - height);
    CGRect r = _inputContent.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    _inputContent.frame = r;
    CGRect frame = textSendView.frame;
    frame.size.height -= diff;
    textSendView.frame = frame;
    //    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
    //        NSLog(@"最后输入的是表情%@",[inputView.text substringFromIndex:textView.text.length-2]);
    inputView.internalTextView.contentOffset=CGPointMake(0,inputView.internalTextView.contentSize.height-inputView.internalTextView.frame.size.height );
    //    }
    
    for(UIView *view in [textSendView subviews])
    {
        
        if([view isKindOfClass:[UIButton class]])
        {
            CGRect newframe = view.frame;
            newframe.origin.y -= diff;
            view.frame = newframe;
        }
    }
    CGRect tableframe = self.messageTableView.frame;
    tableframe.size.height -= diff;
    self.messageTableView.frame = tableframe;
    
    
}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    //    [self sendAction];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{

}



-(void)sendButtonClick:(id)sender{
    //把输入框中文字去掉头尾空白符和换行符
    NSString *content = [inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(content != nil && content.length != 0){
        [self sendMessage:content type:@"chat"];
    }
    //把输入框清空
    inputView.text = @"";
    
}

-(void)sendMessage:(NSString* )content type:(NSString*)type{
    //拼写xml格式的xmpp消息
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message" ];
    //[message addAttributeWithName:@"type" stringValue:@"chat"];
    //消息发送者
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare]];
    //消息接受者
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    [message addChild:body];
    NSLog(@"friendEntity.name:%@",chatWithUser);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //新建消息的entity
    
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:appDelegate.xmpp.managedObjectContext];
    
    if ([type isEqualToString:@"chat"]) {
        NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"text"];//告诉接受方 传送的是文件 还是 聊天内容
        [message addChild:subject];
        
        [newManagedObject setValue:content forKey:@"content"];
        [newManagedObject setValue:@"text" forKey:@"type"];
        
    }else if ([type isEqualToString:@"image"]){
        NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"image"];//告诉接受方 传送的是文件 还是 聊天内容
        [message addChild:subject];
        [newManagedObject setValue:self.filePath forKey:@"content"];
        [newManagedObject setValue:@"image" forKey:@"type"];
    }
    else {
        NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"voice"];//告诉接受方 传送的是文件 还是 聊天内容
        [message addChild:subject];
        
        [newManagedObject setValue:[urlVoiceFile absoluteString] forKey:@"content"];
        [newManagedObject setValue:@"voice" forKey:@"type"];
    }
    [newManagedObject setValue:[NSDate date] forKey:@"sendDate"];
    [newManagedObject setValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare] forKey:@"sendUser"];
    [newManagedObject setValue:chatWithUser forKey:@"receiver"];
    
    //设置发送者 跟 读取者
    [appDelegate.xmpp saveContext];
    
    
    //XMPPElementReceipt *receipt;
    //发送消息
    [appDelegate.xmpp.xmppStream sendElement:message];
}


//通过url地址播放文件
-(void)playAudio:(NSURL*)url sendid:(id)sender{
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }
    NSLog(@"playRecording");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.delegate = self;
    [audioPlayer play];
    NSLog(@"playing");
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIImageView* imageViewOld = (UIImageView* )[selectBtn viewWithTag:selectBtn.tag+1];
    [imageViewOld stopAnimating];
}

-(void)dismissButtonClick{
    //    [SVProgressHUD dismiss];
    [timer invalidate];
    [AudioView dismiss];
    
    //将文件通过base64 转化成 字符串 然后发送文字字段  文字字段 通过对文字进行 添加属性字段 标示发送的是文件
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
    NSData* fileData = [NSData dataWithContentsOfURL:urlVoiceFile];
    NSLog(@"%@",[Base64 stringByEncodingData:fileData]);
    [self sendMessage:[Base64 stringByEncodingData:fileData] type:@"audio"];
}

/*
 *
 * 开始录音
 *
 */
-(void)dismissButtonTouchDown{
    
    if (selectBtn) {
        UIImageView* imageViewOld = (UIImageView* )[selectBtn viewWithTag:selectBtn.tag+1];
        [imageViewOld stopAnimating];
        [audioRecorder stop];
    }
    //    [SVProgressHUD showWithStatus:@"录音中..." maskType:SVProgressHUDMaskTypeNone];
    //显示提示框
    if (audioRecorder != nil) {
        if ([audioRecorder isRecording]) {
            [audioRecorder stop];
            audioRecorder = nil;
        }
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:6];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];//ID
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];//采样率
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];//解码率
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    //获取document 目录
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    urlVoiceFile= [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"aac"]]];
    
    
    NSLog(@"Using File called: %@",urlVoiceFile);
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:urlVoiceFile settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];
        audioRecorder.meteringEnabled = YES;
        audioView = [AudioView sharedView];
        [self.view addSubview:audioView];
        [self observerAudioPower];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    NSLog(@"recording");
}


-(void)observerAudioPower{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(refreshAudioPower) userInfo:nil repeats:YES];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}



-(void)refreshAudioPower{
    [audioRecorder updateMeters];
    float level = [audioRecorder peakPowerForChannel:0];
    NSLog(@"chanel2-->%f",[audioRecorder peakPowerForChannel:1]);
    int condition = abs(level);
    if(condition < 10){
        [audioView changeLevel:11];
    }else if(condition <= 20){
        [audioView changeLevel:10];
    }else if(condition >= 30){
        [audioView changeLevel:1];
    }else{//介乎于21~29
        int l = condition%20;
        [audioView changeLevel:l];
    }
    
}

/*
 *
 *取消发送语音   获取文件路径  然后删除文件  并重置链接
 *
 */
-(void)dismissButtonTouchCancle{
    //    NSTimeInterval interval = 1;
    //    [SVProgressHUD dismissWithError:@"取消发送" afterDelay:interval];
    [AudioView dismiss];
    [timer invalidate];
    [audioRecorder stop];
    NSLog(@"cancle");
    NSFileManager* fileManeger = [NSFileManager defaultManager];
    [fileManeger removeItemAtURL:urlVoiceFile error:nil];
    urlVoiceFile = nil;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [inputView resignFirstResponder];
}


@end
