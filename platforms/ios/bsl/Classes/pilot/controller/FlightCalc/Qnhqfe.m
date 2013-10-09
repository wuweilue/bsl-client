//
//  Qnhqfe.m
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Qnhqfe.h"


@interface Qnhqfe (){
    
}
@property(nonatomic,retain)NSString* resultString;
@end

@implementation Qnhqfe
@synthesize altField;
@synthesize setField;
@synthesize ftButton;
@synthesize qnhButton;
@synthesize barButton;
@synthesize resultField;


//add by SenchoKong
@synthesize resultString;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
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
        
        if (self.resultString && ![self.resultString isEqualToString:@""]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.resultString];
        }
        
        cell.textLabel.numberOfLines=0;
        return cell;
        
    }
    
    if (indexPath.section==0) {
        
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell=[[[StringInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        }
        
        cell.tag=indexPath.row;
         cell.textLabel.numberOfLines=0;
        switch (indexPath.row) {
            case 0:
                
                if (device_Type == UIUserInterfaceIdiomPad) {
                    cell.textLabel.text=@"Airport Altitude";
                 }else{
                     cell.textLabel.text=@"Airport\nAltitude";
                }
                
                cell.textField.placeholder=@"Feet";
                if ([ftButton.titleLabel.text isEqualToString:@"M"]) {
                    cell.textField.placeholder=@"Metre";
                }
                
                cell.textField.delegate =self;
                cell.textField.returnKeyType = UIReturnKeyNext;
                
                cell.accessoryView=ftButton;
                
                self.altField = cell.textField;
                [altField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                break;
                
            case 1:
                
                if (device_Type == UIUserInterfaceIdiomPad) {
                     cell.textLabel.text=@"Altimeter Setting";
                }else{
                     cell.textLabel.text=@"Altimeter\nSetting";
                }
               
                cell.textField.placeholder=@"Hpa";
                if ([ftButton.titleLabel.text isEqualToString:@"inHg"]) {
                    cell.textField.placeholder=@"inHg";
                }
                
                cell.textField.delegate =self;
                
                cell.accessoryView=self.buttonGroupView;
                
                self.setField = cell.textField;
                [setField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        
        CGSize size = [self.resultString sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.tableViewWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height<44) {
            return 44;
        }
        return size.height;
    }
    return 44;
    
}

- (IBAction) backgroundTap:(id) sender {
	[altField resignFirstResponder];
	[setField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==altField) {
		[setField becomeFirstResponder];
	} else if (sender==setField){
		[setField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=10) 
		return NO;
	if (textField==altField) {
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

-(IBAction) switchButtonFT:(id) sender{
	if ([ftButton.titleLabel.text compare: @"FT"]==NSOrderedSame) {
		[ftButton setTitle:@"M" forState: UIControlStateNormal];
		[ftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		altField.placeholder=@"Metre";
	} else {
		[ftButton setTitle:@"FT" forState: UIControlStateNormal];
		[ftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		altField.placeholder=@"Feet";
	}
	[self backgroundTap:sender];
}
-(IBAction) switchButtonQNH:(id) sender{
	if ([qnhButton.titleLabel.text compare: @"QNH"]==NSOrderedSame) {
		[qnhButton setTitle:@"QFE" forState: UIControlStateNormal];
		[qnhButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	} else {
		[qnhButton setTitle:@"QNH" forState: UIControlStateNormal];
		[qnhButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
	[self backgroundTap:sender];
}
-(IBAction) switchButtonBar:(id) sender{
	if ([barButton.titleLabel.text compare: @"Hpa"]==NSOrderedSame) {
		[barButton setTitle:@"inHg" forState: UIControlStateNormal];
		[barButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		setField.placeholder=@"inHg";
	} else {
		[barButton setTitle:@"Hpa" forState: UIControlStateNormal];
		[barButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		setField.placeholder=@"Hpa";
	}
	[self backgroundTap:sender];
}

- (IBAction) doCalc:(id) sender {
        
	[self backgroundTap:sender];
	if ([altField.text length]<1 || [setField.text length]<1) 
		return;
	double alt=[altField.text doubleValue];
	double set=[setField.text doubleValue];
	if ([ftButton.titleLabel.text compare: @"M"]==NSOrderedSame) 
		alt=alt/0.3048;
	if ([barButton.titleLabel.text compare: @"inHg"]!=NSOrderedSame) 
		set=set/33.8638815789;
	NSString *result=[NSString stringWithFormat:@"Airport Altitude:\n\t%1.0f ft\n\t%1.1f m\n",alt,alt*0.3048];
	if ([qnhButton.titleLabel.text compare: @"QFE"]==NSOrderedSame) {
		result=[result stringByAppendingFormat:@"Altimeter Setting QFE:\n\t%1.2f inHg\n\t%1.2f Hpa\n"
				,set,set*33.8638815789];
		double jh=145442.2*(1-pow(set/29.92126, 0.190261));//pressure altitude at airport
		//if (jh>20000) jh=notavalid;
		double hh=29.92126*pow(-1*((jh-alt)/145442.2-1), 1/0.190261); //qnh inHg
		resultField.text=[result stringByAppendingFormat:@"Altimeter Setting QNH:\n\t%1.2f inHg\n\t%1.2f Hpa"
						  ,hh,hh*33.8638815789];
	} else {
		result=[result stringByAppendingFormat:@"Altimeter Setting QNH:\n\t%1.2f inHg\n\t%1.2f Hpa\n"
				,set,set*33.8638815789];
		double hi=alt+145442.2*(1-pow(set/29.92126,0.19026));//pressure alt at airport
		double jg=29.92126*pow(-1*(hi/145442.2-1), 1/0.190261);//qfe
		//if(jg<13.75) jg=notavaild;
				resultField.text=[result stringByAppendingFormat:@"Altimeter Setting QFE:\n\t%1.2f inHg\n\t%1.2f Hpa"
								  ,jg,jg*33.8638815789];
	}

	altField.text=@"";	
	setField.text=@"";
    
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
    [super viewDidLoad];
	CGRect myFrame;
	myFrame=[altField frame];
	myFrame.size.height+=6;
	altField.frame=myFrame;
	myFrame=[setField frame];
	myFrame.size.height+=6;
	setField.frame=myFrame;
    
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
	self.setField=nil;
	self.ftButton=nil;
	self.qnhButton=nil;
	self.barButton=nil;
	self.resultField=nil;
    [self setButtonGroupView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[altField release];
	[setField release];
	[ftButton release];
	[qnhButton release];
	[barButton release];
	[resultField release];
    [_buttonGroupView release];
    [resultString release];
    [super dealloc];
}


@end
