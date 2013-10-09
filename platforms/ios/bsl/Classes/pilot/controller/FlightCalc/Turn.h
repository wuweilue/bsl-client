//
//  Turn.h
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "AbstractTableViewController.h"


@interface Turn : AbstractTableViewController<UITextFieldDelegate> {
	UITextField *bankField;
	UITextField *tasField;
	UITextView *resultField;			
}
@property (nonatomic,retain) IBOutlet UITextField *bankField;
@property (nonatomic,retain) IBOutlet UITextField *tasField;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
