//
//  Turn.m
//  FlightCalc
//
//  Created by apple on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Turn.h"

@interface Turn (){
    
}
@property(nonatomic,retain)NSString* resultString;
@end

@implementation Turn
@synthesize bankField;
@synthesize tasField;
@synthesize resultField;

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
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"Bank angle";
                cell.textField.placeholder=@"Bank angle";
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.delegate = self;
                
                self.bankField = cell.textField;
                [bankField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                break;
            case 1:
                cell.textLabel.text=@"TAS (KTS)";
                cell.textField.placeholder=@"TAS (KTS)";
                cell.textField.delegate = self;
                
                self.tasField = cell.textField;
                [tasField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
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
	[bankField resignFirstResponder];
	[tasField resignFirstResponder];
}
-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==bankField) {
		[tasField becomeFirstResponder];
	} else if (sender==tasField){
		[tasField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (textField==bankField) {
		if (range.location>=3)
			return NO;
	} else if (range.location>=6) 
		return NO;
	/*
	if (textField==altField) {
		if (range.location==0 && [string isEqualToString: @"-"])
			return YES;
	}
	
	if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound) {
		return YES;
	}
	*/
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

- (IBAction) doCalc:(id) sender {
    
	[self backgroundTap:sender];
	if ([bankField.text length]<1 || [tasField.text length]<1) 
		return;
	double bank=[bankField.text doubleValue];
	double spd=[tasField.text doubleValue];
	if (bank<1 || bank>89) {
		resultField.text=@"Bank angle error!";
        self.resultString=resultField.text;
        [self.tableView reloadData];
		return;
	}
	NSString *result=[NSString stringWithFormat:@"Bank Angle: \t%1.0f °\n",bank];
	result=[result stringByAppendingFormat:@"\tTAS: \t%1.0f kts\n",spd];
	result=[result stringByAppendingFormat:@"Load Factor: \t%1.3f g\n",1/cos(bank*M_PI/180)];
	bank=tan(bank*M_PI/180);
	double radius=spd*spd*1852*1852/3600/3600/9.80065/bank; // 9.80065=1G
	result=[result stringByAppendingFormat:@"Turn Radius: \t%1.1f M\n\t\t\t%1.2f nm\n",radius,radius/1852];
	result=[result stringByAppendingFormat:@"Turn Diameter: %1.1f M\n\t\t\t%1.2f nm\n",radius*2,radius*2/1852];
	radius=2*M_PI*radius/(spd*1852/3600);
	resultField.text=[result stringByAppendingFormat:@"Time of 360° turn: %1.0f' %04.1f\"\n",floor(radius/60),radius-floor(radius/60)*60];	
	
	bankField.text=@"";
	tasField.text=@"";
    
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
	myFrame=[bankField frame];
	myFrame.size.height+=6;
	bankField.frame=myFrame;
	myFrame=[tasField frame];
	myFrame.size.height+=6;
	tasField.frame=myFrame;
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
	self.bankField=nil;
	self.tasField=nil;
	self.resultField=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[bankField release];
	[tasField release];
	[resultField release];
    [resultString release];
    [super dealloc];
}

@end
