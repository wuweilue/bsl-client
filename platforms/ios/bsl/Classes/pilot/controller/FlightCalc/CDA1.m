//
//  CDA1.m
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDA1.h"
#import "FCTextFieldTableViewCell.h"
#import "FPButtonTableViewCell.h"
#import "FPTextViewTableViewCell.h"

@interface CDA1 () {
    
}

@property (nonatomic, retain) NSString *resultString;

@end

@implementation CDA1

@synthesize fromField;
@synthesize fafField;
@synthesize dmeField;
@synthesize angButton;
@synthesize angleField;
@synthesize spdField;
@synthesize mdaField;
@synthesize resultField;
@synthesize resultString;

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
//	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//		myTableView.scrollEnabled=NO;
//	}
    [super viewDidLoad];
    
    self.fromField = [[[UITextField alloc] init] autorelease];    
    self.fafField = [[[UITextField alloc] init] autorelease];    
    self.dmeField = [[[UITextField alloc] init] autorelease];    
    self.angleField = [[[UITextField alloc] init] autorelease];    
    self.mdaField = [[[UITextField alloc] init] autorelease];    
    self.spdField = [[[UITextField alloc] init] autorelease];
    
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
    
    self.fromField = nil;
    self.fafField = nil;
    self.dmeField = nil;
    self.angButton = nil;
    self.angleField = nil;
    self.spdField = nil;
    self.mdaField = nil;
    self.resultField = nil;
    self.resultString = nil;
    
    [super viewDidUnload];
}

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

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.section == 2) {
        CGSize size = [self.resultString sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.tableViewWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height<44) {
            return 44;
        }
        return size.height;
    }
	return 44;
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"FCTextFieldTableViewCell";
        FCTextFieldTableViewCell *cell = (FCTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [FCTextFieldTableViewCell getInstance];
        } else {
            switch (indexPath.row) {
                case 0:
                    cell.customTextField.text = fromField.text;
                    break;
                case 1:
                    cell.customTextField.text = fafField.text;
                    break;
                case 2:
                    cell.customTextField.text = dmeField.text;
                    break;
                case 3:
                    cell.customTextField.text = angleField.text;
                    break;
                case 4:
                    cell.customTextField.text = mdaField.text;
                    break;
                case 5:
                    cell.customTextField.text = spdField.text;
                    break;
                    
                default:
                    break;
            }
        }
       
        if (indexPath.row == 0) {
            cell.customLabel.text = @"Start descent altitude(ft)";
            
            cell.customTextField.placeholder = @"feet";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
            return cell;
        } else if (indexPath.row == 1) {
            cell.customLabel.text = @"FAF point altitude(ft)";
            
            cell.customTextField.placeholder = @"feet";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
            return cell;
        } else if (indexPath.row == 2) {
            cell.customLabel.text = @"FAF point DME(nm)";
            
            cell.customTextField.placeholder = @"nm";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
            return cell;
        } else if (indexPath.row == 3) {
            cell.customLabel.numberOfLines = 0;
            
            cell.customLabel.text = @"Descent Angle (degree) or grads(%)";
            if (device_Type == UIUserInterfaceIdiomPhone) {
                cell.customLabel.text = @"Descent Angle\n(degree) or grads(%)";
            }
            
            cell.customTextField.placeholder = @"%";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
            angleField = cell.customTextField;
            
            cell.accessoryView = self.angButton;
            
            [self.angButton addTarget:self action:@selector(angleButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        } else if (indexPath.row == 4) {
            cell.customLabel.text = @"MDA(H)(Feet)";
            
            cell.customTextField.placeholder = @"Optional";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
            return cell;
        } else {
            cell.customLabel.text = @"Vapp speed (knots)";
            
            cell.customTextField.placeholder = @"Optional";
            cell.customTextField.delegate = self;
            
//            [cell.customTextField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            cell.customTextField.tag = indexPath.row;
            
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
/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//if (! myCell) {
	//	return;
	//}
	//NSSet *mytouches=[event touchesForView:(UIScrollView *)myCell];
	//if ([mytouches count]>0) {
		myTableView.scrollEnabled=NO;
	//}
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	myTableView.scrollEnabled=YES;
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	myTableView.scrollEnabled=YES;
}
 */

- (IBAction) backgroundTap:(id) sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (!firstResponder) {
        [fromField becomeFirstResponder];
    }
    [keyWindow endEditing:YES]; // 关闭键盘
//	[fromField resignFirstResponder];
//	[fafField resignFirstResponder];
//	[dmeField resignFirstResponder];
//	[angleField resignFirstResponder];
//	[spdField resignFirstResponder];
//	[mdaField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==fromField) {
		[fafField becomeFirstResponder];
	} else if (sender==fafField){
		[dmeField becomeFirstResponder];
	} else if (sender==dmeField){
		[angleField becomeFirstResponder];
	} else if (sender==angleField){
		[mdaField becomeFirstResponder];
	} else if (sender==mdaField){
		[spdField becomeFirstResponder];
	} else if (sender==spdField){
		[spdField resignFirstResponder];
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
//    if (textField==dmeField) {
    if (textField.tag==2) {
        if (range.location==0 && [string isEqualToString: @"-"])
            return YES;
    }
//	if (textField==dmeField || textField==angleField) {
    if (textField.tag==2 || textField.tag==3) {
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

-(IBAction) angleButton:(id) sender{
	if ([angButton.titleLabel.text compare: @"Angle"]==NSOrderedSame) {
		[angButton setTitle:@"Grads" forState: UIControlStateNormal];
		[angButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		angleField.placeholder=@"%";
	} else {
		[angButton setTitle:@"Angle" forState: UIControlStateNormal];
		[angButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		angleField.placeholder=@" °";
	}
	[self backgroundTap:sender];
	//[angButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	//UIButton.titleLable
}

- (IBAction) doCalc:(id) sender {
	[self backgroundTap:sender];
	if ([fromField.text length]<1
		|| [fafField.text length]<1
		|| [dmeField.text length]<1
		|| [angleField.text length]<1 )
		return;
	BOOL isangle=NO;
	if ([angButton.titleLabel.text compare: @"Angle"]==NSOrderedSame)
		isangle=YES;
	double startH=[fromField.text doubleValue];
	double fafH=[fafField.text doubleValue];
	double dme=[dmeField.text doubleValue];
	double spd=[spdField.text doubleValue];
	double mda=[mdaField.text doubleValue];
	double angle=[angleField.text doubleValue];
	double grads,mda_dme;
	
	if(isangle) {
		if (angle>=90) {
			resultField.text=@"Angle >= 90 is invaild!\n";
            
            self.resultString=resultField.text;
            [self.tableView reloadData];
            
			return;
		}
		grads=tan(angle*M_PI/180.0);
	} else {
		grads=angle/100.0;
		angle=atan(grads)*180.0/M_PI;
	}
	NSMutableString *resultStr;
	resultStr=[[NSMutableString alloc] initWithCapacity:256];
	[resultStr setString:@""];
	[resultStr appendFormat:@"From altitude: \t%1.0f feet.\n",startH];
	[resultStr appendFormat:@"FAF altitude: \t%1.0f feet.\n",fafH]; //°C
	[resultStr appendFormat:@"FAF DME: \t%1.0f NM.\n",dme]; //°C
	[resultStr appendFormat:@"Descent grads:\t%1.2f %%\n",grads*100];
	[resultStr appendFormat:@"Descent angle:\t%1.2f °\n",angle];
	mda_dme=-999999;
    if(mda>0){
        mda_dme=dme+(mda-fafH)/grads/1852*0.3048;
        [resultStr appendFormat:@"VDP: %1.0f ft, %1.2f nm.\n",mda,mda_dme];
    }
    if (spd>0) {
		angle=sin(atan(grads))*spd;
		angle=angle*1852/0.3048/60;
		[resultStr appendFormat:@"When speed at %1.0f kts,\n\tV/S:%1.0f feet/min.\n",spd,angle];
	}
	angle=(startH-fafH)*0.3048/1852/grads+dme;
	[resultStr appendFormat:@"Descent at DME: %1.2f NM.\n",angle];
	[resultStr appendFormat:@"------------------------------------\n"];
	[resultStr appendFormat:@"DME[NM] \t   altitude[feet]\n"];
	int i;
	for (i=angle+3; i>-20; i--) {
		angle=(i-dme)*grads*1852/0.3048+fafH;
		if (angle<-200) break;
        if(mda_dme>i){
            [resultStr appendFormat:@"%1.2f \t%1.0f (%1.1fM)\n",mda_dme,mda,mda*0.3048];
            mda_dme=-999999;
        }
		[resultStr appendFormat:@"%3d\t\t%1.0f (%1.1fM)\n",i,angle,angle*0.3048];
	}
	[resultStr appendFormat:@"------------------------------------"];
	
	
	//[resultStr appendFormat:@"\n%d\n\n\n",[resultStr length]]; //756
	resultField.text=resultStr;
	[resultStr release];
    
	fromField.text=@"";
	fafField.text=@"";
	dmeField.text=@"";
	angleField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
    
}

- (void)dealloc {
	[fromField release];
	[fafField release];
	[dmeField release];
	[angButton release];
	[angleField release];
	[spdField release];
    [mdaField release];
	[resultField release];
    [resultString release];
    [super dealloc];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (device_Type == UIUserInterfaceIdiomPhone) {
        if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5) {
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
            [UIView setAnimationDuration:0.30f];
            self.view.frame = CGRectMake(0.0f, -142, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            fromField.text = textField.text;
            break;
        case 1:
            fafField.text = textField.text;
            break;
        case 2:
            dmeField.text = textField.text;
            break;
        case 3:
            angleField.text = textField.text;
            break;
        case 4:
            mdaField.text = textField.text;
            break;
        case 5:
            spdField.text = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
    FCTextFieldTableViewCell *cell = (FCTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    if (textField.tag == 5) {
        [self doCalc:nil];
    } else {
        [cell.customTextField becomeFirstResponder];
    }
    return NO;
}

@end
