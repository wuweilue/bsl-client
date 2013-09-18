//
//  SettingsViewController.m
//  Cube-iOS
//
//  Created by Justin Yip on 2/5/13.
//
//

#import "SettingsViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import "XMPPIMActor.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)dealloc {
    [_contentView release];
    [_scrollView release];
    [_versionLabel release];
    [_deviceIDLabel release];
    self.uc = nil;
    [_isConnectLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:self.contentView];

    self.scrollView.contentSize = self.contentView.frame.size;
    
    self.title = @"设置中心";
    
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", shortVersion];
    
    NSString *deviceID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    self.deviceIDLabel.text = deviceID;
    
    self.uc = [[UpdateChecker alloc] initWithDelegate:self];
    
    if([((AppDelegate *)[UIApplication sharedApplication].delegate).xmpp isConnected]){
        
        self.isConnectLabel.text = @"已连接";
    }else{
    
        self.isConnectLabel.text = @"未连接";
    }
}

- (void)viewDidUnload {
    [self.contentView removeFromSuperview];
    [self setContentView:nil];
    [self setScrollView:nil];
    [self setVersionLabel:nil];
    [self setDeviceIDLabel:nil];
    [self setIsConnectLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressCheckUpdate:(id)sender {
    [self.uc check];
}

-(void)updateAvailable
{
    //Not Needed
    
}

-(void)updateUnavailable
{
    NSString *message = [NSString stringWithFormat:@"已是最新版本"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

-(void)updateError:(NSError*)aError
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ((BOOL)[defaults objectForKey:@"offLineSwitch"]) {
        NSString *message = [NSString stringWithFormat:@"离线模式不能更新"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"更新出错，请检查网络"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
    [av release];
}

@end
