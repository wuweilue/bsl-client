//
//  AnnouncementTableViewController.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/5/13.
//
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewController : UITableViewController{
    NSTimer* delayLoadTimer;
}

@property (nonatomic,strong) NSMutableArray *list;

@property BOOL editing;
@property int slideIndex;
@property BOOL isSliding;
@property (nonatomic,strong) NSString * recordId;

@end
