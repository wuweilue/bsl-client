//
//  Wind.h
//  FlightCalc
//
//  Created by apple on 11-6-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "AbstractTableViewController.h"


@interface Wind : AbstractTableViewController<UITextFieldDelegate> {
	UITextField *fromField;
	UITextField *spdField;
	UITextField *hdgField;
	UITextView *resultField;
	UIButton *spdButton;
}
@property (nonatomic,retain) IBOutlet UITextField *fromField;
@property (nonatomic,retain) IBOutlet UITextField *spdField;
@property (nonatomic,retain) IBOutlet UITextField *hdgField;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
@property (nonatomic,retain) IBOutlet UIButton *spdButton;
-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) switchButton:(id) sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
