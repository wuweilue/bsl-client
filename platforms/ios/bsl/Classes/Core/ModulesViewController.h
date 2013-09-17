//
//  ModulesViewController.h
//  Cube
//
//  Created by Justin Yip on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CubeApplication.h"

@interface ModulesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) CubeApplication *application;
- (IBAction)didClickSync:(id)sender;
- (IBAction)didClickDone:(id)sender;

@end
