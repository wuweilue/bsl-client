//
//  Fuel.m
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fuel.h"

@implementation Fuel

@synthesize sgField;
@synthesize ltField;
@synthesize usField;
@synthesize ukField;
@synthesize kgField;
@synthesize lbField;
@synthesize scrollView;
@synthesize sgButton;

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 6;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierCale = @"CaleCell";
    
    if (indexPath.section==0) {
        
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell=[[[StringInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        } else {
            switch (indexPath.row) {
                case 0:
                    cell.textField.text = sgField.text;
                    break;
                case 1:
                    cell.textField.text = ltField.text;
                    break;
                case 2:
                    cell.textField.text = usField.text;
                    break;
                case 3:
                    cell.textField.text = ukField.text;
                    break;
                case 4:
                    cell.textField.text = kgField.text;
                    break;
                case 5:
                    cell.textField.text = lbField.text;
                    break;
                    
                default:
                    break;
            }
        }

        cell.tag=indexPath.row;
        
        cell.textField.tag = indexPath.row;
        
        if (indexPath.row==0) {
            
            cell.textLabel.text=@"S.G.";
            cell.textField.placeholder=@"Density";
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.delegate = self;
            
//            [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.accessoryView=sgButton;
            
        } else {
            switch (indexPath.row) {
                case 1:
                    cell.textLabel.text=@"Liter";
                    cell.textField.placeholder=@"Liter";
                    cell.textField.delegate = self;
                    
//                    [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    
                    break;
                case 2:
                    cell.textLabel.text=@"Gallon[us]";
                    cell.textField.placeholder=@"Gallon[us]";
                    cell.textField.delegate = self;
                    
//                    [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    
                    break;
                case 3:
                    cell.textLabel.text=@"Gallon[uk]";
                    cell.textField.placeholder=@"Gallon[uk]";
                    cell.textField.delegate = self;
                    
//                    [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    
                    break;
                case 4:
                    cell.textLabel.text=@"KG";
                    cell.textField.placeholder=@"KG";
                    cell.textField.delegate = self;
                    
//                    [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    
                    break;
                case 5:
                    cell.textLabel.text=@"LB";
                    cell.textField.placeholder=@"LB";
                    cell.textField.delegate = self;
                    
//                    [cell.textField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    
                    break;
                default:
                    break;
            }
        }
        
        return cell;
    }
    
    if (indexPath.section==1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCale];
        
        if (!cell) {
            
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierCale]autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIButton* calcButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [calcButton addTarget:self action:@selector(doCalc:) forControlEvents:UIControlEventTouchUpInside];
            [calcButton setTitle:@"CALC" forState:UIControlStateNormal];
            [calcButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            [calcButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|
             UIViewAutoresizingFlexibleWidth ];
            calcButton.frame=cell.bounds;
            UIImage *image = nil;
            if (device_Type == UIUserInterfaceIdiomPhone) {
                image = [UIImage imageNamed:@"Button_Orange_Phone.png"];

            } else {
                image = [[UIImage imageNamed:@"Button_Orange_Pad.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
            }
            
            [calcButton setBackgroundImage:image forState:UIControlStateNormal];
            
            [cell.contentView addSubview:calcButton];
            
        }

        return cell;
    }
    
    return nil;
    
}

- (IBAction) backgroundTap:(id) sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (!firstResponder) {
        [sgField becomeFirstResponder];
    }
    [keyWindow endEditing:YES]; // 关闭键盘
//	[sgField resignFirstResponder];
//	[ltField resignFirstResponder];
//	[usField resignFirstResponder];
//	[ukField resignFirstResponder];
//	[kgField resignFirstResponder];
//	[lbField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==sgField) {
		[ltField becomeFirstResponder];
	} else {
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
//	if (textField==sgField) {
    if (textField.tag==0) {
		if (range.location>=8)
			return NO;
	} else if (range.location>=20) 
		return NO;
//	if (textField==sgField) {
    if (textField.tag==0) {
		//if (range.location==0 && [string isEqualToString: @"-"])
		//	return YES;
		if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound) {
			return YES;
		}
	}	
	
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

- (IBAction) changesg:(id) sender {
 	if ([sgButton.titleLabel.text compare: @"kg/liter"]==NSOrderedSame) {
		[sgButton setTitle:@"lb/USgal" forState: UIControlStateNormal];
		[sgButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	} else {
		[sgButton setTitle:@"kg/liter" forState: UIControlStateNormal];
		[sgButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
	[self backgroundTap:sender];
}

- (IBAction) doCalc:(id) sender {
	[self backgroundTap:sender];
	double sg=0;
	if ([sgField.text length]>0) {
		sg=[sgField.text doubleValue];
	}
	double v1;
    
 	if ([sgButton.titleLabel.text compare: @"lb/USgal"]==NSOrderedSame) {
        if ([ltField.text length]>0) {
            v1=[ltField.text doubleValue];
            //1gallon[US liquild]=3.785411784liter
            usField.text=[NSString stringWithFormat:@"%1.1f",v1/3.785411784];
            //1gallon[UK]=4.54609liter ; 1 gallon=4 quart
            ukField.text=[NSString stringWithFormat:@"%1.1f",v1*0.219969];
            if (sg>0) {
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*sg/3.785411784];
                //1 lb=0.45359237kg
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*sg*0.45359237/3.785411784];
            }
        } else	if ([usField.text length]>0) {
            v1=[usField.text doubleValue];
            ltField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784];
            ukField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784/4.54609];
            if (sg>0) {
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*sg];
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*sg*0.45359237];
            }
        } else	if ([ukField.text length]>0) {
            v1=[ukField.text doubleValue];
            ltField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609];
            usField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609/3.785411784];
            if (sg>0) {
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609*sg/3.785411784];
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609*sg*0.45359237/3.785411784];
            }
        } else if ([kgField.text length]>0) {
            v1=[kgField.text doubleValue];
            lbField.text=[NSString stringWithFormat:@"%1.1f",v1/0.45359237];
            if (sg>0) {
                usField.text=[NSString stringWithFormat:@"%1.1f",v1/sg/0.45359237];
                ltField.text=[NSString stringWithFormat:@"%1.1f",v1/sg/0.45359237*3.785411784];
                ukField.text=[NSString stringWithFormat:@"%1.1f",v1/sg/0.45359237*3.785411784/4.54609];
            }
        } else if ([lbField.text length]>0) {
            v1=[lbField.text doubleValue];
            kgField.text=[NSString stringWithFormat:@"%1.1f",v1*0.45359237];
            if (sg>0) {
                usField.text=[NSString stringWithFormat:@"%1.1f",v1/sg];
                ltField.text=[NSString stringWithFormat:@"%1.1f",v1/sg*3.785411784];
                ukField.text=[NSString stringWithFormat:@"%1.1f",v1/sg*3.785411784/4.54609];
            }
        }
    } else {
        if ([ltField.text length]>0) {
            v1=[ltField.text doubleValue];
            //1gallon[US liquild]=3.785411784liter
            usField.text=[NSString stringWithFormat:@"%1.1f",v1/3.785411784];
            //1gallon[UK]=4.54609liter ; 1 gallon=4 quart
            ukField.text=[NSString stringWithFormat:@"%1.1f",v1*0.219969];
            if (sg>0) {
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*sg];
                //1 lb=0.45359237kg
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*sg/0.45359237];
            }
        } else	if ([usField.text length]>0) {
            v1=[usField.text doubleValue];
            ltField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784];
            ukField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784/4.54609];
            if (sg>0) {
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784*sg];
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*3.785411784*sg/0.45359237];
            }
        } else	if ([ukField.text length]>0) {
            v1=[ukField.text doubleValue];
            ltField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609];
            usField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609/3.785411784];
            if (sg>0) {
                kgField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609*sg];
                lbField.text=[NSString stringWithFormat:@"%1.1f",v1*4.54609*sg/0.45359237];
            }
        } else if ([kgField.text length]>0) {
            v1=[kgField.text doubleValue];
            lbField.text=[NSString stringWithFormat:@"%1.1f",v1/0.45359237];
            if (sg>0) {
                ltField.text=[NSString stringWithFormat:@"%1.1f",v1/sg];
                usField.text=[NSString stringWithFormat:@"%1.1f",v1/sg/3.785411784];
                ukField.text=[NSString stringWithFormat:@"%1.1f",v1/sg/4.54609];
            }
        } else if ([lbField.text length]>0) {
            v1=[lbField.text doubleValue];
            kgField.text=[NSString stringWithFormat:@"%1.1f",v1*0.45359237];
            if (sg>0) {
                ltField.text=[NSString stringWithFormat:@"%1.1f",v1*0.45359237/sg];
                usField.text=[NSString stringWithFormat:@"%1.1f",v1*0.45359237/sg/3.785411784];
                ukField.text=[NSString stringWithFormat:@"%1.1f",v1*0.45359237/sg/4.54609];
            }
        }
    }
    
    [self.tableView reloadData];
	
}

- (IBAction) doClr:(id) sender {
    [self backgroundTap:sender];
	sgField.text=@"";	
	ltField.text=@"";	
	usField.text=@"";	
	ukField.text=@"";	
	kgField.text=@"";	
	lbField.text=@"";
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

    [super viewDidLoad];
    
    //scrollView.delegate=self;
	CGRect myFrame;
	myFrame=[sgField frame];
	myFrame.size.height+=6;
	sgField.frame=myFrame;
	myFrame=[ltField frame];
	myFrame.size.height+=6;
	ltField.frame=myFrame;
	myFrame=[usField frame];
	myFrame.size.height+=6;
	usField.frame=myFrame;
	myFrame=[ukField frame];
	myFrame.size.height+=6;
	ukField.frame=myFrame;
	myFrame=[kgField frame];
	myFrame.size.height+=6;
	kgField.frame=myFrame;
	myFrame=[lbField frame];
	myFrame.size.height+=6;
	lbField.frame=myFrame;
//	[self registerForKeyBoardNotifications];
    
    UIImage *image = [UIImage imageNamed:@"RightButtonItem"];
    UIButton *rightButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)] autorelease];
    
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton setTitle:@"CLR" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [rightButton.titleLabel setShadowColor:[UIColor grayColor]];
    [rightButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [rightButton addTarget:self action:@selector(doClr:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *clButton = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    
    self.navigationItem.rightBarButtonItem = clButton;
    
    
//    [ self.tableView setFrame :CGRectMake(0, 54, self.view.frame.size.width , self.view.frame.size.height-54)];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//-(void)registerForKeyBoardNotifications{
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
//	keyboardShown=NO;
//}

//-(void) KeyboardWasShown:(NSNotification *)aNotification{
//	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) return;
//	if (keyboardShown) {
//		return;
//	}
//	if (activeField!=kgField && activeField!=lbField) {
//		return;
//	}
//	NSDictionary *info=[aNotification userInfo];
//	//get the size of the keyboard.
//	NSValue *aValue=[info objectForKey:UIKeyboardBoundsUserInfoKey];
//	CGSize keyboardSize=[aValue CGRectValue].size;
//	//resize the scroll view
//	CGRect viewFrame=[scrollView frame];
//	viewFrame.size.height-=keyboardSize.height;
//	scrollView.frame=viewFrame;
//	//scroll the active text field into view
//	CGRect textFieldRect=[activeField frame];
//	[scrollView scrollRectToVisible:textFieldRect animated:YES];
//	
//	keyboardShown=YES;
//}

//-(void)KeyboardWasHidden:(NSNotification *)aNotification {
//	if (!keyboardShown) return;
//	NSDictionary *info=[aNotification userInfo];
//	//get the size of the keyboard
//	NSValue *aValue=[info objectForKey:UIKeyboardBoundsUserInfoKey];
//	CGSize keyboardSize=[aValue CGRectValue].size;
//	//reset the height of the scroll view to its original value
//	CGRect viewFrame=[scrollView frame];
//	viewFrame.size.height+=keyboardSize.height;
//	scrollView.frame=viewFrame;
//	keyboardShown=NO;
//}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	activeField=textField;
    if (device_Type == UIUserInterfaceIdiomPhone) {
        if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5) {
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
            [UIView setAnimationDuration:0.30f];
            self.view.frame = CGRectMake(0.0f, -142, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	activeField=nil;
    switch (textField.tag) {
        case 0:
            sgField.text = textField.text;
            break;
        case 1:
            ltField.text = textField.text;
            break;
        case 2:
            usField.text = textField.text;
            break;
        case 3:
            ukField.text = textField.text;
            break;
        case 4:
            kgField.text = textField.text;
            break;
        case 5:
            lbField.text = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.sgField=nil;
	self.ltField=nil;
	self.usField=nil;
	self.ukField=nil;
	self.kgField=nil;
	self.lbField=nil;
	self.scrollView=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[sgField release];
	[ltField release];
	[usField release];
	[ukField release];
	[kgField release];
	[lbField release];
	[scrollView release];
    [super dealloc];
}
/*
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return  self.scrollView;
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
    StringInputTableViewCell *cell = (StringInputTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    if (textField.tag == 0) {
        [cell.textField becomeFirstResponder];
    } else {
        [self doCalc:nil];
    }
    return NO;
}

@end
