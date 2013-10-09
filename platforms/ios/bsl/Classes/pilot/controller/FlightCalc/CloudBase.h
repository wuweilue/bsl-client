//
//  CloudBase.h
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@interface CloudBase : AbstractTableViewController <UITextFieldDelegate> {
	UITextField *tempField;
	UITextField *dewField;
	UITextView *resultField;	
	
}
@property (nonatomic,retain) IBOutlet UITextField *tempField;
@property (nonatomic,retain) IBOutlet UITextField *dewField;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
