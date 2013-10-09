//
//  CDACell.h
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CDACell : UITableViewCell <UITextFieldDelegate,UIScrollViewDelegate> {
	UITextField *fromField;
	UITextField *fafField;
	UITextField *dmeField;
	UIButton *angButton;
	UITextField *angleField;
	UITextField *spdField;
	UITextField *mdaField;
	UITextView *resultField;
	UIView *bkView;
}

@property (nonatomic,retain) IBOutlet UITextField *fromField;
@property (nonatomic,retain) IBOutlet UITextField *fafField;
@property (nonatomic,retain) IBOutlet UITextField *dmeField;
@property (nonatomic,retain) IBOutlet UITextField *angleField;
@property (nonatomic,retain) IBOutlet UITextField *spdField;
@property (nonatomic,retain) IBOutlet UITextField *mdaField;
@property (nonatomic,retain) IBOutlet UIButton *angButton;
@property (nonatomic,retain) IBOutlet UITextView *resultField;
@property (nonatomic,retain) IBOutlet UIView *bkView;
-(IBAction) doCalc:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) textFieldDoneEditting:(id) sender;
-(IBAction) angleButton:(id) sender;

@end
