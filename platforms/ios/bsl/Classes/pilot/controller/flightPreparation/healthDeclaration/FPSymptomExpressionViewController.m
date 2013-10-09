//
//  FPSymptomExpressionViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPSymptomExpressionViewController.h"
#import "FPTextFieldTableViewCell.h"
#import "FPTextViewTableViewCell.h"
#import "GEAlertViewDelegate.h"
#import "NSString+Verification.h"
#import <QuartzCore/QuartzCore.h>

extern NSString *CTSettingCopyMyPhoneNumber();

@interface FPSymptomExpressionViewController ()

@end

@implementation FPSymptomExpressionViewController
@synthesize symptomExpressionTableView = _symptomExpressionTableView;
@synthesize symptomExpressionArray = _symptomExpressionArray;
@synthesize selectedsymptomExpressionArray = _selectedsymptomExpressionArray;
@synthesize airMedicalPhoneNumberArray = _airMedicalPhoneNumberArray;
@synthesize fpHealthDeclarationViewController = _fpHealthDeclarationViewController;
@synthesize userPhoneNumber = _userPhoneNumber;
@synthesize otherDeclarationContent = _otherDeclarationContent;
@synthesize doneInKeyboardButton = _doneInKeyboardButton;

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
    
    self.title = @"症状表现";
    
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
    
    self.symptomExpressionArray = [NSArray arrayWithObjects:@"发热",@"头晕",@"头痛",@"心慌",@"胸闷",@"胸痛",@"气喘",@"恶心",@"呕吐",@"腹痛",@"腹泻",@"便血",@"咳血",@"失眠",@"四肢浮肿",@"四肢感觉异常",nil];
    self.selectedsymptomExpressionArray = [[[NSMutableArray alloc] init] autorelease];
    
    // 设置背景图片
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
    _symptomExpressionTableView.backgroundView = imageView;
    [imageView release];
}

- (void)viewDidUnload
{
    [self setSymptomExpressionTableView:nil];
    [self setSymptomExpressionArray:nil];
    [self setSelectedsymptomExpressionArray:nil];
    [self setAirMedicalPhoneNumberArray:nil];
    [self setFpHealthDeclarationViewController:nil];
    [self setUserPhoneNumber:nil];
    [self setOtherDeclarationContent:nil];
    [self setDoneInKeyboardButton:nil];
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
    if (device_Type == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _fpHealthDeclarationViewController.ifQueryFlag = [NSNumber numberWithInt:2];
}

- (void)dealloc {
    [_symptomExpressionTableView release];
    [_symptomExpressionArray release];
    [_selectedsymptomExpressionArray release];
    [_fpHealthDeclarationViewController release];
    [_airMedicalPhoneNumberArray release];
    [_userPhoneNumber release];
    [_otherDeclarationContent release];
    [_doneInKeyboardButton release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"值班航医手机号";
            break;
        case 1:
            return @"请输入您当前使用的手机号";
            break;
        case 2:
            return @"请选择您的症状表现";
            break;
        case 3 :
            return @"其他需要申报的内容";
            break;           
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [_airMedicalPhoneNumberArray count];
            break;
        case 1:
            return 1;
        case 2:
            return 16;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.section == 0) {
        
        static NSString *identifier = @"UITableViewCellStyleDefault";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        } else {
            cell.accessoryView = nil;
        }
        
        cell.textLabel.text = [_airMedicalPhoneNumberArray objectAtIndex:indexPath.row];
        
        // 如果设备为iPhone,则可直接拨打航医的手机号
        if (device_Type == UIUserInterfaceIdiomPhone) {
            UIImage *phoneConsultImage = [[UIImage imageNamed:@"Button_Phone_Consult.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
            
            UIButton *phoneConsultButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 79, 27)] autorelease];
            phoneConsultButton.tag = indexPath.row;
            [phoneConsultButton setBackgroundImage:phoneConsultImage forState:UIControlStateNormal];
            [phoneConsultButton setBackgroundImage:phoneConsultImage forState:UIControlStateHighlighted];
            [phoneConsultButton addTarget:self action:@selector(phoneConsultAirMedical:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = phoneConsultButton;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        
        static NSString *identifier = @"TextFieldTableViewCell";
        FPTextFieldTableViewCell *cell = (FPTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [FPTextFieldTableViewCell getInstance];
        }
        
        cell.customTextField.placeholder = @"未填写";
        cell.customTextField.delegate = self;
        cell.customTextField.keyboardType = UIKeyboardTypeNumberPad;
        // 如果设备为iPhone,则自动获取系统手机号
        if (!_userPhoneNumber) {
            if (device_Type == UIUserInterfaceIdiomPhone) {
                cell.customTextField.text = [self getLocalPhoneNumber];
            }
        } else {
            cell.customTextField.text = _userPhoneNumber;
        }
        
        return cell;
        
    }
    
    if (indexPath.section == 3) {
        
        static NSString *identifier = @"TextViewTableViewCell";
        FPTextViewTableViewCell *cell = (FPTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [FPTextViewTableViewCell getInstance];
        }
        cell.customTextView.layer.cornerRadius = 10;
        cell.customTextView.delegate = self;
        cell.customTextView.text = _otherDeclarationContent;
        return cell;
        
    }
    
    static NSString *identifier = @"UITableViewCellStyleSubtitle";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    
    if ([_selectedsymptomExpressionArray containsObject:[_symptomExpressionArray objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [_symptomExpressionArray objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_selectedsymptomExpressionArray addObject:[_symptomExpressionArray objectAtIndex:indexPath.row]];
        } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_selectedsymptomExpressionArray removeObject:[_symptomExpressionArray objectAtIndex:indexPath.row]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 3:
            return 132;
            break;
        default:
            return 44;
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _doneInKeyboardButton.hidden = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.userPhoneNumber = textField.text;
    _doneInKeyboardButton.hidden = YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _doneInKeyboardButton.hidden = YES;
}

//隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.otherDeclarationContent = textView.text;
}

#pragma mark - Actions

- (void)goBack {
    _doneInKeyboardButton.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputDone {
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
    FPTextFieldTableViewCell *cell1 = (FPTextFieldTableViewCell *)[_symptomExpressionTableView cellForRowAtIndexPath:indexPath1];
    
    NSString *userPhoneNumber = nil;
    if ([cell1.customTextField isFirstResponder]) {
        userPhoneNumber = cell1.customTextField.text;
    } else {
        if (!_userPhoneNumber) {
            if (device_Type == UIUserInterfaceIdiomPhone) {
                userPhoneNumber = [self getLocalPhoneNumber];
            }
        } else {
            userPhoneNumber = _userPhoneNumber;
        }
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    userPhoneNumber = [userPhoneNumber stringByTrimmingCharactersInSet:whitespace];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:3];
    FPTextViewTableViewCell *cell2 = (FPTextViewTableViewCell *)[_symptomExpressionTableView cellForRowAtIndexPath:indexPath2];

    NSString *otherDeclarationContent = nil;
    
    if ([cell2.customTextView isFirstResponder]) {
        otherDeclarationContent = cell2.customTextView.text;
    } else {
        otherDeclarationContent = _otherDeclarationContent;
    }
    
    otherDeclarationContent = [otherDeclarationContent stringByTrimmingCharactersInSet:whitespace];
    
    if (otherDeclarationContent && ![otherDeclarationContent isEqualToString:@""]) {
        _fpHealthDeclarationViewController.otherDeclarationContent = otherDeclarationContent;
        [_selectedsymptomExpressionArray addObject:otherDeclarationContent];
    }
    
    GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
    
    if (!userPhoneNumber || [userPhoneNumber isEqualToString:@""]) {
        NSString *message = @"请输入您当前使用的手机号！";
        [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else if (![userPhoneNumber isValidatedPhoneNumber]) {
        NSString *message = @"您输入的手机号有误，请重新输入！";
        [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else if ([_selectedsymptomExpressionArray count] == 0) {
        NSString *message = @"请选择您的症状表现或输入其他需要申报的内容！";
        [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else if (otherDeclarationContent.length > 200) {
        NSString *message = @"其他需要申报的内容输入的文字过多，最多可输入200个字符！";
        [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else {
        _fpHealthDeclarationViewController.userPhoneNumber = userPhoneNumber;
        _fpHealthDeclarationViewController.selectedsymptomExpressionArray = _selectedsymptomExpressionArray;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

// 联系航医
- (void)phoneConsultAirMedical:(UIButton *)sender {
    NSString *phoneNumber = [_airMedicalPhoneNumberArray objectAtIndex:sender.tag];
    NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}

- (void)keyboardWillShow:(NSNotification*) notification {
    
    // 自定义iPhone数字键盘的Done键
    if (device_Type == UIUserInterfaceIdiomPhone) {
        // create custom button
        if (_doneInKeyboardButton == nil)
        {
            self.doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
            _doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
            [_doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up.png"] forState:UIControlStateNormal];
            [_doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_down.png"] forState:UIControlStateHighlighted];
            [_doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    UIEdgeInsets e;
    if (device_Type == UIUserInterfaceIdiomPad && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        e = UIEdgeInsetsMake(0, 0, 360, 0);
    } else {
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    }
    [_symptomExpressionTableView setScrollIndicatorInsets:e];
    [_symptomExpressionTableView setContentInset:e];
    
}

- (void)keyboardWillHide:(NSNotification*) notification {
    [_symptomExpressionTableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    _symptomExpressionTableView.contentInset = UIEdgeInsetsZero;
    if (device_Type == UIUserInterfaceIdiomPhone) {
        if (_doneInKeyboardButton.superview)
        {
            [_doneInKeyboardButton removeFromSuperview];
        }
    }
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    // locate keyboard view
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (_doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:_doneInKeyboardButton]; // 注意这里直接加到window上
    }
}

- (void)finishAction {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; // 关闭键盘
}

#pragma mark - Methods

// 获取iPhone的本机号码，并对+86开头的手机号码作处理
- (NSString *)getLocalPhoneNumber {
    NSString *LocalPhoneNumber = CTSettingCopyMyPhoneNumber();
    if (LocalPhoneNumber && LocalPhoneNumber.length != 11) {
        LocalPhoneNumber = [LocalPhoneNumber substringFromIndex:3];
    }
    return LocalPhoneNumber;
}

@end
