//
//  Calc60.h
//  FlightCalc
//
//  Created by apple on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@interface Calc60 : AbstractTableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	UITextField *timeField;
	UITextView *resultField;
}

@property (nonatomic,retain) UITextField *timeField;
@property (nonatomic,retain) UITextView *resultField;

@end
