//
//  FPTaskTeamMemberViewController.h
//  pilot
//
//  Created by Sencho Kong on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FltTask.h"
#import "FPPicDownloader.h"

@interface FPTaskTeamMemberViewController : UITableViewController<UIScrollViewDelegate,imageDownloaderDelegate>

@property (nonatomic, retain) FltTask* fltTask;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSArray* listOfMembers;

@end
