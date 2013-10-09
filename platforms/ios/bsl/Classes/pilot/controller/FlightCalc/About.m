//
//  About.m
//  FlightCalc
//
//  Created by apple on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "About.h"


@implementation About
@synthesize textView;
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(void) viewWillAppear:(BOOL)animated{
//-(void) viewDidLoad {
	NSString *a,*b,*c,*d;
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *filename=[documentsDirectory stringByAppendingPathComponent:@"FlightCalc.db"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
		NSArray *array=[[NSArray alloc] initWithContentsOfFile:filename];
		a=[NSString stringWithString:[array objectAtIndex:0]];
		b=[NSString stringWithString:[array objectAtIndex:1]];
		c=[NSString stringWithString:[array objectAtIndex:2]];
		d=[NSString stringWithString:[array objectAtIndex:4]];
		[array release];
	} else {
		a=@""; b=@""; c=@""; d=@"";
	}

		
	textView.text=[NSString stringWithFormat: @"About & Help\n\n\n\n\
Use this tool at your own risk.\n\
Use this tool at your own risk.\n\
\n\
This application can be find in http://fxb.csair.com/flightcalc/\n\
FlightCalc for Android2.x also can be find in http://fxb.csair.com/flightcalc/\n\
Author: Captain LILI GuangZhou GuangDong China.\n\
   Email:llgzcn@gmail.com \n\
Icon producer: Catptain WangWang GZ GD China.\n\
Thanks:james_long.\n\
Write at 2011-6-20.\n\
Modified: 2011-7-19.\n\
Modified: 2011-7-29.\n\
Modified: 2012-5-08.\n\
\n\
Download Url: http://fxb.csair.com/flightcalc/\n\
图标作者:中国广东广州南航A320机长 王旺。  \n\
程序作者:中国广东广州南航A320机长 李力。  \n\
=============================\n\
Help:\n\
60Calc: input time,example:type 123 or 1.23 for 1:23,then press\"ADD\"(minus sign allowed).\n\
Fuel calc:input \"S.G.\" and other one item,press \"CALC\".\n\
CDA:input \"grads\" or \"angle\",\"input altitude\",\"FAF altitude\",\"FAF DME\",press \"CALC\"\n\
SDA:input \"altitude\" and \"distance\",\"speed\" is optional, press \"CALC\".\n\
Turn radius:\n\
CAS-TAS:\n\
conversion:\n\
  input all the items,press \"CALC\".\n"];
	
//    =============================\n\
//Register:\n\
//    It is free to get registration key.\n\
//    I would like to know how many people use this software.\n\
//    To get register key pls click GetKey or goto the Web site http://fxb.csair.com/flightcalc/webreg.php?a=flt%%3Aapk&i=%@&c=%@&n=%@&e=%@ \n\
//    or send EMAIL to me.\n\
//    ============= END ===========\n
    
	//	[super viewWillAppear:animated];
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		textView.font=[UIFont systemFontOfSize:20];
	}	
	
	[super viewDidLoad];
    
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
}
-(void)viewDidUnload{
	self.textView=nil;
	[super viewDidUnload];
}
-(void)dealloc {
	[textView release];
	[super dealloc];
}
//- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
//	return textView;
//}
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//	if (scale>1.0) {
//		textView.font=[UIFont systemFontOfSize:20];
//	} else {
//		textView.font=[UIFont systemFontOfSize:22];
//	}
//}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
