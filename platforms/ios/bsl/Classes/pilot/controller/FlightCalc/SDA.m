//
//  SDA.m
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDA.h"


static double last_h=-1,last_dme=-1;

@interface SDA (){
    
   
    
}

@property(nonatomic,retain)NSString* altString;
@property(nonatomic,retain)NSString* dmeString;
@property(nonatomic,retain)NSString* spdString;
@property(nonatomic,retain)NSString* reslustString;
@property(nonatomic,retain)UIButton* calcButton;
@property(nonatomic,retain)UIButton* cleanButton;

@end

@implementation SDA
@synthesize altField;
@synthesize dmeField;
@synthesize spdField;
@synthesize resultField;
@synthesize clrButton;
@synthesize calcButton;
@synthesize cleanButton;



@synthesize reslustString;
@synthesize altString;
@synthesize dmeString;
@synthesize spdString;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierCale = @"CaleCell";
    
    if (indexPath.section==2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"]autorelease];
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"结果：";
        
        if (self.reslustString && ![self.reslustString isEqualToString:@""]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.reslustString];
        }
        
        cell.textLabel.numberOfLines=0;
        return cell;

    }
    
    if (indexPath.section==0) {
        
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell=[[[StringInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        } else {
            switch (indexPath.row) {
                case 0:
                    cell.textField.text = altField.text;
                    break;
                case 1:
                    cell.textField.text = dmeField.text;
                    break;
                case 2:
                    cell.textField.text = spdField.text;
                    break;
                    
                default:
                    break;
            }
        }
        
        cell.tag = indexPath.row;
        
        cell.textField.tag = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"Altitude (feet)";
                cell.textField.placeholder=@"feet";
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyNext;
                
//                self.altField = cell.textField;
//                [altField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                break;
            case 1:
                cell.textLabel.text=@"DME (Nautical Mile)";
                cell.textField.placeholder=@"nm";
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyNext;
                
//                self.dmeField = cell.textField;
//                [dmeField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                break;
            case 2:
                cell.textLabel.text=@"Speed(Knots)";
                cell.textField.placeholder=@"optional";
                cell.textField.delegate = self;
//                cell.textField.returnKeyType = UIReturnKeyDone;
                
//                self.spdField = cell.textField;
//                [spdField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                break;
            default:
                break;
        }
        
        return cell;
    }
    
    if (indexPath.section==1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCale];
        
        if (!cell) {
            
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierCale]autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            self.calcButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [calcButton addTarget:self action:@selector(doCalc:) forControlEvents:UIControlEventTouchUpInside];
            [calcButton setTitle:@"CALC" forState:UIControlStateNormal];
            [calcButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            [calcButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|
             UIViewAutoresizingFlexibleWidth];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        
        CGSize size = [self.reslustString sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.tableViewWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height<44) {
             return 44;
        }
        return size.height;
 
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction) backgroundTap:(id) sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (!firstResponder) {
        [resultField becomeFirstResponder];
    }
    [keyWindow endEditing:YES]; // 关闭键盘
//	[altField resignFirstResponder];
//	[dmeField resignFirstResponder];
//	[spdField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==altField) {
		[dmeField becomeFirstResponder];
	} else if (sender==dmeField){
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
//	if (textField==dmeField) {
    if (textField.tag==1) {
	if (range.location==0 && [string isEqualToString: @"-"])
		return YES;
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

- (IBAction) doCalc:(id) sender {
    
	[self backgroundTap:sender];
	if ([altField.text length]<1 || [dmeField.text length]<1) 
		return;
	double h=[altField.text doubleValue];
	double dme=[dmeField.text doubleValue];
	double spd,tmp;
	NSString *resultStr=@"";
	//resultStr=[resultStr stringByAppendingFormat:@"%d",234234];
	if(!(last_h==-1 && last_dme==-1)) {
		tmp=(h-last_h)*0.3048/((dme-last_dme)*1852);
		resultStr=[resultStr stringByAppendingFormat:@"Grads:\t%1.2f %%\n",tmp*100];
		if (labs(tmp)>1) spd=90; 
			else spd=asin(tmp)*180.0/M_PI;
		resultStr=[resultStr stringByAppendingFormat:@"Angle:\t%1.2f °\n",spd];
		spd=[spdField.text doubleValue];
		if (spd>0) {
			spd=spd*tmp*1852.0/0.3048/60.0;
			resultStr=[resultStr stringByAppendingFormat:@"V/S:\t\t%1.1f ft/min\n",spd];
		}
	}
	last_h=h; last_dme=dme;
	resultStr=[NSString stringWithFormat:@"----- %1.0f ft, %1.1f nm -----\n%@%@"
			   ,last_h,last_dme,resultStr,resultField.text];
	
	resultField.text=resultStr;
	altField.text=@"";	
	dmeField.text=@"";
    self.reslustString=resultStr;
    [self.tableView reloadData];
}

- (IBAction) doClr:(id) sender {
    [self backgroundTap:sender];
    
	altField.text=@"";	
	dmeField.text=@"";	
	spdField.text=@"";
	resultField.text=@"";
	last_h=-1;
	last_dme=-1;
    self.reslustString=@"";
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
    
	CGRect myFrame;
	myFrame=[altField frame];
	myFrame.size.height+=6;
	altField.frame=myFrame;
	myFrame=[dmeField frame];
	myFrame.size.height+=6;
	dmeField.frame=myFrame;	
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		myFrame=[resultField frame];
		myFrame.size.width+=200;
		myFrame.size.height+=500;
		resultField.frame=myFrame;
		resultField.font=[UIFont systemFontOfSize:26];
		myFrame=[clrButton frame];
		myFrame.origin.x+=200;
		clrButton.frame=myFrame;
	}	
    
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
	self.altField=nil;
	self.dmeField=nil;
	self.spdField=nil;
	self.resultField=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[altField release];
	[dmeField release];
	[spdField release];
	[resultField release];
    
    [cleanButton release];
    [calcButton release];
    [altString release];
    [dmeString release];
    [spdString release];
    [reslustString release];
    [super dealloc];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            altField.text = textField.text;
            break;
        case 1:
            dmeField.text = textField.text;
            break;
        case 2:
            spdField.text = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
    StringInputTableViewCell *cell = (StringInputTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    if (textField.tag == 2) {
        [self doCalc:nil];
    } else {
        [cell.textField becomeFirstResponder];
    }
    return NO;
}

@end
