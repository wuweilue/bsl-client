//
//  CloudHeight.m
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudHeight.h"
#import "FPTextFieldTableViewCell.h"
#import "FPButtonTableViewCell.h"
#import "FPTextViewTableViewCell.h"
#import "FCTextFieldTableViewCell.h"

@interface CloudHeight () {
    
}

@property (nonatomic, retain) NSString *resultString;

@end

@implementation CloudHeight

@synthesize tiltField;
@synthesize distField;
@synthesize resultField;
@synthesize resultString;

- (void)backgroundTap:(id)sender {
	[tiltField resignFirstResponder];
	[distField resignFirstResponder];
}

- (void)textFieldDoneEditting:(id)sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==tiltField) {
		[distField becomeFirstResponder];
	} else if (sender==distField){
		[distField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (void)doCalc:(id)sender {
	[self backgroundTap:sender];
	if ([tiltField.text length]<1 || [distField.text length]<1) 
		return;
	double tilt=[tiltField.text doubleValue];
	double dist=[distField.text doubleValue];
	if(tilt<-89 || tilt >89) {
		resultField.text=@"'tilt angle' error!";
        
        self.resultString=resultField.text;
        [self.tableView reloadData];
		
        return;
	}
	NSMutableString *resultStr;
	resultStr=[[NSMutableString alloc] initWithCapacity:128];
	[resultStr setString:@""];
	[resultStr appendFormat:@"Tilt Angle:  \t%1.2f °\n",tilt];
	[resultStr appendFormat:@"Distance: \t\t%1.1f NM\n",dist];
	tilt=sin(tilt*M_PI/180);
	dist=dist*1852*tilt;
	[resultStr appendFormat:@"Cloud top - Current altitude\n\t\t=%1.2f M\n\t\t=%1.1f ft\n",dist,dist/0.3048];
	//[resultStr appendFormat:@"\n%d",[resultStr length]]; //109
	resultField.text=resultStr;
	[resultStr release];	
	tiltField.text=@"";	
	distField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=6) 
		return NO;
	if (textField==tiltField) {
		if (range.location==0 && [string isEqualToString: @"-"])
			return YES;
	}	
		if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound) {
			return YES;
		}
	
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
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
    [super viewDidLoad];
    
    self.resultField = [[[UITextView alloc] init] autorelease];
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
	self.tiltField=nil;
	self.distField=nil;
	self.resultField=nil;
    self.resultString = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	[tiltField release];
	[distField release];
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
        
        if (indexPath.row == 0) {
            cell.customLabel.text = @"Radar antenna tilt";
            
            cell.customTextField.placeholder = @"degree";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
            self.tiltField = cell.customTextField;
            [tiltField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            return cell;
        } else {
            cell.customLabel.text = @"Distance";
            
            cell.customTextField.placeholder = @"NM";
            cell.customTextField.delegate = self;
            
            self.distField = cell.customTextField;
            [distField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
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
