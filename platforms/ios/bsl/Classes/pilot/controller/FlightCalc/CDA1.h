//
//  CDA1.h
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

#define kTableViewRowHeight 638

@interface CDA1 : AbstractTableViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate> {
    UITextField *fromField;
	UITextField *fafField;
	UITextField *dmeField;
	UIButton *angButton;
	UITextField *angleField;
	UITextField *spdField;
	UITextField *mdaField;
	UITextView *resultField;
}

@property (nonatomic,retain) UITextField *fromField;
@property (nonatomic,retain) UITextField *fafField;
@property (nonatomic,retain) UITextField *dmeField;
@property (nonatomic,retain) UITextField *angleField;
@property (nonatomic,retain) UITextField *spdField;
@property (nonatomic,retain) UITextField *mdaField;
@property (nonatomic,retain) IBOutlet UIButton *angButton;
@property (nonatomic,retain) UITextView *resultField;

-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id)sender;
-(IBAction) angleButton:(id)sender;

@end
