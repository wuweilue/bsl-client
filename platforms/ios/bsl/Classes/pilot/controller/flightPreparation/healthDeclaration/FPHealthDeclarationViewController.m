//
//  FPHealthDeclarationViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPHealthDeclarationViewController.h"
#import "FPHealthDeclarationTableViewCell.h"
#import "FPSymptomExpressionViewController.h"
#import "FPWriteInfoViewController.h"
#import "EBArticleLogInfoQuery.h"
#import "GEAlertViewDelegate.h"
#import "FPAnswerOnlineViewController.h"
#import "MBProgressController.h"
#import "FPButtonTableViewCell.h"
#import "HealthyDeclareLocalInfo.h"
#import "FPCoordinatingController.h"
#import "User.h"

@interface FPHealthDeclarationViewController ()

- (void) loadWithHealthyInfo:(NSObject*) info;

@end

@implementation FPHealthDeclarationViewController

@synthesize healthDeclarationTableView = _healthDeclarationTableView;
@synthesize isDrinkSwitch = _isDrinkSwitch;
@synthesize isMedicationSwitch = _isMedicationSwitch;
@synthesize isHealthySwitch = _isHealthySwitch;
@synthesize userPhoneNumber = _userPhoneNumber;
@synthesize selectedsymptomExpressionArray = _selectedsymptomExpressionArray;
@synthesize otherDeclarationContent = _otherDeclarationContent;
@synthesize drugDetailInfo = _drugDetailInfo;
@synthesize ebArticleLogInfoArray = _ebArticleLogInfoArray;
@synthesize healthyInfo = _healthyInfo;
@synthesize healthyDeclareInfo = _healthyDeclareInfo;
@synthesize ifQueryFlag = _ifQueryFlag;
@synthesize totalTime = _totalTime;

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
    
    self.ifQueryFlag = [NSNumber numberWithInt:0];
    self.healthyDeclareInfo = [[[HealthyDeclareInfo alloc] init] autorelease];
    
    self.title = @"健康申报";
    
    NSDate *date = [NSDate date];
    NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
    self.totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime = date;
    
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"  重要文件" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.tag = kbuttonTagBack;
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIImage *nextImage = [UIImage imageNamed:@"RightButtonItem"];
    self.buttonForNextStep = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30) ]autorelease];
    [_buttonForNextStep setBackgroundImage:nextImage forState:UIControlStateNormal];
    [_buttonForNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [_buttonForNextStep.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_buttonForNextStep.titleLabel setShadowColor:[UIColor grayColor]];
    [_buttonForNextStep.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [_buttonForNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonForNextStep addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:_buttonForNextStep];
    [_buttonForNextStep release];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];
            
    self.isDrinkSwitch = [[[DCRoundSwitch alloc] init] autorelease];
    _isDrinkSwitch.onText = @"是"; // 设置开与关时显示的文字
    _isDrinkSwitch.offText = @"否"; // 设置开与关时显示的文字
    
    self.isMedicationSwitch = [[[DCRoundSwitch alloc] init] autorelease];
    _isMedicationSwitch.onText = @"是";
    _isMedicationSwitch.offText = @"否";
    [_isMedicationSwitch addTarget:self action:@selector(isMedicationSwitchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isHealthySwitch = [[[DCRoundSwitch alloc] init] autorelease];
    _isHealthySwitch.onText = @"是";
    _isHealthySwitch.offText = @"否";
    [_isHealthySwitch addTarget:self action:@selector(isHealthySwitchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
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
    _healthDeclarationTableView.backgroundView = imageView;
    [imageView release];
        
}

- (void)viewDidUnload
{
    [self setHealthDeclarationTableView:nil];
    [self setIsDrinkSwitch:nil];
    [self setIsMedicationSwitch:nil];
    [self setIsHealthySwitch:nil];
    [self setUserPhoneNumber:nil];
    [self setSelectedsymptomExpressionArray:nil];
    [self setOtherDeclarationContent:nil];
    [self setEbArticleLogInfoArray:nil];
    [self setHealthyInfo:nil];
    [self setHealthyDeclareInfo:nil];
    [self setDrugDetailInfo:nil];
    [self setIfQueryFlag:nil];
    [self setButtonForNextStep:nil];
    [self setTotalTime:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    
    if ([_ifQueryFlag intValue] == 0) {
        
        [_isDrinkSwitch setOn:NO animated:NO ignoreControlEvents:UIControlEventTouchUpInside];
        [_isMedicationSwitch setOn:NO animated:NO ignoreControlEvents:UIControlEventTouchUpInside];
        [_isHealthySwitch setOn:YES animated:NO ignoreControlEvents:UIControlEventTouchUpInside];
        
        // 进行健康申报信息查询
        [self queryHealthyInfo];
        
    } else if ([_ifQueryFlag intValue] == 1) {
        if (!_drugDetailInfo) {
            [_isMedicationSwitch setOn:NO animated:YES ignoreControlEvents:UIControlEventTouchUpInside];
        } else {
            [_healthDeclarationTableView reloadData];
        }
    } else {
        if ([_selectedsymptomExpressionArray count] == 0) {
            [_isHealthySwitch setOn:YES animated:YES ignoreControlEvents:UIControlEventTouchUpInside];
        } else
            [self insertSymptomExpression];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    // 将查询标志置为0
    _ifQueryFlag = [NSNumber numberWithInt:0];
}

- (void)dealloc {
    [_healthDeclarationTableView release];
    [_isDrinkSwitch release];
    [_isMedicationSwitch release];
    [_isHealthySwitch release];
    [_userPhoneNumber release];
    [_selectedsymptomExpressionArray release];
    [_otherDeclarationContent release];
    [_ebArticleLogInfoArray release];
    [_healthyInfo release];
    [_healthyDeclareInfo release];
    [_drugDetailInfo release];
    [_ifQueryFlag release];
    [_buttonForNextStep release];
    [_totalTime release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return (_selectedsymptomExpressionArray) ? [_selectedsymptomExpressionArray count] + 1 : 1;
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static NSString *identifier = @"HealthDeclarationCell";
        FPHealthDeclarationTableViewCell *cell = (FPHealthDeclarationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

        if (cell == nil) {
            cell = [FPHealthDeclarationTableViewCell getInstance];
        }
        
        if (_healthyInfo) {
            cell.unHealthyCountLabel.text = [NSString stringWithFormat:@"%@", _healthyInfo.unHealthyCount];
            if ([_healthyInfo.unHealthyCount intValue] >= 2) {
                cell.unHealthyCountDescriptionLabel.textColor = [UIColor redColor];
                cell.unHealthyCountLabel.textColor = [UIColor redColor];
            }
            cell.staffNumLabel.text = TaskDelegate.empId;
            cell.nameLabel.text = _healthyInfo.name;
            cell.taskFlightLabel.text = TaskDelegate.flightNo;
            cell.aircraftModelLabel.text = TaskDelegate.plane;
            cell.declarationTimeLabel.text = _healthyInfo.serviceTime;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *identifier = @"UITableViewCellStyleSubtitle";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        } else {
            cell.accessoryView = nil;
            cell.detailTextLabel.text = @"";
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"10小时内是否饮酒";
            cell.accessoryView = _isDrinkSwitch;
            if (_healthyInfo) {
                if ([_healthyInfo.drinkFlag isEqualToString:@"Y"]) {
                    [_isDrinkSwitch setOn:YES animated:NO ignoreControlEvents:UIControlEventTouchUpInside];;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            cell.textLabel.text = @"24小时内是否服药";
            cell.accessoryView = _isMedicationSwitch;
            if (_healthyInfo) {
                if ([_healthyInfo.doseFlag isEqualToString:@"Y"]) {
                    [_isMedicationSwitch setOn:YES animated:NO ignoreControlEvents:UIControlEventTouchUpInside];
                }
                if (!_drugDetailInfo) {
                    if ([_ifQueryFlag intValue] == 0) {
                        cell.detailTextLabel.text = _healthyInfo.drugDetail;
                    } else {
                        cell.detailTextLabel.text = @"";
                    }
                } else {
                    cell.detailTextLabel.text = _drugDetailInfo;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    
    } else if (indexPath.section == 2) {
        
        static NSString *identifier = @"UITableViewCellStyleDefault";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        } else {
            cell.accessoryView = nil;
        }

//        NSLog(@"%@", cell.textLabel.font);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"自我评价是否健康";
            cell.accessoryView = _isHealthySwitch;
            if (_healthyInfo) {
                if ([_healthyInfo.healthyFlag isEqualToString:@"N"] && [_ifQueryFlag intValue] == 0) {
                    [_isHealthySwitch setOn:NO animated:NO ignoreControlEvents:UIControlEventTouchUpInside];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"%@", cell.textLabel.font);
            return cell;
        } else {
            cell.textLabel.text = [_selectedsymptomExpressionArray objectAtIndex:indexPath.row - 1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    } else {
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
        
        // 去掉cell的边框
        UIView *backgroundView = [[[UIView alloc] init] autorelease];
        cell.backgroundView = backgroundView;
        
        [cell.customButton setBackgroundImage:image forState:UIControlStateNormal];
        [cell.customButton setBackgroundImage:image forState:UIControlStateHighlighted];
        
        [cell.customButton setTitle:@"提交" forState:UIControlStateNormal];
        [cell.customButton addTarget:self action:@selector(commitHealthyDeclareInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 161;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)requestChangeView:(id)sender {
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
}

- (void)nextStep:(id)sender {
    
    FPAnswerOnlineViewController *fpAnswerOnlineViewController = [[[FPAnswerOnlineViewController alloc] initWithNibName:@"FPAnswerOnlineViewController" bundle:nil] autorelease];

    if (!_isHealthySwitch.enabled) {
        
        HealthyDeclareInfo *healthyDeclareInfo = [[[HealthyDeclareInfo alloc] init] autorelease];
        fpAnswerOnlineViewController.healthyDeclareInfo = healthyDeclareInfo;
        [self.navigationController pushViewController:fpAnswerOnlineViewController animated:YES];
        
        _drugDetailInfo = nil;
        if (_selectedsymptomExpressionArray) {
            [self deleteSymptomExpression];
        }
        
        [self setHealthyDeclareInfoCanChanged:YES];
        
    } else {
        
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        
        NSString *message = @"10小时内是否饮酒：否\n24小时内是否服药：否\n自我评价是否健康：是";
        [geAlert showAlertViewWithTitle:@"提交默认健康申报信息" message:message confirmButtonTitle:@"确定" cancelButtonTitle:@"取消" confirmBlock:^ {
            
            // 重新初始化一个空对象
            self.healthyDeclareInfo = [[[HealthyDeclareInfo alloc] init] autorelease];
            
            [self saveHealthyDeclareLocalInfo];
            
            fpAnswerOnlineViewController.healthyDeclareInfo = _healthyDeclareInfo;
            [self.navigationController pushViewController:fpAnswerOnlineViewController animated:YES];
            
            _drugDetailInfo = nil;
            if (_selectedsymptomExpressionArray) {
                [self deleteSymptomExpression];
            }
            
            [self setHealthyDeclareInfoCanChanged:YES];
            
        } cancelBlock:nil];
        
    }
    
}

- (void)isMedicationSwitchValueChanged:(id)sender {
    if (_healthyInfo) {
        if (_isMedicationSwitch.on) {
            FPWriteInfoViewController *fpWriteInfoViewController = [[[FPWriteInfoViewController alloc] initWithNibName:@"FPWriteInfoViewController" bundle:nil] autorelease];
            fpWriteInfoViewController.fpHealthDeclarationViewController = self;
            _drugDetailInfo = nil;
            [self.navigationController pushViewController:fpWriteInfoViewController animated:YES];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            UITableViewCell *cell = [_healthDeclarationTableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = @"";
        }
    }
}

- (void)isHealthySwitchValueChanged:(id)sender {
    if (_healthyInfo) {
        if (!_isHealthySwitch.on) {
            FPSymptomExpressionViewController *fpSymptomExpressionViewController = [[[FPSymptomExpressionViewController alloc] initWithNibName:@"FPSymptomExpressionViewController" bundle:nil] autorelease];
            fpSymptomExpressionViewController.fpHealthDeclarationViewController = self;
            NSLog(@"phoneList:%@",_healthyInfo.doctorPhoneList);
            fpSymptomExpressionViewController.airMedicalPhoneNumberArray = _healthyInfo.doctorPhoneList;
            [self.navigationController pushViewController:fpSymptomExpressionViewController animated:YES];
        } else {
            if (_selectedsymptomExpressionArray && [_selectedsymptomExpressionArray count] > 0) {
                [self deleteSymptomExpression];
            }
        }
    }
}

- (void)commitHealthyDeclareInfo:(id *)sender {
            
    _healthyDeclareInfo.staffNo = TaskDelegate.empId;
    _healthyDeclareInfo.fltDate = TaskDelegate.flightTime;
    _healthyDeclareInfo.fltNo = TaskDelegate.flightNo;
    _healthyDeclareInfo.planeNo = TaskDelegate.plane;
    _healthyDeclareInfo.declareDate = _healthyInfo.serviceTime;
    _healthyDeclareInfo.remark = _otherDeclarationContent;
    
    GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
    NSString *message = @"";
    
    message = [message stringByAppendingString:@"10小时内是否饮酒："];
    if (_isDrinkSwitch.on) {
        message = [message stringByAppendingString:@"是\n"];
        _healthyDeclareInfo.drinkFlag = @"Y";
    } else {
        message = [message stringByAppendingString:@"否\n"];
        _healthyDeclareInfo.drinkFlag = @"N";
    }
    
    message = [message stringByAppendingString:@"24小时内是否服药："];
    if (_isMedicationSwitch.on) {
                
        message = [message stringByAppendingFormat:@"是\n药品名称：%@\n", _drugDetailInfo];
        _healthyDeclareInfo.doseFlag = @"Y";
        _healthyDeclareInfo.drugDetail = _drugDetailInfo;
        
    } else {
        message = [message stringByAppendingString:@"否\n"];
        _healthyDeclareInfo.doseFlag = @"N";
    }
    
   message = [message stringByAppendingString:@"自我评价是否健康："];
    if (_isHealthySwitch.on) {
        message = [message stringByAppendingString:@"是\n"];
        _healthyDeclareInfo.healthyFlag = @"Y";
        _healthyDeclareInfo.count = [NSString stringWithFormat:@"%@", _healthyInfo.unHealthyCount];
    } else {
        message = [message stringByAppendingString:@"否\n症状表现："];
        _healthyDeclareInfo.healthyFlag = @"N";
        _healthyDeclareInfo.type = @"";
        
        NSNumber *unHealthyCount = [NSNumber numberWithInt:[_healthyInfo.unHealthyCount intValue]+1];
        _healthyDeclareInfo.count = [NSString stringWithFormat:@"%@", unHealthyCount];
        
        for (NSString *symptomExpression in _selectedsymptomExpressionArray) {
            if (![symptomExpression isEqualToString:_otherDeclarationContent]) {
                message = [message stringByAppendingFormat:@"%@、", symptomExpression];
                _healthyDeclareInfo.type = [_healthyDeclareInfo.type stringByAppendingFormat:@"%@、", symptomExpression];
            }
        }
        
        _healthyDeclareInfo.typeCode = [self convertSymptomFromChineseCharactersToLetter];
        
        if ([_healthyDeclareInfo.typeCode isEqualToString:@"Z"]) {
            message = [message stringByAppendingString:@"无\n"];
        } else {
            message = [message substringToIndex:message.length - 1];
            message = [message stringByAppendingString:@"\n"];
            _healthyDeclareInfo.type = [_healthyDeclareInfo.type substringToIndex:_healthyDeclareInfo.type.length - 1];
        }
                
        if (_otherDeclarationContent) {
            message = [message stringByAppendingFormat:@"其他需申报内容：%@\n", _otherDeclarationContent];
        }
        message = [message stringByAppendingFormat:@"手机号：%@\n", _userPhoneNumber];
        
        // 调试
        _healthyDeclareInfo.doctorPhoneList = _healthyInfo.doctorPhoneList;
        _healthyDeclareInfo.mobileList = _healthyInfo.mobileList;
        
//        NSArray *phoneList = [NSArray arrayWithObjects:@"13632240385", @"18680581995", @"18682193521", nil];
//        _healthyDeclareInfo.doctorPhoneList = phoneList;
        
        _healthyDeclareInfo.phoneNo = _userPhoneNumber;
    }
    
    [geAlert showAlertViewWithTitle:@"提交健康申报信息" message:message confirmButtonTitle:@"确定" cancelButtonTitle:@"取消" confirmBlock:^ {
        
        if ([_healthyDeclareInfo.drinkFlag isEqualToString:@"N"] && [_healthyDeclareInfo.doseFlag isEqualToString:@"N"] && [_healthyDeclareInfo.healthyFlag isEqualToString:@"Y"]) {
            
            // 重新初始化一个空对象
            self.healthyDeclareInfo = [[[HealthyDeclareInfo alloc] init] autorelease];
            
            [self saveHealthyDeclareLocalInfo];
        }
        
        _drugDetailInfo = nil;
        if (_selectedsymptomExpressionArray && [_selectedsymptomExpressionArray count] > 0) {
            [self deleteSymptomExpression];
        }
        
        [self setHealthyDeclareInfoCanChanged:YES];
        
        FPAnswerOnlineViewController *fpAnswerOnlineViewController = [[[FPAnswerOnlineViewController alloc] initWithNibName:@"FPAnswerOnlineViewController" bundle:nil] autorelease];
        fpAnswerOnlineViewController.healthyDeclareInfo = _healthyDeclareInfo;
        
        [self.navigationController pushViewController:fpAnswerOnlineViewController animated:YES];
        
    } cancelBlock:nil];
    
}

#pragma mark - Methods

// 查询健康信息
- (void)queryHealthyInfo {
    
    EBArticleLogInfoQuery *ebArticleLogInfoQuery = [[[EBArticleLogInfoQuery alloc] init] autorelease];
    
    // 准备查询参数
    NSString *workNo = @" ";
    if (TaskDelegate.empId) {
        workNo = TaskDelegate.empId;
    }
    NSString *baseCode = @" ";
    if ([User currentUser].baseCode) {
        baseCode = [User currentUser].baseCode;
    }
    NSString *fltNo = @" ";
    if (TaskDelegate.flightNo) {
        fltNo = TaskDelegate.flightNo;
    }
    NSString *fltDate = @" ";
    if (TaskDelegate.flightTime) {
        fltDate = TaskDelegate.flightTime;
    }
    NSString *planeType = @" ";
    if (TaskDelegate.plane) {
        planeType = TaskDelegate.plane;
    }
    NSString *depPort = @" ";
    if (TaskDelegate.depAirport) {
        depPort = TaskDelegate.depAirport;
    }
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess];
    
    [ebArticleLogInfoQuery postEBArticleLogInfoArray:_ebArticleLogInfoArray workNo:workNo baseCode:baseCode fltNo:fltNo fltDate:fltDate planeType:planeType depPort:depPort totalTime:_totalTime completion:^(NSObject *responseObject) {
        [self loadWithHealthyInfo:responseObject];
    } failed:^(NSData *responseData) {
        
        // 查询失败，不能进入下一步，不能进行操作
        [_buttonForNextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self setHealthyDeclareInfoCanChanged:NO];
        
        [MBProgressController dismiss];
        
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"查询失败" message:@"请返回重要文件后重新进入！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
}

- (void) loadWithHealthyInfo:(NSObject *)info
{
    
    self.healthyInfo = (HealthyInfo *)info;
    
    if ([_healthyInfo.healthyFlag isEqualToString:@"Y"] || [_healthyInfo.healthyFlag isEqualToString:@"N"]) {
        [self setHealthyDeclareInfoCanChanged:NO];
    } else {
        if ([self queryHealthyDeclareLocalInfo]) {
            [self setHealthyDeclareInfoCanChanged:NO];
        }
    }
    
    [MBProgressController dismiss];
    
    NSMutableArray *symptomArray = [self convertSymptomFromLetterToChineseCharacters];
    if ([symptomArray count] != 0) {
        self.selectedsymptomExpressionArray = symptomArray;
        [self insertSymptomExpression];
    }
    
    [_healthDeclarationTableView reloadData];
    
    if (_isHealthySwitch.enabled) {
        
        NSString *serviceTime = _healthyInfo.serviceTime;
        NSString *stringDate = [serviceTime substringToIndex:16];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
        
        NSDate *serviceDate = [dateFormatter dateFromString:stringDate];
        NSDate *criticalDate = [self getCriticalDateByDepTime:TaskDelegate.depTime];
        
        NSComparisonResult comparisonResult = [serviceDate compare:criticalDate];
        
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        if (comparisonResult == NSOrderedAscending) {
            if ([_healthyInfo.unHealthyCount intValue] >= 3) {
                NSString *message = [NSString stringWithFormat:@"您近30天申报不健康次数已达%@次，请您务必予以重视！", _healthyInfo.unHealthyCount];
                [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
            }
        } else {
            
            NSString *phoneString = @"";
            if (_healthyInfo.doctorPhoneList.count >= 1) {
                for (NSString *phone in _healthyInfo.doctorPhoneList) {
                    phoneString = [phoneString stringByAppendingFormat:@"%@，", phone];
                }
                phoneString = [phoneString substringToIndex:phoneString.length - 1];
            }
            
            NSString *message = [NSString stringWithFormat:@"员工号：%@，姓名：%@，计划执行航班：%@，机型：%@，申报时间：（不满足申报时间要求）默认为健康。如有需要申报，可以直接与航医联系，联系电话：%@。您现在不能进行健康申报，申报时间范围：航班起飞时间在0:00-12:00，申报截止时间为前一天的21:00；航班起飞时间在12:00-23:59，申报截止时间为飞机起飞前3个小时。", TaskDelegate.empId, _healthyInfo.name, TaskDelegate.flightNo, TaskDelegate.plane, phoneString];
                        
            [geAlert showAlertViewWithTitle:@"提示" message:message confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:^ {
                
                FPAnswerOnlineViewController *fpAnswerOnlineViewController = [[[FPAnswerOnlineViewController alloc] initWithNibName:@"FPAnswerOnlineViewController" bundle:nil] autorelease];
                
                // 重新初始化一个空对象
                self.healthyDeclareInfo = [[[HealthyDeclareInfo alloc] init] autorelease];
                
                [self saveHealthyDeclareLocalInfo];
                
                fpAnswerOnlineViewController.healthyDeclareInfo = _healthyDeclareInfo;
                [self.navigationController pushViewController:fpAnswerOnlineViewController animated:YES];
                
                _drugDetailInfo = nil;
                if (_selectedsymptomExpressionArray) {
                    [self deleteSymptomExpression];
                }
                
                [self setHealthyDeclareInfoCanChanged:YES];
                
            } cancelBlock:nil];
        }
        
    }

}

// 将字母形式的症状表现转换成汉字形式的，例：Z-A-B -> {发热, 头晕}
- (NSMutableArray *)convertSymptomFromLetterToChineseCharacters {
    
    // 汉字形式的
    NSMutableArray *symptomChineseCharacters = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *type = [_healthyInfo.type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_healthyInfo.type && ![type isEqualToString:@""]) {
        // 字母形式的
        NSArray *symptomLetter = [_healthyInfo.type componentsSeparatedByString:@"-"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"symptomExpression" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        for (NSString *symptom in symptomLetter) {
            if (![symptom isEqualToString:@"Z"]) {
                NSString *symptomChineseCharacter = [dic objectForKey:symptom];
                [symptomChineseCharacters addObject:symptomChineseCharacter];
            }
        }
    }
    
    NSString *remark = [_healthyInfo.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (remark && ![remark isEqualToString:@""]) {
        [symptomChineseCharacters addObject:remark];
    }
    
    return symptomChineseCharacters;
    
}

// 将汉字形式的症状表现转换成字母形式的，例：{发热, 头晕} -> Z-A-B
- (NSString *)convertSymptomFromChineseCharactersToLetter {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"symptomExpression" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *symptomLetters = @"Z";
    
    for (NSString *symptom in _selectedsymptomExpressionArray) {
        if (![symptom isEqualToString:_otherDeclarationContent]) {
            NSString *symptomLetter = [[dic allKeysForObject:symptom] objectAtIndex:0];
            symptomLetters = [symptomLetters stringByAppendingFormat:@"-%@", symptomLetter];
        }
    }
    
    return symptomLetters;
    
}

// 将数组形式的症状表现转换成字母串形式的，例：{发热, 头晕} -> 发热、头晕
- (NSString *)convertSymptomFromArrayToString {
        
    NSString *symptomString = @"";
    
    for (NSString *symptom in _selectedsymptomExpressionArray) {
        if (![symptom isEqualToString:_otherDeclarationContent]) {
            symptomString = [symptomString stringByAppendingFormat:@"%@、", symptomString];
        }
    }
    
    symptomString = [symptomString substringToIndex:symptomString.length-1];
    
    return symptomString;
    
}

// 插入用户选择的症状表现
- (void)insertSymptomExpression {
    NSMutableArray *indexes = [[[NSMutableArray alloc] init] autorelease];
    for (int i=1; i <= [_selectedsymptomExpressionArray count]; i++) {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:2]];
    }
    [_healthDeclarationTableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 删除用户选择的症状表现
- (void)deleteSymptomExpression {
    NSMutableArray *indexes = [[[NSMutableArray alloc] init] autorelease];
    for (int i=1; i <= [_selectedsymptomExpressionArray count]; i++) {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:2]];
    }
    [_selectedsymptomExpressionArray removeAllObjects];
    [_healthDeclarationTableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 如果用户没有饮酒，没有服药，自我评价是健康的，则保存一份本地信息，便于以后区分有没有进行过健康申报（因为这种纪录服务器没有保存）
- (void)saveHealthyDeclareLocalInfo {
    HealthyDeclareLocalInfo *healthyDeclareLocalInfo = [HealthyDeclareLocalInfo insert];
    healthyDeclareLocalInfo.staffNo = TaskDelegate.empId;
    healthyDeclareLocalInfo.fltDate = TaskDelegate.flightDate;
    healthyDeclareLocalInfo.fltNo = TaskDelegate.flightNo;
    [HealthyDeclareLocalInfo save];
}

// 设置健康申报界面信息是否可更改
- (void)setHealthyDeclareInfoCanChanged:(BOOL)canChanged {
    if (canChanged) {
        _isDrinkSwitch.enabled = YES;
        _isMedicationSwitch.enabled = YES;
        _isHealthySwitch.enabled = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        FPButtonTableViewCell *cell = (FPButtonTableViewCell *)[_healthDeclarationTableView cellForRowAtIndexPath:indexPath];
        cell.customButton.enabled = YES;
    } else {
        _isDrinkSwitch.enabled = NO;
        _isMedicationSwitch.enabled = NO;
        _isHealthySwitch.enabled = NO;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        FPButtonTableViewCell *cell = (FPButtonTableViewCell *)[_healthDeclarationTableView cellForRowAtIndexPath:indexPath];
        cell.customButton.enabled = NO;
    }
}

// 查询本地是否保存有"否否是"的健康申报记录
- (HealthyDeclareLocalInfo *)queryHealthyDeclareLocalInfo {
    NSString *staffNo = TaskDelegate.empId;
    NSString *fltDate = TaskDelegate.flightDate;
    NSString *fltNo = TaskDelegate.flightNo;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"staffNo == %@ AND fltDate == %@ AND fltNo == %@", staffNo, fltDate, fltNo];
    HealthyDeclareLocalInfo *resultObject = [HealthyDeclareLocalInfo getByPredicate:predicate];
    return resultObject;
}

// 根据计划起飞时间得到做健康申报的临界时间
- (NSDate *)getCriticalDateByDepTime:(NSString *)DepTime {
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    DepTime = [DepTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    NSArray *dateArray = [DepTime componentsSeparatedByString:@" "];
    
    // 日期
    NSString *stringDate = [dateArray objectAtIndex:0];
    // 时间
    NSString *stringTime = [dateArray objectAtIndex:1];
    
    // 将时间转换成浮点数进行比较
    NSString *floatTime = [stringTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    float time = [floatTime floatValue];
    
    // 计划起飞时间在00:00到11:59之间，要前一天21点之前提出申请
    if (time >= 0.00 && time <= 11.59) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:stringDate];
        NSTimeInterval timeInterval = -3*60*60;
        return [NSDate dateWithTimeInterval:timeInterval sinceDate:date];
    } else {
        // 计划起飞时间在12:00到23:59之间，要在起飞前3小时提出申请
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:DepTime];
        NSTimeInterval timeInterval = -3*60*60;
        return [NSDate dateWithTimeInterval:timeInterval sinceDate:date];
    }
    
}

@end
