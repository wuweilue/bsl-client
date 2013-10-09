//
//  CloudBase.m
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudBase.h"
#import "FCTextFieldTableViewCell.h"
#import "FPButtonTableViewCell.h"
#import "FPTextViewTableViewCell.h"

@interface CloudBase () {
    
}

@property (nonatomic, retain) NSString *resultString;

@end

@implementation CloudBase

@synthesize tempField;
@synthesize dewField;
@synthesize resultField;
@synthesize resultString;

- (IBAction) backgroundTap:(id) sender {
	[tempField resignFirstResponder];
	[dewField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==tempField) {
		[dewField becomeFirstResponder];
	} else if (sender==dewField){
		[dewField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=6) 
		return NO;
	//if (textField==tiltField) {
		if (range.location==0 && [string isEqualToString: @"-"])
			return YES;
	//}	
	if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound) {
		return YES;
	}
	
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

- (IBAction) doCalc:(id) sender {
	[self backgroundTap:sender];
	if ([tempField.text length]<1 || [dewField.text length]<1) 
		return;
	double temp=[tempField.text doubleValue];
	double dew=[dewField.text doubleValue];
	if(temp<dew) {
		resultField.text=@"Temperature err!";
        
        self.resultString=resultField.text;
        [self.tableView reloadData];
        
		return;
	}
	NSMutableString *resultStr;
	resultStr=[[NSMutableString alloc] initWithCapacity:256];
	[resultStr setString:@""];
	[resultStr appendFormat:@"Temperature at Ground: %1.1f °C\n",temp];
	[resultStr appendFormat:@"Dewpoint at Ground: \t%1.1f °C\n",dew];
	double alt=(temp-dew)*1000.0*(9.0/5.0)/4.4*0.3048;
	[resultStr appendFormat:@"Cloud Base Altitude (AGL):\n\t\t%1.1f M\n\t\t%1.0f ft\n",alt,alt/0.3048];
	[resultStr appendFormat:@"Estimated Freezing Level (AGL):\n\t\t%1.1f M\n\t\t%1.0f ft\n",temp/0.0065,temp/0.0065/0.3048];
	[resultStr appendFormat:@"Estimated Temperature at Cloud Base:\t%1.1f °C",temp-alt*0.0065];
	//[resultStr appendFormat:@"\n%d\n\n\n",[resultStr length]];//208
	resultField.text=resultStr;
	[resultStr release];	
	tempField.text=@"";	
	dewField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CGRect myFrame;
	myFrame=[tempField frame];
	myFrame.size.height+=6;
	tempField.frame=myFrame;
	myFrame=[dewField frame];
	myFrame.size.height+=6;
	dewField.frame=myFrame;
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.tempField=nil;
	self.dewField=nil;
	self.resultField=nil;
    self.resultString = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[tempField release];
	[dewField release];
	[resultField release];
    [resultString release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"FCTextFieldTableViewCell";
        FCTextFieldTableViewCell *cell = (FCTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [FCTextFieldTableViewCell getInstance];
        }
        
        cell.customLabel.numberOfLines = 0;
        if (indexPath.row == 0) {
            cell.customLabel.text = @"Air Temperature at Ground Level";
            if (device_Type == UIUserInterfaceIdiomPhone) {
                cell.customLabel.text = @"Air Temperature\nat Ground Level";
            }
            
            cell.customTextField.placeholder = @"°C";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
            self.tempField = cell.customTextField;
            [tempField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            return cell;
        } else {
            cell.customLabel.text = @"Dewpoint at Ground Level";
            if (device_Type == UIUserInterfaceIdiomPhone) {
                cell.customLabel.text = @"Dewpoint\nat Ground Level";
            }
            
            cell.customTextField.placeholder = @"°C";
            cell.customTextField.delegate = self;
            
            self.dewField = cell.customTextField;
            [dewField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"ButtonTableViewCell";
        FPButtonTableViewCell *cell = (FPButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [FPButtonTableViewCell getInstance];
        }
        
        UIImage *image = nil;
        if (device_Type == UIUserInterfaceIdiomPhone) {
            image = [[UIImage imageNamed:@"Button_Orange_Phone.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        } else {
            image = [[UIImage imageNamed:@"Button_Orange_Pad.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        }
        
        [cell.customButton setBackgroundImage:image forState:UIControlStateNormal];
        
        [cell.customButton setTitle:@"CALC" forState:UIControlStateNormal];
        [cell.customButton addTarget:self action:@selector(doCalc:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        static NSString *identifier = @"UITableViewCellStyleDefault";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"结果：";
        
        if (self.resultString && ![self.resultString isEqualToString:@""]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.resultString];
        }
        
        cell.textLabel.numberOfLines=0;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        CGSize size = [self.resultString sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.tableViewWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height<44) {
            return 44;
        }
        return size.height;
    } else {
        return 44;
    }
}

@end
