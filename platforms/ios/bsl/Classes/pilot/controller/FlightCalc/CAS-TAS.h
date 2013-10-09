//
//  CAS-TAS.h
//  FlightCalc
//
//  Created by apple on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@interface CAS_TAS : AbstractTableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
	UITextField *altField;
	UITextField *tempField;
	UITextField *casField;
	UITextView *resultField;
}
@property (nonatomic,retain) UITextField *altField;
@property (nonatomic,retain) UITextField *tempField;
@property (nonatomic,retain) UITextField *casField;
@property (nonatomic,retain) UITextView *resultField;

-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
