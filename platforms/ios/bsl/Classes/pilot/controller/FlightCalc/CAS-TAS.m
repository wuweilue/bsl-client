//
//  CAS-TAS.m
//  FlightCalc
//
//  Created by apple on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CAS-TAS.h"
#import "FCTextFieldTableViewCell.h"
#import "FPButtonTableViewCell.h"
#import "FPTextViewTableViewCell.h"

@interface CAS_TAS () {
    
}

@property (nonatomic, retain) NSString *resultString;

@end

@implementation CAS_TAS

@synthesize altField;
@synthesize tempField;
@synthesize casField;
@synthesize resultField;
@synthesize resultString;

const double k[]={
	0,
	11000,
	20000,
	32000,
	47000,
	51000,
	71000,
	84853};
const double ag=288.15;
const double ae=287.053;
const double af=9.80665;
const double bF=101325;
const double es=6356766;
const double eS=340.2941124;
double ad(double J);
double Q(double J);
double ah(double J);
double aH(double J);
double aE(double eA);
double eB(double eA);
double lg(double aM,double bf,double T);




- (IBAction) backgroundTap:(id) sender {
	[altField resignFirstResponder];
	[tempField resignFirstResponder];
	[casField resignFirstResponder];
}
-(IBAction) textFieldDoneEditting:(id) sender{
	//resultField.text=[NSString stringWithFormat:@"%d,%d",altField, sender];
	if (sender==altField) {
		[tempField becomeFirstResponder];
	} else if (sender==tempField) {
		[casField becomeFirstResponder];
	} else if (sender==casField){
		[casField resignFirstResponder];
		[self doCalc: sender];
	}
}

- (IBAction) doCalc:(id) sender {
    
	[self backgroundTap:sender];
	if ([altField.text length]<1 || [tempField.text length]<1 || [casField.text length]<1) 
		return;
	double alt=[altField.text doubleValue];
	double temp=[tempField.text doubleValue];
	double cas=[casField.text doubleValue];
	if (cas<1 || temp<-273) {
		resultField.text=@"Tempratture invaild.\n or Speed error.";
        
        self.resultString=resultField.text;
        [self.tableView reloadData];
        
		return;
	}
	NSMutableString *resultStr;
	resultStr=[[NSMutableString alloc] initWithCapacity:128];
	[resultStr setString:@""];
	[resultStr appendFormat:@"Attitude: \t%1.0f feet\n",alt];
	if (alt>1000)
		[resultStr appendFormat:@"\t\tFL%1.0f\n",round(alt/100)];
	[resultStr appendFormat:@"Temprature: \t%1.1f °C\n",temp];
	[resultStr appendFormat:@"CAS:\t\t\t%1.0f kts\n",cas];
	
	double tas=lg(alt*0.3048,cas*1852/3600,temp+273.15); // 1 ft=0.3048m
	[resultStr appendFormat:@"TAS: \t\t%1.1f kts\n",tas*3600/1852];
	double mach=sqrt((273.15+temp)/ag); //ag=288.15
	mach=(tas/mach)/eS;
	[resultStr appendFormat:@"MACH: \t\t%1.4f\n",mach];
	
	//[resultStr appendFormat:@"\n%d",[resultStr length]]; //98	
	resultField.text=resultStr;
	[resultStr release];
	altField.text=@"";
	tempField.text=@"";
	casField.text=@"";
    
    self.resultString=resultField.text;
    [self.tableView reloadData];
    
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *)string {
	//NSString *tmpstr=[NSString stringWithFormat:@"(%d,%d)%@=%d \n%@",range.location,range.length,string,[string length],resultField.text];
	//resultField.text=tmpstr;
	if ([string isEqualToString:@"\n"] || range.length==1) 
		return YES;
	if (range.location>=6) 
		return NO;
	if (textField==tempField) {
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
    
	CGRect myFrame;
	myFrame=[altField frame];
	myFrame.size.height+=6;
	altField.frame=myFrame;
	myFrame=[tempField frame];
	myFrame.size.height+=6;
	tempField.frame=myFrame;
	myFrame=[casField frame];
	myFrame.size.height+=6;
	casField.frame=myFrame;

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
	self.tempField=nil;
	self.casField=nil;
	self.resultField=nil;
    self.resultString = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[altField release];
	[tempField release];
	[casField release];
	[resultField release];
    [resultString release];
    [super dealloc];
}

//==================

double ad(double J) {
	double a,qi,bq,bR,hv,fs,kO;      
	a=0;
	if(J<=k[1])        {  a=1+J  *Q(k[0])/ag; }
	if(J>k[1]&&J<=k[2]){ qi=1+k[1]*Q(k[0])/ag; a=qi;} 
	if(J>k[2]&&J<=k[3]){ bq=1+k[1]*Q(k[0])/ag; a=bq+(J   -k[2])*Q(k[2])/ag;}
	if(J>k[3]&&J<=k[4]){ bq=1+k[1]*Q(k[0])/ag;bR=bq+(k[3]-k[2])*Q(k[2])/ag; a=bR+(J   -k[3])*Q(k[3])/ag;} 
	if(J>k[4]&&J<=k[5]){ bq=1+k[1]*Q(k[0])/ag;bR=bq+(k[3]-k[2])*Q(k[2])/ag;hv=bR+(k[4]-k[3])*Q(k[3])/ag; a=hv;}
	if(J>k[5]&&J<=k[6]){ bq=1+k[1]*Q(k[0])/ag;bR=bq+(k[3]-k[2])*Q(k[2])/ag;hv=bR+(k[4]-k[3])*Q(k[3])/ag; fs=hv; a=fs+(J   -k[5])*Q(k[5])/ag;}
	if(J>k[6]&&J<=k[7]){ bq=1+k[1]*Q(k[0])/ag;bR=bq+(k[3]-k[2])*Q(k[2])/ag;hv=bR+(k[4]-k[3])*Q(k[3])/ag; fs=hv;kO=fs+(k[6]-k[5])*Q(k[5])/ag;a=kO+(J-k[6])*Q(k[6])/ag;}
	return a; 
}

double Q(double J) {
	double LRMO=0;
	if(J<k[1]){ LRMO= -0.0065; } //-6.5/1000
	if(J>=k[1]&&J<k[2]){ LRMO=0; }
	if(J>=k[2]&&J<k[3]){ LRMO=0.001; } // 1/1000
	if(J>=k[3]&&J<k[4]){ LRMO=0.0028; } // 2.8/1000
	if(J>=k[4]&&J<k[5]){ LRMO=0; }
	if(J>=k[5]&&J<k[6]){ LRMO=-0.0028; } // -2.8/1000
	if(J>=k[6]&&J<k[7]){ LRMO=-0.002; } // -2/1000
	return LRMO;
}

double ah(double J) {
	double a=0;
	a=ag*ad(J);
	return a;
}

double aH(double J) {
	double ap,as,bq,dK,bR,fa,hm,fs,kS,kO;
	double a=0;
	if(J<=k[1]){
		a=pow(ad(J)   ,-1*af/(Q(k[0])*ae)); }
	if(J>k[1]&&J<=k[2]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		a=ap*pow(M_E,-1*(J   -k[1])*af/(ae*ah(k[1])));  }
	if(J>k[2]&&J<=k[3]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		as=ap*pow(M_E,-1*(k[2]-k[1])*af/(ae*ah(k[1])));
		bq=ad(k[2]);
		a=as*pow((ad(J)   /bq),-1*af/(Q(k[2])*ae));}
	if(J>k[3]&&J<=k[4]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		as=ap*pow(M_E,-1*(k[2]-k[1])*af/(ae*ah(k[1])));
		bq=ad(k[2]);
		dK=as*pow((ad(k[3])/bq),-1*af/(Q(k[2])*ae));
		bR=ad(k[3]);
		a=dK*pow((ad(J)   /bR),-1*af/(Q(k[3])*ae));}
	if(J>k[4]&&J<=k[5]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		as=ap*pow(M_E,-1*(k[2]-k[1])*af/(ae*ah(k[1])));
		bq=ad(k[2]);
		dK=as*pow((ad(k[3])/bq),-1*af/(Q(k[2])*ae));
		bR=ad(k[3]);
		fa=dK*pow((ad(k[4])/bR),-1*af/(Q(k[3])*ae));
		a=fa*pow(M_E,-1*(J   -k[4])*af/(ae*ah(k[4])));}
	if(J>k[5]&&J<=k[6]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		as=ap*pow(M_E,-1*(k[2]-k[1])*af/(ae*ah(k[1])));
		bq=ad(k[2]);
		dK=as*pow((ad(k[3])/bq),-1*af/(Q(k[2])*ae));
		bR=ad(k[3]);
		fa=dK*pow((ad(k[4])/bR),-1*af/(Q(k[3])*ae));
		hm=fa*pow(M_E,-1*(k[5]-k[4])*af/(ae*ah(k[4])));
		fs=ad(k[5]);
		a=hm*pow((ad(J)   /fs),-1*af/(Q(k[5])*ae));}
	if(J>k[6]&&J<=k[7]){
		ap=pow(ad(k[1]),-1*af/(Q(k[0])*ae));
		as=ap*pow(M_E,-1*(k[2]-k[1])*af/(ae*ah(k[1])));
		bq=ad(k[2]);
		dK=as*pow((ad(k[3])/bq),-1*af/(Q(k[2])*ae));
		bR=ad(k[3]);
		fa=dK*pow((ad(k[4])/bR),-1*af/(Q(k[3])*ae));
		hm=fa*pow(M_E,-1*(k[5]-k[4])*af/(ae*ah(k[4])));
		fs=ad(k[5]);
		kS=hm*pow((ad(k[6])/fs),-1*af/(Q(k[5])*ae));
		kO=ad(k[6]);
		a=kS*pow((ad(J)   /kO),-1*af/(Q(k[6])*ae));}
	return a;
}

double aE(double eA) {
	double a=0;
	a=bF*aH(eA);
	return a;
}

double eB(double eA) {
	double a=0;
	a=eA*es/(es+eA); // parseFloat(eA)
	return a;
	
}

double lg(double aM,double bf,double T) {
	double bk;
	int x;
	double p=aE(eB(aM));
	double aJ=eS;
	double bG=0;
	double cX=bF;
	double bD=bf;
	double  M=0;
	double eW=6;
	if(bD<aJ){
		bG=(pow((1+0.2*pow(bD/aJ,2)),3.5)-1)*cX;
	} else{
		bG=(166.9215801*pow(bD/aJ,7)/pow((7*pow(bD/aJ,2)-1),2.5)-1)*cX;
	}
	M=pow(5*(pow((bG/p+1),1/3.5)-1),0.5);
	for(x=0; x<=eW; x++){
		if(M>1){
			M=0.881285*pow((bG/p+1)*pow((1-1/(7*M*M)),2.5),0.5);
		}
	}
	bk=aJ*pow(T/288.15,0.5)*M;
	return bk;
	
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
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
            cell.customLabel.text = @"Altitude(ft)";
            cell.customTextField.placeholder = @"feet";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
            self.altField = cell.customTextField;
            [altField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            return cell;
        } else if (indexPath.row == 1) {
            cell.customLabel.text = @"Temperature(Celsius)";
            cell.customTextField.placeholder = @"°C";
            cell.customTextField.delegate = self;
            cell.customTextField.returnKeyType = UIReturnKeyNext;
            
            self.tempField = cell.customTextField;
            [tempField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            return cell;
        } else {
            cell.customLabel.text = @"CAS(kts)";
            cell.customTextField.placeholder = @"knots";
            cell.customTextField.delegate = self;
            
            self.casField = cell.customTextField;
            [casField addTarget:self action:@selector(textFieldDoneEditting:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
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
