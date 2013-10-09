//
//  Wind.m
//  FlightCalc
//
//  Created by apple on 11-6-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Wind.h"

@interface Wind (){
    
    
}
@property(nonatomic,retain)NSString* resultString;
@end

@implementation Wind
@synthesize fromField;
@synthesize spdField;
@synthesize hdgField;
@synthesize resultField;
@synthesize spdButton;

@synthesize resultString;

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
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"Wind from";
                cell.textField.placeholder=@"Wind from";
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyNext;
                
                self.fromField = cell.textField;
                [fromField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                break;
            case 1:
                cell.textLabel.text=@"Wind speed";
                
                cell.textField.placeholder=@"kts";
                if ([spdButton.titleLabel.text isEqualToString:@"m/s"]) {
                    cell.textField.placeholder=@"m/s";
                }
                
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyNext;
               
                cell.accessoryView=spdButton;
                
                self.spdField = cell.textField;
                [spdField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                break;
            case 2:
                cell.textLabel.text=@"Heading";
                cell.textField.placeholder=@"Heading";
                cell.textField.delegate = self;
                
                self.hdgField = cell.textField;
                [hdgField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
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
	[fromField resignFirstResponder];
	[spdField resignFirstResponder];
	[hdgField resignFirstResponder];
}
-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==fromField) {
		[spdField becomeFirstResponder];
	} else if (sender==spdField){
		[hdgField becomeFirstResponder];
	} else if (sender==hdgField){
		[hdgField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (textField==spdField) {
		if (range.location>=6)
			return NO;
	} else if (range.location>=3) 
		return NO;
	/*
	 if (range.location==0 && [string isEqualToString: @"-"])
	 return YES;
	 */
	 
	 if (textField==spdField) 
	 if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound) {
	 return YES;
	 }
	 
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

-(IBAction) switchButton:(id) sender{
    
    
    
	if ([spdButton.titleLabel.text compare: @"Knots"]==NSOrderedSame) {
		[spdButton setTitle:@"m/s" forState: UIControlStateNormal];
		[spdButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		spdField.placeholder=@"m/s";
        
        
	} else {
		[spdButton setTitle:@"Knots" forState: UIControlStateNormal];
		[spdButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		spdField.placeholder=@"kts";
	}
    
     StringInputTableViewCell* cell=(StringInputTableViewCell*) [ self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    
    cell.textField.placeholder=spdField.placeholder;
	[self backgroundTap:sender];
}

- (IBAction) doCalc:(id) sender {
    
	[self backgroundTap:sender];	
	if ([fromField.text length]<1 || [spdField.text length]<1 || [hdgField.text length]<1) 
		return;
	double frm=[fromField.text doubleValue];
	double spd=[spdField.text doubleValue];
	double hdg=[hdgField.text doubleValue];
	if (frm<0 || frm >360 || hdg<0 || hdg>360) {
		resultField.text=@"'Wind from' or 'heading' error!";
        self.resultString=resultField.text;
        [self.tableView reloadData];
		return;
	}
	if ([spdButton.titleLabel.text compare: @"m/s"]==NSOrderedSame)
		spd=(spd/1852)*3600; // m/s -> kts
	NSString *result=[NSString stringWithFormat:@"Heading: \t%1.0f °\n",hdg];
	result=[result stringByAppendingFormat:@"Wind: %1.0f °/ %1.1f kts\n",frm,spd];
	result=[result stringByAppendingFormat:@"\t %1.0f °/ %1.1f m/s\n",frm,spd*1852/3600];
	hdg=(hdg-frm)*M_PI/180;
	result=[result stringByAppendingFormat:@"Cross wind:\n\t %1.1f kts, %1.1f m/s\n",sin(hdg)*spd,sin(hdg)*spd*1852/3600];
	resultField.text=[result stringByAppendingFormat:@"Head wind:\n\t %1.1f kts, %1.1f m/s\n",cos(hdg)*spd,cos(hdg)*spd*1852/3600];
	
	fromField.text=@"";
	spdField.text=@"";	
	hdgField.text=@"";
    
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
	myFrame=[fromField frame];
	myFrame.size.height+=6;
	fromField.frame=myFrame;
	myFrame=[hdgField frame];
	myFrame.size.height+=6;
	hdgField.frame=myFrame;
	myFrame=[spdField frame];
	myFrame.size.height+=6;
	spdField.frame=myFrame;	
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
	self.fromField=nil;
	self.spdField=nil;
	self.hdgField=nil;
	self.spdButton=nil;
	self.resultField=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[fromField release];
	[spdField release];
	[hdgField release];
	[spdButton release];
	[resultField release];
    [resultString release];
    [super dealloc];
}


@end
