//
//  MessageRecordTableViewController.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/1/13.
//
//

#import <UIKit/UIKit.h>
#import "MessageRecordHeaderView.h"
#import "CubeWebViewController.h"
#define RECORD_DELETE @"RECORD_DELETE"
@interface MessageRecordTableViewController : UIViewController<MessageRecordHeaderViewDelegate>{
    UITableView* tableView;
    CubeWebViewController *cubeWebViewController;
    
    NSTimer* delayLoadTimer;
}

@property(nonatomic,strong) NSMutableDictionary *presentModulesDic;
@property (strong, nonatomic) NSMutableDictionary *expandDic;
@property(nonatomic,strong) NSMutableDictionary *flagDictionary;
@property(strong, nonatomic)NSString *selectedModule;
@property BOOL editing;

@end
