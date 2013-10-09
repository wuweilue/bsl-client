//
//  PDFDownloadViewCell.m
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PDFDownloadViewCell.h"

@implementation PDFDownloadViewCell
@synthesize titleLable,progressView,speedLable,controlButton;
@synthesize isReload=_isReload;

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



+(PDFDownloadViewCell *)getInstance{
    PDFDownloadViewCell* cell=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PDFDownloadViewCell_Phone" owner:nil options:nil]objectAtIndex:0];
    }else{
        cell= [[[NSBundle mainBundle]loadNibNamed:@"PDFDownloadViewCell_Pad" owner:nil options:nil]objectAtIndex:0];
    }
    cell.isReload=NO;
    return cell;
}

// These methods are used to update UIProgressViews (iPhone OS) or NSProgressIndicators (Mac OS X)
// If you are using a custom progress delegate, you may find it easier to implement didReceiveBytes / didSendBytes instead
#if TARGET_OS_IPHONE
- (void)setProgress:(float)newProgress{

    [self.progressView setProgress:newProgress];
}
#else
- (void)setDoubleValue:(double)newProgress{
    
    [self.progressView setDoubleValue:newProgress];

}
- (void)setMaxValue:(double)newMax{
    
    [self.progressView setMaxValue:newMax];
}
#endif

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    if(bytes/262144.0 > 1.0){
    
        speedLable.text = [NSString stringWithFormat:@"%3.2f mb/s",bytes/262144.0];
        
    }else{
    
        speedLable.text = [NSString stringWithFormat:@"%3.2f kb/s",bytes/262.144];
    }
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength;{

}

-(void)downloadSuccess{

}

-(void)downloadFailed{

    self.speedLable.text = @"下载失败";
    
    self.progressView.hidden=YES;
    
    [self.controlButton setTitle:@"下载" forState:UIControlStateNormal];
}

-(void)downloadCancel{

    
    self.speedLable.text = @"下载取消";
    
    self.progressView.hidden=YES;
    
    [self.controlButton setTitle:@"下载" forState:UIControlStateNormal];
}

-(void)setIsReload:(BOOL)isReload{
    _isReload=isReload;
    if (_isReload) {
        [self.controlButton setTitle:@"重 载" forState:UIControlStateNormal];
        [self.controlButton setBackgroundImage:[UIImage imageNamed:@"Button_Blue"] forState:UIControlStateNormal];

    }else{
        [self.controlButton setTitle:@"下 载" forState:UIControlStateNormal];
        [self.controlButton setBackgroundImage:[UIImage imageNamed:@"Button_Orange"] forState:UIControlStateNormal];
    }
}

@end
