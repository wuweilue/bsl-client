//
//  InputAlertView.m
//  
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "InputAlertView.h"

@implementation InputAlertView

@synthesize callback;

- (id)init{
    self = [super init];
    if (self) {
        self.delegate=self;
        self.title=@"";
        self.message=@"";
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    
    titleView.font=[UIFont boldSystemFontOfSize:20];
    
    CGRect rect;
    float y=10.0f;
    if(titleView!=nil){
        rect=titleView.frame;
        rect.origin.y=y+10.0f;
        titleView.frame=rect;
        y=rect.origin.y+rect.size.height;
    }
    if(textField!=nil){
        rect=textField.frame;
        rect.origin.y=y+10.0f;
        textField.frame=rect;
        y=rect.origin.y+rect.size.height;
    }
    float bottom=y;
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[UIButton class]] ||  [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            rect=v.frame;
            rect.origin.y=y+10.0f;
            v.frame=rect;
            if(rect.size.height+rect.origin.y>bottom)
                bottom=rect.size.height+rect.origin.y;
        }
    }
    rect=self.frame;
    rect.size.height=bottom+20.0f;
    self.frame=rect;
    UIWindow* window=[UIApplication sharedApplication].keyWindow;
    alertView.center=CGPointMake(window.center.x, window.center.y);
    //new code
}


-(void)showTitle:(NSString*)value{
    if(titleView==nil){
        titleView=[[UILabel alloc] init];
        titleView.numberOfLines=0;
        titleView.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleView.textAlignment = UITextAlignmentCenter;
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setTextColor:[UIColor whiteColor]];
        [self addSubview:titleView];
        [titleView release];
    }
    titleView.frame=CGRectMake(20.0, 5.0,245.0, 150.0f);
    [titleView setText:value];
    [titleView sizeToFit];
    
    CGRect rect=titleView.frame;
    rect.size.width=245.0f;
    titleView.frame=rect;
}

-(void)showTextField{
    if(textField==nil){
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 30.0)];
        textField.borderStyle=UITextBorderStyleBezel;
        [textField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:textField];
        [textField release];
    }
}

-(void)textFieldText:(NSString*)value{
    if(textField!=nil){
        [textField setText:value];
    }
}

-(NSString*)textFieldText{
    if([textField.text length]>0){
        return textField.text;
    }
    else {
        return @"";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([self.callback respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [self.callback alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    if([self.callback respondsToSelector:@selector(alertViewCancel:)]){
        [self.callback alertViewCancel:alertView];
    }
}

@end
