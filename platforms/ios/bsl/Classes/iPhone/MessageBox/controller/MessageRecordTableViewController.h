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
@interface MessageRecordTableViewController : UITableViewController<MessageRecordHeaderViewDelegate>{
     CubeWebViewController *cubeWebViewController;
}

@property(nonatomic,retain) NSMutableDictionary *presentModulesDic;
@property (retain, nonatomic) NSMutableDictionary *expandDic;
@property(nonatomic,retain) NSMutableDictionary *flagDictionary;
@property(retain, nonatomic)NSString *selectedModule;
@property BOOL editing;

@end
