//
//  SDA.h
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "StringInputTableViewCell.h"

@interface SDA : AbstractTableViewController<UITextFieldDelegate> {
	UITextField *altField;
	UITextField *dmeField;
	UITextField *spdField;
	UITextView *resultField;
	UIButton *clrButton;
}
@property (nonatomic,retain) IBOutlet UITextField *altField;
@property (nonatomic,retain) IBOutlet UITextField *dmeField;
@property (nonatomic,retain) IBOutlet UITextField *spdField;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
@property (nonatomic,retain) IBOutlet UIButton *clrButton;
-(IBAction) doCalc:(id)sender;
-(IBAction) doClr:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
