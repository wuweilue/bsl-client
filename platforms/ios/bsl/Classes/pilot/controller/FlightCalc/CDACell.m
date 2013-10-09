//
//  CDACell.m
//  FlightCalc
//
//  Created by apple on 11-6-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDACell.h"
//#import <QuartzCore/QuartzCore.h>

@implementation CDACell

@synthesize fromField;
@synthesize fafField;
@synthesize dmeField;
@synthesize angleField;
@synthesize angButton;
@synthesize spdField;
@synthesize mdaField;
@synthesize resultField;
@synthesize bkView;

- (IBAction) backgroundTap:(id) sender {
	[fromField resignFirstResponder];
	[fafField resignFirstResponder];
	[dmeField resignFirstResponder];
	[angleField resignFirstResponder];
	[spdField resignFirstResponder];
	[mdaField resignFirstResponder];
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
    if (textField==dmeField) {
	if (range.location==0 && [string isEqualToString: @"-"])
		return YES;
    }
	if (textField==dmeField || textField==angleField) {
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
			return;
		}
		grads=tan(angle*M_PI/180.0);
	} else {
		grads=angle/100.0;
		angle=atan(grads)*180.0/M_PI;
	}
	NSMutableString *resultStr;
	resultStr=[[NSMutableString alloc] initWithCapacity:256];
	[resultStr setString:@"Check point is usually the lower one of FAF or SDF.\n------------------------------------\n"];
	[resultStr appendFormat:@"From altitude: \t%1.0f feet.\n",startH];
	[resultStr appendFormat:@"CheckPoint: \t%1.0f feet.\n",fafH]; //°C update
	[resultStr appendFormat:@"CheckPoint DME: \t%1.2f NM.\n",dme]; //°C  update
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
	[resultStr appendFormat:@"------------------------------------\n"];
	
	
	//[resultStr appendFormat:@"\n%d\n\n\n",[resultStr length]]; //756
	resultField.text=resultStr;
	[resultStr release];
	 
	fromField.text=@"";	
	fafField.text=@"";	
	dmeField.text=@"";
	angleField.text=@"";
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
	[(UIScrollView *) self.resultField setDelegate:self];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[fromField release];
	[fafField release];
	[dmeField release];
	[angButton release];
	[angleField release];
	[spdField release];
	[resultField release];
    [super dealloc];
}
/*
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return  resultField;
}
*/
@end
