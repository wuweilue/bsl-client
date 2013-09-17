
//
//  IphoneDownloadingTableViewCell.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/21/12.
//
//
#import "CubeApplication.h"
#import "UIColor+expanded.h"
#import "DownloadingViewController.h"


#import "IphoneDownloadingTableViewCell.h"

@interface IphoneDownloadingTableViewCell ()

@property (weak,nonatomic) CubeModule *module;

@end


@implementation IphoneDownloadingTableViewCell
@synthesize moduleIdentifier;
@synthesize alertMessageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithModule:(CubeModule *)module andConfig:(cellConfig)curConfig{
    self.downloadButton.enabled=TRUE;
    self.moduleIdentifier= module.identifier;
    self.module = module;
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 2;
    
    
    //定义样式
    self.backgroundColor = [UIColor whiteColor];
    
    
    if(_iconButton){
        [_iconButton removeFromSuperview];
    }
    
    if(module.isDownloading){
        _iconButton = [[IconButton alloc] initWithIdentifier:module.identifier iconName:@"" IconImageUrl:module.iconUrl iconStauts:IconButtonStautsDownloading delegate:self];
        _iconButton.downloadProgressView.progress = module.downloadProgress;
        
    }else{
        CubeModule *updatableModule = [[CubeApplication currentApplication] updatableModuleModuleForIdentifier:module.identifier];
        if(updatableModule){
            _iconButton = [[IconButton alloc] initWithIdentifier:module.identifier iconName:@"" IconImageUrl:module.iconUrl iconStauts:IconButtonStautsNeedUpdate delegate:self];
        }else{
            _iconButton = [[IconButton alloc] initWithIdentifier:module.identifier iconName:@"" IconImageUrl:module.iconUrl iconStauts:IconButtonStautsDownloadEnable delegate:self];
        }
    }
    
    [_iconButton observerDownload:module];
    
    [_iconButton defaultSet];
    _iconButton.frame=CGRectMake(20, 0, 35,35);
    [_iconButton transformWithWidth:kButtonWidth andHeight:kButtonHeight];
    
    
    _iconButton.iconLabel.textColor = [UIColor colorWithRGBHex:0x212121];
    _iconButton.iconLabel.font= [UIFont boldSystemFontOfSize:13];
    [self addSubview:_iconButton];
    
    
    if(!_infoLabel){
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 155, 19)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:15];
        _infoLabel.numberOfLines = 1;
        _infoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_infoLabel];
    }
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 23, 163, 21)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.numberOfLines = 1;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
    }
    
    _nameLabel.text = module.name;
    
//    [_infoLabel setText:module.releaseNote];
    _infoLabel.text = module.name;
    
    if(!_versionLabel){
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 155, 13)];
        _versionLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11];
        _versionLabel.textColor = [UIColor colorWithRGBHex:0x969696];
        [self addSubview:_versionLabel];
    }
    [_versionLabel setText:module.version];
    
    if(!_releasenoteLabel){
    
        _releasenoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 145, 13)];
        _releasenoteLabel.font = [UIFont fontWithName:@"Helvetica Neue"size:11];
        _releasenoteLabel.textColor = [UIColor colorWithRGBHex:0x969696];
        [_releasenoteLabel setNumberOfLines:1];
        [self addSubview:_releasenoteLabel];
    }
    
    [_releasenoteLabel setText:module.releaseNote];
    
    enum InstallButtonStatus status=InstallButtonStateUninstall;
    if (curConfig==EADD) {
        status = InstallButtonStateUninstall;
    }else if (curConfig==EDELETE)
    {
        status = InstallButtonStateInstalled;
    }else if (curConfig==EUPDATE)
    {
        status = InstallButtonStateUpdatable;
    }
    
    if(!self.downloadButton){
        self.downloadButton = [[InstallButton alloc] initWithFrame:CGRectMake(250,23,50,25)];
        [self addSubview:self.downloadButton];
    }
    

    //先判断当前模块是否正在下载
    if (!module.isDownloading) {
        //根据需求改变downloadButton状态
        if (!module.local) {
            self.downloadButton.btnStatus = status;
        }
        
    }else{
        self.downloadButton.btnStatus = InstallButtonStateInstalling;
    }
    _downloadButton.hidden=(module.local||curConfig==ENONE)?TRUE:FALSE;
    if (module.local||curConfig==ENONE) {
        _downloadButton.hidden=TRUE;
        for (UIView *tempView in self.subviews) {
            if ([tempView isKindOfClass:NSClassFromString(@"InstallButton")]) {
                tempView.hidden=TRUE;
            }
        }
    }else
    {
        _downloadButton.hidden=FALSE;
    }
    [_downloadButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    if (curConfig==EDELETE) {
        [_downloadButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void)delete:(id)sender
{
//    CubeApplication *cubeApp = [CubeApplication currentApplication];
//    
//    NSArray *modules  = [cubeApp modules];
//    
//    for(CubeModule *each in modules){
//        
//        if([each.identifier isEqualToString:moduleIdentifier]){
//            [cubeApp uninstallModule:each];
//            break;
//        }
//    }
    self.downloadButton.btnStatus = InstallButtonStateDeleting;
    alertMessageView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定删除此模块?"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    
    alertMessageView.tag =100;
    [alertMessageView show];

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
       
    if(buttonIndex == 0){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteAtModuleIdentifier:)])  {
            [self.delegate deleteAtModuleIdentifier:self.moduleIdentifier];
        }
    }else{
        self.downloadButton.btnStatus = InstallButtonStateInstalled;
    }

}
- (IBAction)download:(id)sender {
    
    //icon状态改变为downloading

    self.iconButton.stauts = IconButtonStautsDownloading;
    self.downloadButton.btnStatus = InstallButtonStateInstalling;
    
    CubeApplication *cubeApp = [CubeApplication currentApplication];
    
    CubeModule *downloadModule = [cubeApp availableModuleForIdentifier:moduleIdentifier];
    
    if(!downloadModule){
        
        downloadModule = [cubeApp updatableModuleModuleForIdentifier:moduleIdentifier];
        //监听下载
        [self.iconButton observerDownload:downloadModule];
    }
    
    
    //如果已经在下载,返回
    if(downloadModule.isDownloading)
        return;

    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadAtModuleIdentifier:andCategory:)])  {
        [self.delegate downloadAtModuleIdentifier:self.moduleIdentifier andCategory:self.module.category];
    }
}


-(void)dealloc{
    [_iconButton removeNotification];
}

#pragma mark --- IconButtonDelegate
- (void)launch:(int)index identifier:(NSString *)identifier
{
    [self.delegate clickItemWithIndex:index andIdentifier:identifier];
}

- (void)download:(id)sender identifier:(NSString *)identifier{}
- (void)removeFromSpringboard:(int)index{}
- (void)removeEnuseableModuleFromSpringboard:(NSString *)identifier index:(int)index{}
- (void)enableEditingMode{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(enableEditingMode)])  {
        [self.delegate performSelector:@selector(enableEditingMode)];
    }
}
@end
