//
//  NewPDFDownloadViewCell.m
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "NewPDFDownloadViewCell.h"
#import "NewEbookQuery.h"

@implementation NewPDFDownloadViewCell
@synthesize delegate;
@synthesize aBook;
@synthesize downLoadStatus;
@synthesize changeFlag;
@synthesize fileType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        changeFlag = NO;
        pdfStatus = [[NSMutableDictionary alloc] init];
        
        [self.startBottun setTitle:@"S" forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    NSLog(@"-----dealoc-----%@",[_titleLabel text]);
    [[NewEbookQuery sharedNewEbookQuery] disconnectDelegateWithBookID:aBook.bookId];
    [self setDelegate:nil];
    
    [_flagImg release];
    [_titleLabel release];
    [_sizeLabel release];
    [_speedLabel release];
    [_myProgressView release];
    [_startBottun release];
    [_cancelButton release];
    [_groupView release];
    [aBook release];
    [downLoadStatus release];
    [fileType release];
    
    [super dealloc];
}

- (IBAction)didStartClick:(id)sender {
    if ([self.startBottun.titleLabel.text isEqualToString:@"S"]) {
        [self.startBottun setTitle:@"P" forState:UIControlStateNormal];
        [self.startBottun setImage:[UIImage imageNamed:@"button-pause"] forState:UIControlStateNormal];
        self.speedLabel.hidden = NO;
        downLoadStatus = PDF_DOWNLOAD_START;
        
    } else if([self.startBottun.titleLabel.text isEqualToString:@"P"]){
        [self.startBottun setTitle:@"S" forState:UIControlStateNormal];
        [self.startBottun setImage:[UIImage imageNamed:@"button-begin"] forState:UIControlStateNormal];
        self.speedLabel.hidden = YES;
        downLoadStatus = PDF_DOWNLOAD_PAUSE;
    }
    if (!changeFlag) {
        [self beginDownLoadAnimations];
    }
    
    UIButton *btn = (UIButton *)sender;
    
    if (delegate && [delegate respondsToSelector:@selector(didClickedButtonInCellWithBookID:andCell:andTag:)]) {
        [delegate didClickedButtonInCellWithBookID:aBook.bookId andCell:self andTag:btn.tag];
    }
}

- (IBAction)didCancelClick:(id)sender {
    if (changeFlag) {
        [self finishDownLoadAnimations];
    }
    
    [self.startBottun setTitle:@"S" forState:UIControlStateNormal];
    [self.startBottun setImage:[UIImage imageNamed:@"button-begin"] forState:UIControlStateNormal];
    [self.flagImg setImage:[UIImage imageNamed:@"undownload"]];
    
    downLoadStatus = PDF_DOWNLOAD_CANCEL;
    
    UIButton *btn = (UIButton *)sender;
    
    if (delegate && [delegate respondsToSelector:@selector(didClickedButtonInCellWithBookID:andCell:andTag:)]) {
        [delegate didClickedButtonInCellWithBookID:aBook.bookId andCell:self andTag:btn.tag];
    }
}

- (void)downloadSuccess{
    [self.flagImg setImage:[UIImage imageNamed:@"downloaded"]];
}

- (void)downloadFailed{
    [self.flagImg setImage:[UIImage imageNamed:@"undownload"]];
}

#pragma mark - ASI Progress Delegate
//更新进度条和文字显示
-(void)setProgress:(float)newProgress{
   
    self.groupView.hidden = NO;
    
    //如果Ebook对象都不存在就不必要再写状态了
    if (aBook.bookId==nil) return;
    
    self.totaleLength = [[[[NewEbookQuery sharedNewEbookQuery] totalLengthDic] objectForKey:aBook.bookId] longLongValue];

    long long currentLength = self.totaleLength * newProgress;
    
    NSString *totalLength = [self getSpeedStringWithCurrentLength:currentLength AndTotalLength:self.totaleLength];
    
    self.sizeLabel.text = totalLength;
    self.myProgressView.progress = newProgress;
    
    NSString *speedStr = self.speedLabel.text == nil?@"":self.speedLabel.text;
    
    //处理各状态的保存
    
    [pdfStatus setObject:aBook.bookId == nil?@"":aBook.bookId forKey:aBook.bookId];
    [pdfStatus setObject:totalLength == nil?@"":totalLength forKey:@"totalLength"];
    [pdfStatus setObject:speedStr forKey:@"speed"];
    [pdfStatus setObject:[NSNumber numberWithFloat:newProgress] forKey:@"progress"];
    
    [[NSUserDefaults standardUserDefaults] setObject:pdfStatus forKey:aBook.bookId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取到下载文件长度
-(void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
    NSLog(@"获取到下载文件的长度:%lld",newLength);
    self.totaleLength = newLength;    
    
    [[[NewEbookQuery sharedNewEbookQuery] totalLengthDic] setObject:[NSNumber numberWithLongLong:newLength] forKey:aBook.bookId];
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    if(bytes/262144.0 > 1.0){
        self.speedLabel.text = [NSString stringWithFormat:@"%3.2f mb/s",bytes/262144.0];
    }else{
        self.speedLabel.text = [NSString stringWithFormat:@"%3.2f kb/s",bytes/262.144];
    }
}

//将文件长度转换为显示字符
-(NSString *)getSpeedStringWithCurrentLength:(long long)current AndTotalLength:(long long)total{
    NSString *currentStr;
    NSString *totalStr;
    if (current/1024 < 1024) {
        currentStr = [NSString stringWithFormat:@"%3.2f KB",(current/1024.0)];
    } else {
        currentStr = [NSString stringWithFormat:@"%3.2f MB",(current/1024.0/1024.0)];
    }
    if (total/1024 < 1024) {
        totalStr = [NSString stringWithFormat:@"%3.2f KB",(total/1024.0)];
    } else {
        totalStr = [NSString stringWithFormat:@"%3.2f MB",(total/1024.0/1024.0)];
    }
    return [NSString stringWithFormat:@"%@/%@",currentStr,totalStr];
}

//显示有正在下载或暂停的任务的下载状态
- (void)configDownloadingStatus{
    self.groupView.hidden = NO;
    
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = frame.origin.y - 10;
    self.titleLabel.frame = frame;
    self.changeFlag = YES;
    
    //如果Ebook对象都不存在就不必要再写状态了
    if (aBook.bookId==nil)return;
    
    //获取之前任务的状态并显示
    NSMutableDictionary *status = [[NSUserDefaults standardUserDefaults] objectForKey:aBook.bookId];
    
    self.sizeLabel.text = [status objectForKey:@"totalLength"];
    self.speedLabel.text = [status objectForKey:@"speed"];
    self.myProgressView.progress = [[status objectForKey:@"progress"] floatValue];

}

#pragma mark - DownLoad Animations
- (void)beginDownLoadAnimations{
    
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = frame.origin.y - 10;
    self.titleLabel.frame = frame;
    [self.startBottun setTitle:@"P" forState:UIControlStateNormal];
    [self.startBottun setImage:[UIImage imageNamed:@"button-pause"] forState:UIControlStateNormal];
    self.sizeLabel.text = @"";
    self.speedLabel.text = @"";
    self.myProgressView.progress = 0.0;
    
    self.groupView.hidden = YES;
    self.groupView.hidden = NO;
    [UIView commitAnimations];
    
    changeFlag = YES;
}

- (void)finishDownLoadAnimations{
    
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = frame.origin.y + 10;
    [self.startBottun setTitle:@"S" forState:UIControlStateNormal];
    [self.startBottun setImage:[UIImage imageNamed:@"button-begin"] forState:UIControlStateNormal];
    self.titleLabel.frame = frame;
    
    self.sizeLabel.text = @"";
    self.speedLabel.text = @"";
    self.myProgressView.progress = 0.0;
    
    self.groupView.hidden = YES;
    [UIView commitAnimations];
    
    changeFlag = NO;
    
    //如果Ebook对象都不存在就不必要再写状态了
    if (aBook.bookId==nil) return;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:aBook.bookId];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

@end
