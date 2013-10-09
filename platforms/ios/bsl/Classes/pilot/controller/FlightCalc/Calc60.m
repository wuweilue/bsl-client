//
//  Calc60.m
//  FlightCalc
//
//  Created by apple on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Calc60.h"
#import "FPButtonTableViewCell.h"
#import "FPTextViewTableViewCell.h"
#import "FCTextFieldTableViewCell.h"

static long long ttl=0;
static NSInteger num=0;

@interface Calc60 () {
    
}

@property (nonatomic, retain) NSString *resultString;

@end

@implementation Calc60

@synthesize timeField;
@synthesize resultField;
@synthesize resultString;

- (void)timeAdd:(id)sender {
	NSInteger len=[timeField.text length];
	if (len<1) return;
	num++;
	long long min;
	min=0;
	NSInteger lenstart=0;
	char minPrefix=' ';
	if ([timeField.text characterAtIndex:0]=='-') {
		lenstart=1;
		minPrefix='-';
	}
	NSCharacterSet *setDOT=[NSCharacterSet characterSetWithCharactersInString:@".:"];
	NSRange rang=[timeField.text rangeOfCharacterFromSet:setDOT];
	if (rang.location==NSNotFound) {
		if ((len-lenstart)<=2) min=[[timeField.text substringFromIndex:lenstart] longLongValue];
		else {
			min=[[timeField.text substringFromIndex:len-2] longLongValue];
			min+=[[timeField.text substringWithRange:NSMakeRange(lenstart,len-lenstart-2)] longLongValue]*60;
		}
	} else {
		if (rang.location+2==len) {
			return;
		}
		if (rang.location+1<len) {
			min=[[timeField.text substringFromIndex:rang.location+1] longLongValue];
		}
		if ((rang.location-lenstart)>0) {
			min+=[[timeField.text substringWithRange:NSMakeRange(lenstart,rang.location)] longLongValue]*60;
		}
	}
	//NSString *tmpStr1=[[NSString alloc] initWithFormat:@"%d,%d=%d \n%@",rang.location,rang.length,len,resultField.text];
	//resultField.text=tmpStr1;
	//[tmpStr1 release];
	if (lenstart>0) min*=-1;
	ttl+=min;
	char ttlPrefix='-';
	if (ttl>=0) {
		ttlPrefix=' ';
	}
	NSString *tmpStr=[[NSString alloc] initWithFormat:@"%2d)%c%lld:%02lld\t%c%lld:%02lld\n%@",num,minPrefix,llabs(min)/60,llabs(min)%60,ttlPrefix,llabs(ttl)/60,llabs(ttl)%60,resultField.text];
	resultField.text=tmpStr;
	[tmpStr release];
	timeField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
    
//	[timeField resignFirstResponder];
//	[timeField becomeFirstResponder];
}

- (void)timeClear:(id)sender {
	ttl=0;
	num=0;
	timeField.text=@"";
	[timeField resignFirstResponder];
    
    resultField.text = @"";
    self.resultString=@"";
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
    
    self.resultField = [[[UITextView alloc] init] autorelease];
    
    UIImage *image = [UIImage imageNamed:@"RightButtonItem"];
    UIButton *rightButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)] autorelease];
    
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton setTitle:@"CLR" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [rightButton.titleLabel setShadowColor:[UIColor grayColor]];
    [rightButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [rightButton addTarget:self action:@selector(timeClear:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *clrButton = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    
    self.navigationItem.rightBarButtonItem = clrButton;

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=17) 
		return NO;
	if (range.location==0 && [string isEqualToString: @"-"])
		return YES;
	NSCharacterSet *set1234567890=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%@,%d \n%@",range.location,range.length,string,textField.text,[string rangeOfCharacterFromSet:set1234567890].location,resultField.text];
	NSCharacterSet *setDOT=[NSCharacterSet characterSetWithCharactersInString:@".:"];
	if ([string rangeOfCharacterFromSet:setDOT].location!=NSNotFound && [textField.text rangeOfCharacterFromSet:setDOT].location==NSNotFound) {
		return YES;
	}
	if ([string rangeOfCharacterFromSet:set1234567890].location!=NSNotFound ) {
		return YES;
	}
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.timeField=nil;
	self.resultField=nil;
    self.resultString = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[timeField release];
	[resultField release];
    [resultString release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"FCTextFieldTableViewCell";
        FCTextFieldTableViewCell *cell = (FCTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [FCTextFieldTableViewCell getInstance];
        }
        
        cell.customTextField.placeholder = @"etc: -1.23";
        cell.customTextField.textAlignment = UITextAlignmentLeft;
        cell.customTextField.delegate = self;
                
        self.timeField = cell.customTextField;
        return cell;
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
        
        [cell.customButton setTitle:@"ADD" forState:UIControlStateNormal];
        [cell.customButton addTarget:self action:@selector(timeAdd:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self timeAdd:nil];
    return YES;
}

@end
