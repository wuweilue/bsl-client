//
//  AbstractTableViewController.m
//  pilot
//
//  Created by Sencho Kong on 13-2-5.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "AbstractTableViewController.h"

@interface AbstractTableViewController (){
    
    @private
    UIButton *backButton;
    UIImageView* backgroundImageView ;
    UIToolbar *inputAccessoryView;
   
}



@end

@implementation AbstractTableViewController
@synthesize tableView=_tableView;
@synthesize titleOfBackItem=_titleOfBackItem;
@synthesize tableViewWidth;
@synthesize doneInKeyboardButton = _doneInKeyboardButton;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BeginEditTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_titleOfBackItem release];
    [_tableView release];
    [_doneInKeyboardButton release];
    [super dealloc];
}


-(id)init{
    
    self=[super init];
    if (self) {
        
        [self registerForKeyboardNotifications];
        
    }
    return  self;
}

- (void)registerForKeyboardNotifications{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeTextField:)
                                                 name:@"BeginEditTextField" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
     
                                             selector:@selector(keyboardWillBeHidden:)
     
     
                                                 name:UIKeyboardWillHideNotification object:nil];
       
    
}

-(void)activeTextField:(NSNotification*)aNotification{
    
   aActiveField=  [aNotification object];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    if (device_Type == UIUserInterfaceIdiomPhone) {
        NSDictionary* info = [aNotification userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        //当键盘出现时，缩小tableview的内容高度
        self.tableView.contentInset = contentInsets;
        
        self.tableView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        
        aRect.size.height -= kbSize.height;
        
        if (!CGRectContainsPoint(aRect, aActiveField.frame.origin)) {
            
            CGPoint scrollPoint = CGPointMake(0.0, aActiveField.frame.origin.y-kbSize.height);
            
            [_tableView setContentOffset:scrollPoint animated:YES];
            
        }

    }
         
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.tableView.contentInset = contentInsets;
    
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    aActiveField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
    aActiveField = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:_titleOfBackItem forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonForBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = buttonForBack;
    [buttonForBack release];
    
    
    if (!_titleOfBackItem||[_titleOfBackItem length]==0) {
        self.titleOfBackItem=@" 返回";
    }
        
    CGRect rect=self.view.bounds;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight ;
    [self.view addSubview:_tableView];
    
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            backgroundImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }else{
            backgroundImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }
    }else{
        backgroundImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    self.tableView.backgroundView = backgroundImageView;
    [backgroundImageView release];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:11.0/255.0 green:76.0/255.0 blue:138.0/255.0 alpha:1.0]];

}


-(void)back:(id)sender{
    
    if (self.navigationController) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; // 关闭键盘
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(NSString*)titleOfBackItem{
    
    if (backButton) {
       return backButton.titleLabel.text;
    }
    
    return nil;
}

-(void)setTitleOfBackItem:(NSString *)titleOfBackItem{
    
    if (backButton) {
        [backButton setTitle:titleOfBackItem forState:UIControlStateNormal];
    }
    
}

-(void)setBackImage:(NSString *)imageName{
    
    if (backgroundImageView) {
        [backgroundImageView setImage:[UIImage imageNamed:imageName]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
            self.tableViewWidth=1000;
        }else{
            self.tableViewWidth=748;
        }
        
        [self.tableView reloadData];
 
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            
            self.tableViewWidth=300;
            return YES;
            
        }
        return NO;
    }
    
}


- (BOOL)shouldAutorotate
{
    if (device_Type == UIUserInterfaceIdiomPhone){
        return NO;
    }else{
        return YES;
    }
    
}



- (NSUInteger)supportedInterfaceOrientations{
    
    if (device_Type == UIUserInterfaceIdiomPad) {
        
 
        self.tableViewWidth=748;
        [self.tableView reloadData];
        
        return UIInterfaceOrientationMaskAll;
        
        
    }else{
        
        self.tableViewWidth=300;
        return UIInterfaceOrientationMaskPortrait ;
        
        
    }
    
}

@end
