//
//  Qnhqfe.h
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "StringInputTableViewCell.h"


@interface Qnhqfe : AbstractTableViewController<UITextFieldDelegate> {
	UITextField *altField;
	UITextField *setField;
	UIButton *ftButton;
	UIButton *qnhButton;
	UIButton *barButton;
	UITextView *resultField;			
}
@property (nonatomic,retain) IBOutlet UITextField *altField;
@property (nonatomic,retain) IBOutlet UITextField *setField;
@property (nonatomic,retain) IBOutlet UIButton *ftButton;
@property (nonatomic,retain) IBOutlet UIButton *qnhButton;
@property (nonatomic,retain) IBOutlet UIButton *barButton;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;
-(IBAction) switchButtonFT:(id) sender;
-(IBAction) switchButtonQNH:(id) sender;
-(IBAction) switchButtonBar:(id) sender;

@property (retain, nonatomic) IBOutlet UIView *buttonGroupView;

@end
