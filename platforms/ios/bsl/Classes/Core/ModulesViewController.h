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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CubeApplication *application;
- (IBAction)didClickSync:(id)sender;
- (IBAction)didClickDone:(id)sender;

@end
