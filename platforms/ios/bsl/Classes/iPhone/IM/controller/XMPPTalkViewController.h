//
//  XMPPTalkViewController.h
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "UserInfo.h"
#import "TURNSocket.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "HTTPRequest.h"
#import "SwipeView.h"
#import "UIExpandingTextView.h"
#import "UIScrollView+SpiralPullToRefresh.h"
#import "ChatTableView.h"

@interface XMPPTalkViewController : UIViewController<UITextViewDelegate,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,SwipeViewDataSource,SwipeViewDelegate,UIExpandingTextViewDelegate>{
    NSString* chatWithUser;
    SwipeView *swipeView;
    CGRect keyboardEndFrame;
    UIExpandingTextView *inputView;
    CGFloat previousContentHeight;
    UserInfo *selfEntity;
    UIPageControl *pager;
    NSMutableArray *messageArray;
    NSFetchedResultsController *fetchController;
    
    TURNSocket *scoket;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer*  audioPlayer ;
    
    UIView * textSendView;
    UIView * voiceSendView;
    int count;
    NSDictionary *dictionary;
    int curPage;
    
}
@property(nonatomic,assign) BOOL downloadflag;
@property(nonatomic,assign) BOOL showFlag;
@property (strong,nonatomic) NSString* chatWithUser;
@property (strong, nonatomic) IBOutlet ChatTableView *messageTableView;
@property (strong, nonatomic) IBOutlet UIImageView *inputContent;
@property (nonatomic,assign)BOOL isGroupChat;

@property (strong,nonatomic) NSString* filePath;

-(void)sendButtonClick:(id)sender;
@property(nonatomic,strong) UserInfo *friendEntity;
@end
