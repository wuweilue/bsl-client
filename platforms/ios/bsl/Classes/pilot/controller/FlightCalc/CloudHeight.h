//
//  CloudHeight.h
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@interface CloudHeight : AbstractTableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
	UITextField *tiltField;
	UITextField *distField;
	UITextView *resultField;	
}

@property (nonatomic,retain) UITextField *tiltField;
@property (nonatomic,retain) UITextField *distField;
@property (nonatomic,retain) UITextView *resultField;

@end
