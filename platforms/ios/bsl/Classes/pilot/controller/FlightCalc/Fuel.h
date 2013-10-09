//
//  Fuel.h
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "StringInputTableViewCell.h"

@interface Fuel : AbstractTableViewController<UITextFieldDelegate> {
	UITextField *sgField;
	UITextField *ltField;
	UITextField *usField;
	UITextField *ukField;
	UITextField *kgField;
	UITextField *lbField;
	UIScrollView *scrollView;
	UITextField *activeField;
    UIButton *sgButton;
	BOOL keyboardShown;
}
@property (nonatomic,retain) IBOutlet UITextField *sgField;
@property (nonatomic,retain) IBOutlet UITextField *ltField;
@property (nonatomic,retain) IBOutlet UITextField *usField;
@property (nonatomic,retain) IBOutlet UITextField *ukField;
@property (nonatomic,retain) IBOutlet UITextField *kgField;
@property (nonatomic,retain) IBOutlet UITextField *lbField;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIButton *sgButton;

-(IBAction) changesg:(id)sender;
-(IBAction) doCalc:(id)sender;
-(IBAction) doClr:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;
//-(void)registerForKeyBoardNotifications;


@end
