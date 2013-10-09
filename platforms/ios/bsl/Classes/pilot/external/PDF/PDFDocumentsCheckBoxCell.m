//
//  PDFDocumentsCheckBoxCell.m
//  pilot
//
//  Created by Sencho Kong on 12-10-17.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "PDFDocumentsCheckBoxCell.h"

@interface PDFDocumentsCheckBoxCell (){
    
    NSInteger buttonTag;
    
    UIActivityIndicatorView* spinner;
}

@end

@implementation PDFDocumentsCheckBoxCell
@synthesize checkBoxButton;
@synthesize bookImageView;
@synthesize bookTitleLabel;
@synthesize delegate;
@synthesize isChecked;
@synthesize isFound;
@synthesize aEbook;
@synthesize isNotFound;
@synthesize progressLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.checkBoxButton=[UIButton buttonWithType:UIButtonTypeCustom];
        checkBoxButton.tag=0;
        [checkBoxButton addTarget:self action:@selector(checkedDoc:) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Button_UnCheckMark"] forState:UIControlStateNormal];
        
        CGFloat buttonX;
       
        buttonX=self.bounds.size.width-30-20 ;
       
        [checkBoxButton setFrame:CGRectMake(buttonX, 8, 30, 30)];
        checkBoxButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:checkBoxButton];
       
       
        self.bookImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, 33, 40)]autorelease];
        [self.contentView addSubview:bookImageView];
        
        CGFloat labelWidth;
        if (device_Type==UIUserInterfaceIdiomPhone) {
           labelWidth =180.0;
        }else{
            labelWidth =200.0;
        }
        
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(66, 10, labelWidth,20)];
        [label setTextColor:[UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
        self.bookTitleLabel=label;
        [label release];
        [self.contentView addSubview:bookTitleLabel];
        
        UILabel* alabel=[[UILabel alloc]initWithFrame:CGRectMake(66, 31, labelWidth,20)];
        [alabel setTextColor:[UIColor lightGrayColor]];
        [alabel setBackgroundColor:[UIColor clearColor]];
        [alabel setFont:[UIFont boldSystemFontOfSize:11.0]];
        self.progressLabel=alabel;
        [alabel release];
        [self.contentView addSubview:progressLabel];
        
        
        
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)checkedDoc:(UIButton*)sender{
    
    buttonTag=[(UIButton*)sender tag];
    if (buttonTag%2==0) {
        
        self.isChecked=YES;
    }else{
        
        self.isChecked=NO;
    }
    buttonTag++;
    
    [sender setTag:buttonTag];
    
    
    if (delegate && [delegate respondsToSelector:@selector(didClickCheckBoxButton:bookTitle:Check:)]) {
        [delegate didClickCheckBoxButton:sender bookTitle:self.bookTitleLabel.text Check:isChecked];
    }
    
    if (delegate && [delegate respondsToSelector:@selector(didClickCheckBoxButton:ebook:Check:)]) {
        [delegate didClickCheckBoxButton:sender ebook:self.aEbook Check:isChecked];
    }
    
}

-(void)setIsChecked:(BOOL)_isChecked{
    
    checkBoxButton.enabled=YES;
    isChecked=_isChecked;
    if (isChecked) {
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Button_CheckedMark"] forState:UIControlStateNormal];
        checkBoxButton.tag=1;
    }else{
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Button_UnCheckMark"] forState:UIControlStateNormal];
        checkBoxButton.tag=0;
    }
    
}

-(void)setIsFound:(BOOL)_isFound{
    
    
    isFound=_isFound;
    if (_isFound) {
         [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Button_found"] forState:UIControlStateNormal];
        checkBoxButton.enabled=NO;
    }else{
       
        self.isChecked=NO;
                       
    }
    
}


-(void)setIsNotFound:(BOOL)isNotFound{
    
    checkBoxButton.enabled=NO;
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"btn_login_cancel"] forState:UIControlStateNormal];
        
}

    



-(void)spinnerStartAnimating{
    
    if (!spinner) {
        spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [spinner startAnimating];
    
    [spinner setFrame:checkBoxButton.frame];
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    checkBoxButton.hidden=YES;

    [self.contentView addSubview:spinner];
    

}

-(void)spinnerStopAnimating{
    
    checkBoxButton.hidden=NO;
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    isFound=NO;
    
}



- (void)dealloc {
    
    if (spinner) {
        [spinner removeFromSuperview];
        [spinner release];
    }
    
    [checkBoxButton release];
    [bookImageView  release];
    [bookTitleLabel release];
    [aEbook release];
    [progressLabel release];
    [super dealloc];
}
@end
