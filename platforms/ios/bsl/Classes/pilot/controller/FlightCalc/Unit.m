//
//  Unit.m
//  FlightCalc
//
//  Created by apple on 11-6-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Unit.h"

@interface Unit (){
    
    UIPopoverController *popoverController;
    UIToolbar* inputAccessoryView ;
}
@property(nonatomic,retain)NSString* resultString;
@end

@implementation Unit
@synthesize singlePicker;
@synthesize pickerData;
@synthesize doneButton;
@synthesize calcButton;
@synthesize clrButton;
@synthesize selectButton;
@synthesize inputField;
@synthesize resultField;

@synthesize resultString;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierCale = @"CaleCell";
    static NSString *inputCell = @"inputCell";
    
    if (indexPath.section==3) {
        
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
    
    if (indexPath.section==1) {
        
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell=[[[StringInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        }
        
        cell.tag=indexPath.row;
        
        switch (indexPath.row) {
            case 0:

                cell.textField.delegate = self;
                
                self.inputField = cell.textField;
                [inputField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                NSInteger row=[singlePicker selectedRowInComponent:0];
                switch (row) {
                    case 0:
                        inputField.placeholder=@"metre";
                        break;
                    case 1:
                        inputField.placeholder=@"feet";
                        break;
                    case 2:
                        inputField.placeholder=@"ft/min";
                        break;
                    case 3:
                        inputField.placeholder=@"m/s";
                        break;
                    case 4:
                        inputField.placeholder=@"° degrees";
                        break;
                    case 5:
                        inputField.placeholder=@"% grads";
                        break;
                    case 6:
                        inputField.placeholder=@"km";
                        break;
                    case 7:
                        inputField.placeholder=@"nm";
                        break;
                    case 8:
                        inputField.placeholder=@"°C";
                        break;
                    case 9:
                        inputField.placeholder=@"°F";
                        break;
                    default:
                        break;
                }
                
                break;
                    
            default:
                break;
        }
        
        return cell;
    }
    
    if (indexPath.section==0) {
        
        PickerInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCell];
        
        if (!cell) {
            
            cell=[[[PickerInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inputCell]autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.detailTextLabel.text=@"Metre --> Feet";
            
        }
               
        cell.picker.dataSource=self;
        cell.picker.delegate=self;
        
        cell.textLabel.text=@"单位转换";
        
        self.singlePicker = cell.picker;
        
        return cell;
    }  
    
    if (indexPath.section==2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCale];
        
        if (!cell) {
            
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierCale]autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIButton* cButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [cButton addTarget:self action:@selector(doCalc:) forControlEvents:UIControlEventTouchUpInside];
            [cButton setTitle:@"CALC" forState:UIControlStateNormal];
            [cButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            [cButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|
             UIViewAutoresizingFlexibleWidth ];
            cButton.frame=cell.bounds;
            UIImage *image = nil;
            if (device_Type == UIUserInterfaceIdiomPhone) {
                image = [UIImage imageNamed:@"Button_Orange_Phone.png"];
                
                
            } else {
                image = [[UIImage imageNamed:@"Button_Orange_Pad.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
                
            }
            
            [cButton setBackgroundImage:image forState:UIControlStateNormal];
            
            [cell.contentView addSubview:cButton];
            
        }

        return cell;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==3) {
        
        CGSize size = [self.resultString sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.tableViewWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height<44) {
            return 44;
        }
        return size.height;
        
    }
    return 44;
}

- (IBAction) backgroundTap:(id) sender {
	[inputField resignFirstResponder];
}

-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==inputField){
		[inputField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=18)
		return NO;
	
	if (range.location==0 && [string isEqualToString: @"-"])
	    return YES;
	
	
	//if (textField==spdField) 
	if ([string rangeOfString:@"."].location!=NSNotFound && [textField.text rangeOfString:@"."].location==NSNotFound)
			return YES;
	
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

-(IBAction) selectButton:(id) sender{
	[resultField setHidden:YES];
	[inputField setHidden:YES];
	[calcButton setHidden:YES];
	[clrButton setHidden:YES];
	[singlePicker setHidden:NO];
  	[doneButton setHidden:NO];
	[self backgroundTap:sender];
}

- (IBAction) donePressed:(id) sender {
	//[singlePicker setHidden:YES];
	[doneButton setHidden:YES];
	[inputField setHidden:NO];
	[calcButton setHidden:NO];
	[clrButton setHidden:NO];
	[resultField setHidden:NO];
	NSInteger row=[singlePicker selectedRowInComponent:0];
	NSString *selected=[pickerData objectAtIndex:row];
	[NSString stringWithFormat:@"%d",row];
	[selectButton setTitle:selected forState:UIControlStateNormal];
	switch (row) {
		case 0:
			inputField.placeholder=@"metre";
			break;
		case 1:
			inputField.placeholder=@"feet";
			break;
		case 2:
			inputField.placeholder=@"ft/min";
			break;
		case 3:
			inputField.placeholder=@"m/s";
			break;
		case 4:
			inputField.placeholder=@"° degrees";
			break;
		case 5:
			inputField.placeholder=@"% grads";
			break;
		case 6:
			inputField.placeholder=@"km";
			break;
		case 7:
			inputField.placeholder=@"nm";
			break;
		case 8:
			inputField.placeholder=@"°C";
			break;
		case 9:
			inputField.placeholder=@"°F";
			break;
		default:
			break;
	}
}
- (IBAction) doClr:(id) sender {
	resultField.text=@"";
	inputField.text=@"";
    
    self.resultString=@"";
    [self.tableView reloadData];
}
- (IBAction) doCalc:(id) sender {
    
	[self backgroundTap:sender];
	if ([inputField.text length]<1)
		return;
	double val=[inputField.text doubleValue];
	NSInteger row=[singlePicker selectedRowInComponent:0];
	switch (row) {
		case 0:
			resultField.text=[NSString stringWithFormat:@"%@ M = %1.1f ft\n%@",inputField.text,val/0.3048,resultField.text];
			break;
		case 1:
			 resultField.text=[NSString stringWithFormat:@"%@ ft = %1.2f M\n%@",inputField.text,val*0.3048,resultField.text];
			break;
		case 2:
			 resultField.text=[NSString stringWithFormat:@"%@ ft/min = %1.2f m/s\n%@",inputField.text,val*0.3048/60,resultField.text];
			break;
		case 3:
			 resultField.text=[NSString stringWithFormat:@"%@ m/s = %1.1f ft/min\n%@",inputField.text,val/0.3048*60,resultField.text];
			break;
		case 4:
			 resultField.text=[NSString stringWithFormat:@"%@° = %1.2f %%\n%@",inputField.text,tan(val*M_PI/180)*100,resultField.text];
			break;
		case 5:
			 resultField.text=[NSString stringWithFormat:@"%@ %% = %1.2f °\n%@",inputField.text,atan(val/100)/M_PI*180,resultField.text];
			break;
		case 6:
			 resultField.text=[NSString stringWithFormat:@"%@ km = %1.2f nm\n%@",inputField.text,val/1.852,resultField.text];
			break;
		case 7:
			 resultField.text=[NSString stringWithFormat:@"%@ nm = %1.2f km\n%@",inputField.text,val*1.852,resultField.text];
			break;
		case 8:
			 resultField.text=[NSString stringWithFormat:@"%@ °C = %1.2f °F\n%@",inputField.text,32+val*1.8,resultField.text];
			break;
		case 9:
			 resultField.text=[NSString stringWithFormat:@"%@ °F= %1.2f °C\n%@",inputField.text,(val-32)/1.8,resultField.text];
			break;
		default:
			break;
	}
	inputField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView 
		numberOfRowsInComponent:(NSInteger)component {
	return [pickerData count];
}
#pragma mark Picker Delegate Methods
-(NSString *)pickerView:(UIPickerView *)pickerView 
		titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [pickerData objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    PickerInputTableViewCell* cell=(PickerInputTableViewCell*) [ self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text=[self.pickerData objectAtIndex:row];
    
	switch (row) {
		case 0:
			inputField.placeholder=@"metre";
			break;
		case 1:
			inputField.placeholder=@"feet";
			break;
		case 2:
			inputField.placeholder=@"ft/min";
			break;
		case 3:
			inputField.placeholder=@"m/s";
			break;
		case 4:
			inputField.placeholder=@"° degrees";
			break;
		case 5:
			inputField.placeholder=@"% grads";
			break;
		case 6:
			inputField.placeholder=@"km";
			break;
		case 7:
			inputField.placeholder=@"nm";
			break;
		case 8:
			inputField.placeholder=@"°C";
			break;
		case 9:
			inputField.placeholder=@"°F";
			break;
		default:
			break;
	}

    [self donePressed:nil];
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSArray *array=[[NSArray alloc] initWithObjects:
					@"Metre --> Feet",
					@"Feet --> Metre",
					@"Feet/min --> Metre/sec",
					@"Metre/sec --> Feet/min",
					@"Angle --> Grads",
					@"Grads --> Angle",
					@"Kilometre --> Nautical Mile",
					@"Nautical Mile --> Kilometre",
					@"Degree Celsius -> Fahrenheit",
					@"Degree Fahrenheit -> Celsius",
					nil];
	self.pickerData=array;
	[array release];
	//[singlePicker setHidden:YES];
	[doneButton setHidden:YES];
	
	CGRect myFrame;
	myFrame=[inputField frame];
	myFrame.size.height+=6;
	inputField.frame=myFrame;
//	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//		myFrame=[resultField frame];
//		myFrame.size.width+=200;
//		myFrame.size.height+=500;
//		resultField.frame=myFrame;
//		resultField.font=[UIFont systemFontOfSize:26];
//		myFrame=[clrButton frame];
//		myFrame.origin.x+=200;
//		clrButton.frame=myFrame;
//	}	
	
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
	self.singlePicker=nil;
	self.pickerData=nil;
	self.doneButton=nil;
	self.calcButton=nil;
	self.clrButton=nil;
	self.selectButton=nil;
	self.inputField=nil;
	self.resultField=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[singlePicker release];
	[pickerData release];
	[doneButton release];
	[calcButton release];
	[clrButton release];
	[selectButton release];
	[inputField release];
	[resultField release];
    [resultString release];
    [popoverController release];
    [inputAccessoryView release];
    [super dealloc];
}


@end
