//
//  MenuViewController.h
//  FlightCalc
//
//  Created by apple on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AbstractTableViewController.h"

#define FlightCalcTitle @"FlightCalc"
#define FlightCalcSuffix '7'

@interface FilghtCaleMenuViewController : AbstractTableViewController<UITextFieldDelegate> {
	NSArray *controllers;

	UITextField *companyField;
	UITextField *nameField;
	UITextField *emailField;
	UITextField *keyField;
	UILabel *devIdLabel;
	UIView *mAlertViewSuper;
	UIView *mAlertView;
	
	UIWindow *mTempFullscreenWindow;
	NSUInteger selectRow;
	NSMutableString *myDeviceId;
	NSMutableString *myDeviceIdkey;
	BOOL isRegisted;
	UIAlertView *myActivityAlert;
}
@property (nonatomic, retain) NSArray *controllers;
@property (nonatomic, retain) IBOutlet UITextField *companyField;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *keyField;
@property (nonatomic, retain) IBOutlet UILabel *devIdLabel;
@property (nonatomic, retain) IBOutlet UIView *mAlertView;
@property (nonatomic, retain) IBOutlet UIView *mAlertViewSuper;

- (BOOL) connectedToNetwork;
-(IBAction) GetKey:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;
- (IBAction)showAlertView:(id)sender;
- (IBAction)dismissAlertView:(id)sender;
-(void) goNext;
-(void) checkregsit;
-(void) postdata;

@end
