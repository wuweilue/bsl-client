//
//  FPWriteInfoViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-12.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPWriteInfoViewController.h"
#import "FPTextViewTableViewCell.h"
#import "GEAlertViewDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FPWriteInfoViewController ()

@end

@implementation FPWriteInfoViewController

@synthesize writeInfoTableView = _writeInfoTableView;
@synthesize fpHealthDeclarationViewController = _fpHealthDeclarationViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"药品名称";
    
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
    
    UIImage *doneImage = [UIImage imageNamed:@"RightButtonItem"];
    UIButton *doneButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)] autorelease];
    
    [doneButton setBackgroundImage:doneImage forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [doneButton.titleLabel setShadowColor:[UIColor grayColor]];
    [doneButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(inputDone) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIImageView *imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        } else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    _writeInfoTableView.backgroundView = imageView;
    [imageView release];
}

- (void)viewDidUnload
{
    [self setWriteInfoTableView:nil];
    [self setFpHealthDeclarationViewController:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _fpHealthDeclarationViewController.ifQueryFlag = [NSNumber numberWithInt:1];
}

- (void)dealloc {
    [_writeInfoTableView release];
    [_fpHealthDeclarationViewController release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请输入您服用的药品名称";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *identifier = @"TextViewTableViewCell";
    FPTextViewTableViewCell *cell = (FPTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [FPTextViewTableViewCell getInstance];
    }
    cell.customTextView.layer.cornerRadius = 10;
    cell.customTextView.delegate = self;
    return cell;
    
}

#pragma mark - UITextViewDelegate

//隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputDone {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    FPTextViewTableViewCell *cell = (FPTextViewTableViewCell *)[_writeInfoTableView cellForRowAtIndexPath:indexPath];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *drugDetailInfo = [cell.customTextView.text stringByTrimmingCharactersInSet:whitespace];
    
    if (!drugDetailInfo || [drugDetailInfo isEqualToString:@""]) {
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"提示" message:@"请输入您所服用的药物名称！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else if (drugDetailInfo.length > 50) {
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"提示" message:@"您输入的文字过长，最多可输入50个字符！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else {
        _fpHealthDeclarationViewController.drugDetailInfo = drugDetailInfo;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)keyboardWillShow:(NSNotification*) notification {
    if (device_Type == UIUserInterfaceIdiomPhone) {
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        UIEdgeInsets e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
        [_writeInfoTableView setScrollIndicatorInsets:e];
        [_writeInfoTableView setContentInset:e];
    }
}

- (void)keyboardWillHide:(NSNotification*) notification {
    [_writeInfoTableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    _writeInfoTableView.contentInset = UIEdgeInsetsZero;
}

@end
