//
//  DownloadingTableViewCell.m
//  Cube-iOS
//
//  Created by chen shaomou on 12/9/12.
//
//

#import "DownloadingTableViewCell.h"
#import "CubeApplication.h"

@implementation DownloadingTableViewCell
@synthesize moduleIdentifier;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)configWithModule:(CubeModule *)module{
    
    self.moduleIdentifier= module.identifier;
    
    if(_iconButton){
        [_iconButton removeFromSuperview];
        [_iconButton release];
    }
    
    if(module.isDownloading){
        
        _iconButton = [[IconButton alloc] initWithModule:module stauts:IconButtonStautsDownloading delegate:self];
        
        _iconButton.downloadProgressView.progress = module.downloadProgress;
    }else{
        
        _iconButton = [[IconButton alloc] initWithModule:module stauts:IconButtonStautsDownloadEnable delegate:self];
    }
    
    [_iconButton setFrame:CGRectMake(20, 20, 85, 108)];
    
    _iconButton.iconLabel.textColor = [UIColor blackColor];
    
    [self addSubview:_iconButton];
    

    if(!_infoLabel){
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 20, 414, 75)];
        [self addSubview:_infoLabel];
        _infoLabel.numberOfLines = 3;
    }
    [_infoLabel setText:module.releaseNote];
    
    if(!_versionLabel){
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 87, 414, 21)];
        _versionLabel.textColor = [UIColor blackColor];
        [self addSubview:_versionLabel];
    }
     [_versionLabel setText:module.version];

    //先判断当前模块是否正在下载
    if (!module.isDownloading) {
        //根据需求改变downloadButton状态
        if(!_downloadButton){
            _downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _downloadButton.frame = CGRectMake(500, 52, 55, 30);
            [_downloadButton setTitle:@"安装" forState:UIControlStateNormal];
            [_downloadButton setTitleColor:[UIColor colorWithRed:(float)45/255 green:(float)68/255 blue:(float)114/255 alpha:1.0] forState:UIControlStateNormal];
            
            [self addSubview:_downloadButton];
        }else{
            [_downloadButton setTitle:@"安装" forState:UIControlStateNormal];
            [_downloadButton setFrame:CGRectMake(500, 52, 55, 30)];
            [_downloadButton setTitleColor:[UIColor colorWithRed:(float)45/255 green:(float)68/255 blue:(float)114/255 alpha:1.0] forState:UIControlStateNormal];
            [_downloadButton setEnabled:YES];
            
        }

    }else{
        _downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_downloadButton setTitle:@"正在安装" forState:UIControlStateNormal];
        [_downloadButton setFrame:CGRectMake(490, 52, 70, 30)];
        [_downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_downloadButton setEnabled:NO];
        [self addSubview:_downloadButton];
    }
    [_downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_infoLabel release];
    [_versionLabel release];
    [_downloadButton release];
    [_iconButton release];
    [super dealloc];
}
- (IBAction)download:(id)sender {
    
    //icon状态改变为downloading
    self.iconButton.stauts = IconButtonStautsDownloading;
    
    UIButton* button = sender;
    
    //点击下载后改变button状态
    [button setTitle:@"正在安装" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(490, 52, 70, 30)];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setEnabled:NO];
    
    CubeApplication *cubeApp = [CubeApplication currentApplication];
    
    CubeModule *downloadModule = [cubeApp availableModuleForIdentifier:moduleIdentifier];
    
    if(!downloadModule){
    
        downloadModule = [cubeApp updatableModuleModuleForIdentifier:moduleIdentifier];
    }
    
    //如果已经在下载,返回
    if(downloadModule.isDownloading)
        return;
    if([self.delegate respondsToSelector:@selector(downloadAtModuleIdentifier:)])
        [self.delegate performSelector:@selector(downloadAtModuleIdentifier:) withObject:self.moduleIdentifier];
    
}

@end
