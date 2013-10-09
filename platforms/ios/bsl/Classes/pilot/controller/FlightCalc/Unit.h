//
//  Unit.h
//  FlightCalc
//
//  Created by apple on 11-6-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "AbstractTableViewController.h"
#import "PickerInputTableViewCell.h"


@interface Unit : AbstractTableViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPopoverControllerDelegate> {
	UIPickerView *singlePicker;
	NSArray *pickerData;
	UIButton *doneButton;
	UIButton *selectButton;
	UIButton *calcButton;
	UIButton *clrButton;
	UITextField *inputField;
	UITextView *resultField;

}
@property (nonatomic,retain) IBOutlet UIPickerView *singlePicker;
@property (nonatomic,retain) NSArray *pickerData;
@property (nonatomic,retain) IBOutlet UIButton *doneButton;
@property (nonatomic,retain) IBOutlet UIButton *selectButton;
@property (nonatomic,retain) IBOutlet UIButton *calcButton;
@property (nonatomic,retain) IBOutlet UIButton *clrButton;
@property (nonatomic,retain) IBOutlet UITextField *inputField;
@property (nonatomic,retain) IBOutlet UITextView *resultField;

-(IBAction) doCalc:(id)sender;
-(IBAction) doClr:(id)sender;
-(IBAction) donePressed:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) selectButton:(id) sender;
-(IBAction) textFieldDoneEditting:(id) sender;

@end
