//
//  iphoneVoiceDetailViewController.m
//  Cube-iOS
//
//  Created by Mr.幸 on 12-12-21.
//
//

#import "iphoneVoiceDetailViewController.h"
#import "LongPressButton.h"
#import "NSFileManager+Extra.h"
#import "VoiceModule.h"
#import "HTTPRequest.h"
#import "UIDevice+IdentifierAddition.h"
#define kCUBEAUDIO_Notification @"Notification_AUDIO"
#import "JSONKit.h"
#import "ConfigManager.h"


#define kCUBEVOICEPLIST @"cube_Audio.plist"
#define kCUBEVOICEDIRE_PATH @"com.foss.audio"
#define kURL_PATH @"/m/audiorecord"

@interface iphoneVoiceDetailViewController (){
    NSMutableArray* _objects;
    LongPressButton *_button;
    CGRect cellFrame;
    NSString* locationString;
    NSString* recordedFile;
    NSURL* recordedFileUrl;
    BOOL recordSuccess;
}

@end

@implementation iphoneVoiceDetailViewController

- (void)dealloc
{
    [recordedFileUrl release];
    [locationString release];
    [_objects release];
    [_button release];
    [player release];
    [recordedFile release];
    [_tableView release];
    [recorder release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"在线答疑";

    recordedFile = [[NSString alloc]init];
    recordedFile = nil;
    
    cellFrame = CGRectMake(0, 0, 320, 76);
    
    if (iPhone5) {
        _button = [[LongPressButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height+35, 280, 44)];
    }else{
        _button=[[LongPressButton alloc] initWithFrame:CGRectMake(20, 361, 280, 44)];
    }
    [_button setTitle:@"按住录音" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(longPress:) forControlEvents:ControlEventTouchLongPress];
    [_button addTarget:self action:@selector(cancelLongPress:) forControlEvents:ControlEventTouchCancel];
    [_button addTarget:self action:@selector(beginPress:) forControlEvents:ControlEventTouchInside];

    [self.view addSubview:_button];
    
    [self initPlistFile];
    
    _objects = [[NSMutableArray arrayWithContentsOfFile:[self CubeVoicePlist]]retain];
    
    [self showTheLastRow];
    
//    if(self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
//        
//    }else{
//        _controlTableView.frame = CGRectMake(0, 0, 321, 748);
//        _separatieView.frame = CGRectMake(321, 0, 2, 748);
//        self.tableView.frame = CGRectMake(321, 0, 703, 600);
//        _button.frame = CGRectMake(405, 608, 665,85);
//        cellFrame = CGRectMake(0, 0, 672, 101);
//        [self.tableView reloadData];
//    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivesAudioData) name:kCUBEAUDIO_Notification object:nil];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(removeAll)]];
}

-(void)initPlistFile{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self CubeVoicePlist]]) {
        _objects = [[NSMutableArray alloc]init];
        [_objects writeToFile:[self CubeVoicePlist] atomically:YES];
        [_objects release];
    }
}

-(void)removeAll{
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self CubeVoicePlist]]) {
        [fm removeItemAtPath:[self CubeVoicePlist] error:nil];
        [fm removeItemAtPath:[self CubeVoicePath] error:nil];
        [self reRefreshView];
    }
}

-(void)reRefreshView{
    _objects = [[NSMutableArray arrayWithContentsOfFile:[self CubeVoicePlist]] retain];
    [_tableView reloadData];
    [self showTheLastRow];
}

-(void)receivesAudioData
{
    [self reRefreshView];
}

-(void)beginPress:(id)sender{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [locationString release];
    [recordedFileUrl release];
    locationString=[[dateformatter stringFromDate:senddate] retain];
    [dateformatter release];
    recordedFileUrl = [[NSURL fileURLWithPath:[[self CubeVoicePath] stringByAppendingString:[NSString stringWithFormat: @"/RecordedFile %@",locationString]]] retain];
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFileUrl settings:nil error:nil];
    [recorder prepareToRecord];
    [recorder record];
    recordSuccess = NO;
}

-(void)longPress:(id)sender
{
    recordSuccess = YES;
    VoiceModule* voiceModule = [[VoiceModule alloc]init];
    voiceModule.dateAndtime = locationString;
    voiceModule.localUrl = recordedFileUrl;
    voiceModule.isUser = YES;
    
    [self initPlistFile];
    
    [self saveVoiceModule:voiceModule];
        
    [voiceModule release];
}

-(void)cancelLongPress:(id)sender
{
    [recorder stop];
    
    if (recordSuccess) {
        [self postRecorder];
        [self reRefreshView];
    }else{
        [[NSFileManager defaultManager]removeItemAtURL:recordedFileUrl error:nil];
    }
}

-(void)postRecorder{
    //    recordedFile = [[self CubeVoicePath]stringByAppendingString:[NSString stringWithFormat: @"/RecordedFile %@",locationString]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"token"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d%@",kXMPPHost,kServerPort,kURL_PATH]];
    
    NSData* recorderData = [NSData dataWithContentsOfURL:recordedFileUrl];
    NSString* deviceId= [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    FormDataRequest* request = [FormDataRequest requestWithURL:url];
    request.delegate =self;
    //    [request setPostValue:recorderData forKey:@"recorder"];
    
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:deviceId forKey:@"deviceId"];
    [request setDidFinishSelector:@selector(getResult:)];
    [request addData:recorderData forKey:@"audio"];
    [request setPostValue:@"aac" forKey:@"audioType"];
    
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[recorderData length]]];
    
    [request startAsynchronous];
    
    [recordedFileUrl release];
    recordedFileUrl = nil;
}

-(void)getResult:(HTTPRequest*)request{
    NSData* data = [request responseData];
    NSString* dataToString = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    NSLog(@"message:%@",dataToString);
    
}



-(void)saveVoiceModule:(VoiceModule*)voiceModule{
    
    NSMutableDictionary* voiceDic = [NSMutableDictionary dictionary];
    [voiceDic setObject:voiceModule.dateAndtime forKey:@"date"];
    [voiceDic setObject:voiceModule.localUrl forKey:@"localPath"];
    NSNumber* isUser = [NSNumber numberWithBool:voiceModule.isUser];
    [voiceDic setObject:isUser forKey:@"isUser"];
    //    [voiceDic setObject:voiceModule.url forKey:@"url"];
    //    [voiceDic setObject:voiceModule.module forKey:@"module"];
    //    [voiceDic setObject:voiceModule.fileName forKey:@"fileName"];
    
    [_objects addObject:voiceDic];
    
    
    NSString *plist = [_objects description];
    NSError *error = nil;
    [plist writeToFile: [self CubeVoicePlist]
            atomically:YES
              encoding:NSUTF8StringEncoding
                 error:&error];
}

-(void)showTheLastRow{
    
    if ([_objects count]!= 0) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[_objects count]-1 inSection:0];
        
        [_tableView scrollToRowAtIndexPath:indexPath
         
                                atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
            return [_objects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 77;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            
        static NSString *identifier = @"VVMessageCell";
        VVMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[[[NSBundle mainBundle] loadNibNamed:@"iphoneVVMessageCell" owner:self options:nil] objectAtIndex:0] retain];
        }
        cell.delegate = self;
        cell.frame = cellFrame;
        
        NSDictionary* voiceDic = [_objects objectAtIndex:indexPath.row];
        cell.timeLabel.text = [voiceDic objectForKey:@"date"];
        cell.recordedFile = [voiceDic objectForKey:@"localPath"];
        BOOL isUser = [(NSNumber*)[voiceDic objectForKey:@"isUser"] boolValue];
        cell.isUser = isUser;
        
        
        if (isUser) {
            [cell alignRight];
        } else {
            [cell alignLeft];
        }
        
        return cell;

}



-(void)playRecorder:(NSURL *)theRecordedFile isUser:(BOOL)userOrnot{
    NSError *playerError;
    
    if ([player isPlaying]) {
        return;
    }else{
        
        if (!userOrnot) {
            NSData *data = [NSData dataWithContentsOfFile:(NSString*)theRecordedFile];
            player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
            
        }else{
            NSURL* url = [NSURL URLWithString:(NSString*)theRecordedFile];
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
        }
        
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        [player play];
    }
    
}





- (NSString *)CubeVoicePlist
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
    
    documentDir =[documentDir stringByAppendingPathComponent:kCUBEVOICEDIRE_PATH];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm isReadableFileAtPath:documentDir])
    {
        [fm createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [documentDir stringByAppendingPathComponent:kCUBEVOICEPLIST];
}

-(NSString*)CubeVoicePath
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
    
    documentDir =[documentDir stringByAppendingPathComponent:kCUBEVOICEDIRE_PATH];
    
    return documentDir;
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
