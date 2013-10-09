//
//  FPAnswerOnlineViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPAnswerOnlineViewController.h"
#import "ExamInfo.h"
#import "GEAlertViewDelegate.h"
#import "EBExamLogInfoQuery.h"
#import "FPCoordinatingController.h"
#import "EBExamLogInfo.h"
#import "HealthyDeclareInfoQuery.h"
#import "FPButtonTableViewCell.h"
#import "FPOptionTableViewCell.h"
#import "MBProgressController.h"
#import "NSArray+Randomized.h"
#import "User.h"
#import "LandingViewController.h"

#define COUNT 10

@interface FPAnswerOnlineViewController ()

@end

@implementation FPAnswerOnlineViewController

@synthesize questionListTableView = _questionListTableView;
@synthesize questionArray = _questionArray;
@synthesize isShowAnswer = _isShowAnswer;
@synthesize showAnswerArray = _showAnswerArray;
@synthesize selectedIndexPaths = _selectedIndexPaths;
@synthesize ebExamLogInfoArray = _ebExamLogInfoArray;
@synthesize totalScore = _totalScore;
@synthesize healthyDeclareInfo = _healthyDeclareInfo;

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
    
    self.title = @"网上答题";
    
    self.isShowAnswer = NO;
    
    self.showAnswerArray = [[[NSMutableArray alloc] init] autorelease];
    self.selectedIndexPaths = [[[NSMutableArray alloc] init] autorelease];
    self.ebExamLogInfoArray = [[[NSMutableArray alloc] init] autorelease];
    
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"  健康申报" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.tag = kbuttonTagBack;
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [leftButtonItem release];
    
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
    _questionListTableView.backgroundView = imageView;
    [imageView release];
}

- (void)viewDidUnload
{
    [self setQuestionListTableView:nil];
    [self setQuestionArray:nil];
    [self setShowAnswerArray:nil];
    [self setSelectedIndexPaths:nil];
    [self setEbExamLogInfoArray:nil];
    [self setHealthyDeclareInfo:nil];
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
    [self queryQuestionList];
}

- (void)dealloc {
    [_questionListTableView release];
    [_questionArray release];
    [_showAnswerArray release];
    [_selectedIndexPaths release];
    [_ebExamLogInfoArray release];
    [_healthyDeclareInfo release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return COUNT+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == COUNT) {
        return [self numberOfRowsInSection:section];
    } else {
        if (_isShowAnswer)
            return [self numberOfRowsInSection:section]+1;
        else
            return [self numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == COUNT) {
        static NSString *identifier = @"ButtonTableViewCell";
        FPButtonTableViewCell *cell = (FPButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [FPButtonTableViewCell getInstance];
        }
        
        if (_isShowAnswer) {
            [cell.customButton setTitle:@"重考" forState:UIControlStateNormal];
        } else {
            [cell.customButton setTitle:@"提交" forState:UIControlStateNormal];
        }
        
        UIImage *image = nil;
        if (device_Type == UIUserInterfaceIdiomPhone) {
            image = [[UIImage imageNamed:@"Button_Green_Phone.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        } else {
            image = [[UIImage imageNamed:@"Button_Green_Pad.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        }
        
        // 去掉cell的边框
        UIView *backgroundView = [[[UIView alloc] init] autorelease];
        cell.backgroundView = backgroundView;
        
        [cell.customButton setBackgroundImage:image forState:UIControlStateNormal];
        [cell.customButton setBackgroundImage:image forState:UIControlStateHighlighted];
        
        [cell.customButton addTarget:self action:@selector(commitOrReexamine:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!_questionArray) {
            cell.customButton.enabled = NO;
        } else {
            cell.customButton.enabled = YES;
        }
        
        return cell;
    }
    
    ExamInfo *examInfo = [_questionArray objectAtIndex:indexPath.section];
    
    UIImage *RadioButtonSelectedImage = [UIImage imageNamed:@"RadioButton-Selected"];
    UIImage *RadioButtonUnselectedImage = [UIImage imageNamed:@"RadioButton-Unselected"];
    
    UIImage *CheckBoxSelectedImage = [UIImage imageNamed:@"cb_glossy_on"];
    UIImage *CheckBoxUnselectedImage = [UIImage imageNamed:@"cb_glossy_off"];
    
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"UITableViewCellStyleSubtitle";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        } else {
            cell.accessoryView = nil;
        }

        NSString *examTextString = nil;
        if (examInfo) {
            examTextString = [self getExamTextStringByExamInfo:examInfo];
            cell.textLabel.text = [NSString stringWithFormat:@"%d、%@", indexPath.section+1, examTextString];
            cell.detailTextLabel.text = @"";
            
            examInfo.reference = [examInfo.reference stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (examInfo.reference && ![examInfo.reference isEqualToString:@""]) {
                
                UIButton *showReferenceButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
                [showReferenceButton addTarget:self action:@selector(showReference:) forControlEvents:UIControlEventTouchUpInside];
                showReferenceButton.tag = indexPath.section;
                
                cell.accessoryView = showReferenceButton;
            }
            
        } else {
            cell.detailTextLabel.text = @"正在加载...";
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
        return cell;
        
    } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]) {
        
        static NSString *identifier = @"UITableViewCellStyleDefault";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        }
        
        cell.textLabel.text = [_showAnswerArray objectAtIndex:indexPath.section];
        
        NSString *answerResult = [[_ebExamLogInfoArray objectAtIndex:indexPath.section] result];
        if ([answerResult isEqualToString:@"Y"]) {
            cell.textLabel.textColor = [UIColor blueColor];
        } else {
            cell.textLabel.textColor = [UIColor redColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"OptionTableViewCell";
        FPOptionTableViewCell *cell = (FPOptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [FPOptionTableViewCell geInstance];
        }
        
        if (_isShowAnswer) {
            cell.userInteractionEnabled = NO;
        } else {
            cell.userInteractionEnabled = YES;
        }
                
        if (examInfo.answer.length == 1) {
            if ([_selectedIndexPaths containsObject:indexPath]) {
                cell.optionStateImageView.image = RadioButtonSelectedImage;
            } else {
                cell.optionStateImageView.image = RadioButtonUnselectedImage;
            }
        } else {
            if ([_selectedIndexPaths containsObject:indexPath]) {
                cell.optionStateImageView.image = CheckBoxSelectedImage;
            } else {
                cell.optionStateImageView.image = CheckBoxUnselectedImage;
            }
        }
        
        if (indexPath.row == 1) {
            cell.optionLabel.text = examInfo.opt1;
        } else if (indexPath.row == 2) {
            cell.optionLabel.text = examInfo.opt2;
        } else if (indexPath.row == 3) {
            cell.optionLabel.text = examInfo.opt3;
        } else {
            cell.optionLabel.text = examInfo.opt4;
        }
        
        cell.optionLabel.numberOfLines = 0;
        cell.optionLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.optionLabel.font = [UIFont systemFontOfSize:18];
                        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == COUNT) {
        return 44;
    } else {
        
        CGSize size = CGSizeZero;

        UIFont *font = [UIFont boldSystemFontOfSize:18.0];
        
        ExamInfo *examInfo = [_questionArray objectAtIndex:indexPath.section];
        
        NSString *examTextString = nil;
        if (examInfo) {
            examTextString = [self getExamTextStringByExamInfo:examInfo];
        }
        
        if (device_Type == UIUserInterfaceIdiomPhone) {
            if (indexPath.row == 0) {
                size = [[NSString stringWithFormat:@"%d、%@", indexPath.section+1, examTextString] sizeWithFont:font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:UILineBreakModeWordWrap];
            } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]) {
                return 44;
            } else {
                if (indexPath.row == 1) {
                    size = [examInfo.opt1 sizeWithFont:font constrainedToSize:CGSizeMake(248, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 2) {
                    size = [examInfo.opt2 sizeWithFont:font constrainedToSize:CGSizeMake(248, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 3) {
                    size = [examInfo.opt3 sizeWithFont:font constrainedToSize:CGSizeMake(248, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else {
                    size = [examInfo.opt4 sizeWithFont:font constrainedToSize:CGSizeMake(248, 1000) lineBreakMode:UILineBreakModeWordWrap];
                }
            }
        } else {
                    
            if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                if (indexPath.row == 0) {
                    size = [[NSString stringWithFormat:@"%d、%@", indexPath.section+1, examTextString] sizeWithFont:font constrainedToSize:CGSizeMake(602, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]) {
                    return 44;
                } else if (indexPath.row == 1) {
                    size = [examInfo.opt1 sizeWithFont:font constrainedToSize:CGSizeMake(613, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 2) {
                    size = [examInfo.opt2 sizeWithFont:font constrainedToSize:CGSizeMake(613, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 3) {
                    size = [examInfo.opt3 sizeWithFont:font constrainedToSize:CGSizeMake(613, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 4) {
                    size = [examInfo.opt4 sizeWithFont:font constrainedToSize:CGSizeMake(613, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } 
            } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                if (indexPath.row == 0) {
                    size = [[NSString stringWithFormat:@"%d、%@", indexPath.section+1, examTextString] sizeWithFont:font constrainedToSize:CGSizeMake(858, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]) {
                    return 44;
                } else if (indexPath.row == 1) {
                    size = [examInfo.opt1 sizeWithFont:font constrainedToSize:CGSizeMake(859, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 2) {
                    size = [examInfo.opt2 sizeWithFont:font constrainedToSize:CGSizeMake(859, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 3) {
                    size = [examInfo.opt3 sizeWithFont:font constrainedToSize:CGSizeMake(859, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } else if (indexPath.row == 4) {
                    size = [examInfo.opt4 sizeWithFont:font constrainedToSize:CGSizeMake(859, 1000) lineBreakMode:UILineBreakModeWordWrap];
                } 
            }
        }

        return size.height + 22;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != COUNT) {
        
        UIImage *RadioButtonSelectedImage = [UIImage imageNamed:@"RadioButton-Selected"];
        UIImage *RadioButtonUnselectedImage = [UIImage imageNamed:@"RadioButton-Unselected"];
        
        UIImage *CheckBoxSelectedImage = [UIImage imageNamed:@"cb_glossy_on"];
        UIImage *CheckBoxUnselectedImage = [UIImage imageNamed:@"cb_glossy_off"];
    
        ExamInfo *examInfo = [_questionArray objectAtIndex:indexPath.section];
        
        if (indexPath.row != [self numberOfRowsInSection:indexPath.section]) {
            if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
                FPOptionTableViewCell *cell = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                if (examInfo.answer.length == 1) {
                    
                    if (cell.optionStateImageView.image == RadioButtonUnselectedImage) {
                        cell.optionStateImageView.image = RadioButtonSelectedImage;
                        [_selectedIndexPaths addObject:indexPath];
                    }
                    
                    if (indexPath.row == 1) {
                        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
                        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:indexPath.section];
                        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:indexPath.section];
                        FPOptionTableViewCell *cell2 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath2];
                        FPOptionTableViewCell *cell3 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath3];
                        FPOptionTableViewCell *cell4 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath4];
                        cell2.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell3.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell4.optionStateImageView.image = RadioButtonUnselectedImage;
                        [_selectedIndexPaths removeObject:indexPath2];
                        [_selectedIndexPaths removeObject:indexPath3];
                        [_selectedIndexPaths removeObject:indexPath4];
                    } else if (indexPath.row == 2) {
                        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:indexPath.section];
                        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:indexPath.section];
                        FPOptionTableViewCell *cell1 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath1];
                        FPOptionTableViewCell *cell3 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath3];
                        FPOptionTableViewCell *cell4 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath4];
                        cell1.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell3.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell4.optionStateImageView.image = RadioButtonUnselectedImage;
                        [_selectedIndexPaths removeObject:indexPath1];
                        [_selectedIndexPaths removeObject:indexPath3];
                        [_selectedIndexPaths removeObject:indexPath4];
                    } else if (indexPath.row == 3) {
                        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
                        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:indexPath.section];
                        FPOptionTableViewCell *cell1 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath1];
                        FPOptionTableViewCell *cell2 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath2];
                        FPOptionTableViewCell *cell4 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath4];
                        cell1.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell2.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell4.optionStateImageView.image = RadioButtonUnselectedImage;
                        [_selectedIndexPaths removeObject:indexPath1];
                        [_selectedIndexPaths removeObject:indexPath2];
                        [_selectedIndexPaths removeObject:indexPath4];
                    } else {
                        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
                        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:indexPath.section];
                        FPOptionTableViewCell *cell1 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath1];
                        FPOptionTableViewCell *cell2 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath2];
                        FPOptionTableViewCell *cell3 = (FPOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath3];
                        cell1.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell2.optionStateImageView.image = RadioButtonUnselectedImage;
                        cell3.optionStateImageView.image = RadioButtonUnselectedImage;
                        [_selectedIndexPaths removeObject:indexPath1];
                        [_selectedIndexPaths removeObject:indexPath2];
                        [_selectedIndexPaths removeObject:indexPath3];
                    }

                } else {
                    if (cell.optionStateImageView.image == CheckBoxUnselectedImage) {
                        cell.optionStateImageView.image = CheckBoxSelectedImage;
                        [_selectedIndexPaths addObject:indexPath];
                    } else {
                        cell.optionStateImageView.image = CheckBoxUnselectedImage;
                        [_selectedIndexPaths removeObject:indexPath];
                    }
                }
                
            }
        }
    }
}

#pragma mark - Actions

-(void)requestChangeView:(id)sender{
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
}

// 提交或重考按钮点击事件
- (void)commitOrReexamine:(UIButton *)sender {
    if (!_isShowAnswer) {
        self.totalScore = 0;
        
        for (int i=0; i<=COUNT-1; i++) {
            
            EBExamLogInfo *ebExamLogInfo = [[[EBExamLogInfo alloc] init] autorelease];
            
            ExamInfo *examInfo = [_questionArray objectAtIndex:i];
            int answer = [examInfo.answer intValue];

            ebExamLogInfo.seqNum = examInfo.seqNum;
            ebExamLogInfo.staffNo = TaskDelegate.empId;
            
            NSDateFormatter *dateFormator = [[[NSDateFormatter alloc] init] autorelease];
            dateFormator.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *date = [dateFormator stringFromDate:[NSDate date]];
            ebExamLogInfo.testDate = date;
            
            NSString *baseCode = @" ";
            if ([User currentUser].baseCode) {
                baseCode = [User currentUser].baseCode;
            }
            ebExamLogInfo.baseCode = baseCode;
            ebExamLogInfo.fltNo = TaskDelegate.flightNo;
            ebExamLogInfo.fltDate = TaskDelegate.flightTime;
            ebExamLogInfo.moduleId = @"0906";
            
            if ([examInfo.answer length] == 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:answer inSection:i];
                if ([_selectedIndexPaths containsObject:indexPath]) {
                    NSString *answerString = [NSString stringWithFormat:@"回答正确，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    _totalScore = _totalScore + 10;
                    
                    ebExamLogInfo.result = @"Y";
                } else {
                    NSString *answerString = [NSString stringWithFormat:@"回答错误，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    
                    ebExamLogInfo.result = @"N";
                }
            } else if ([examInfo.answer length] == 2) {
                int answer1 = answer/10;
                int answer2 = answer%10;
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:answer1 inSection:i];
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:answer2 inSection:i];
                if ([_selectedIndexPaths containsObject:indexPath1] && [_selectedIndexPaths containsObject:indexPath2] && [self numberOfUserSelectedOptionInSection:i] == 2) {
                    NSString *answerString = [NSString stringWithFormat:@"回答正确，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    _totalScore = _totalScore + 10;
                    
                    ebExamLogInfo.result = @"Y";
                } else {
                    NSString *answerString = [NSString stringWithFormat:@"回答错误，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    
                    ebExamLogInfo.result = @"N";
                }
            } else if ([examInfo.answer length] == 3) {
                int answer1 = answer/100;
                int answer2 = (answer%100)/10;
                int answer3 = (answer%100)%10;
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:answer1 inSection:i];
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:answer2 inSection:i];
                NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:answer3 inSection:i];
                if ([_selectedIndexPaths containsObject:indexPath1] && [_selectedIndexPaths containsObject:indexPath2] && [_selectedIndexPaths containsObject:indexPath3] && [self numberOfUserSelectedOptionInSection:i] == 3) {
                    NSString *answerString = [NSString stringWithFormat:@"回答正确，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    _totalScore = _totalScore + 10;
                    
                    ebExamLogInfo.result = @"Y";
                } else {
                    NSString *answerString = [NSString stringWithFormat:@"回答错误，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    
                    ebExamLogInfo.result = @"N";
                }
            } else {
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:i];
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:i];
                NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:i];
                NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:i];
                if ([_selectedIndexPaths containsObject:indexPath1] && [_selectedIndexPaths containsObject:indexPath2] && [_selectedIndexPaths containsObject:indexPath3] && [_selectedIndexPaths containsObject:indexPath4]) {
                    NSString *answerString = [NSString stringWithFormat:@"回答正确，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    _totalScore = _totalScore + 10;
                    
                    ebExamLogInfo.result = @"Y";
                } else {
                    NSString *answerString = [NSString stringWithFormat:@"回答错误，正确答案为%@。", [self numberToLetterAnswer:examInfo.answer]];
                    [_showAnswerArray addObject:answerString];
                    
                    ebExamLogInfo.result = @"N";
                }
            }
            
            [_ebExamLogInfoArray addObject:ebExamLogInfo];
        }
        
        // 准备查询参数
        NSString *staffNo = @" ";
        if (TaskDelegate.empId) {
            staffNo = TaskDelegate.empId;
        }
        NSString *fltNo = @" ";
        if (TaskDelegate.flightNo) {
            fltNo = TaskDelegate.flightNo;
        }
        NSString *fltDate = @" ";
        if (TaskDelegate.flightTime) {
            fltDate = TaskDelegate.flightTime;
        }
        NSString *depPort = @" ";
        if (TaskDelegate.depAirport) {
            depPort = TaskDelegate.depAirport;
        }
        
        [[MBProgressController getCurrentController] setMessage:@"正在提交..."];
        [MBProgressController startQueryProcess];
        
        NSDate *date = [NSDate date];
        NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
        NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
        
        EBExamLogInfoQuery *ebExamLogInfoQuery = [[[EBExamLogInfoQuery alloc] init] autorelease];
        [ebExamLogInfoQuery postEBExamLogInfoArray:_ebExamLogInfoArray staffNo:staffNo fltNo:fltNo fltDate:fltDate depPort:depPort totalTime:totalTime completion:^(NSObject *responseObject) {
            
            [MBProgressController dismiss];
        
            if (_totalScore < (COUNT-2)*10) {
                NSString *promptString = [NSString stringWithFormat:@"您没有通过答题，成绩为%d分。", _totalScore];
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:promptString delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新答题", @"查看解析", nil] autorelease];
                [alertView show];
            } else {
                GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
                
                NSString *promptString = [NSString stringWithFormat:@"恭喜您通过答题，成绩为%d分，点击确定完成飞行准备！", _totalScore];
                [geAlert showAlertViewWithTitle:@"提示" message:promptString confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:^ {
                    
                    [_showAnswerArray removeAllObjects];
                    [_selectedIndexPaths removeAllObjects];
                    [_ebExamLogInfoArray removeAllObjects];
                    
//                    [self.navigationController dismissModalViewControllerAnimated:YES];
//                    [self.navigationController popToRootViewControllerAnimated:NO];
                    NSArray *vcArr = [self.navigationController viewControllers];
                    for (UIViewController *vc in vcArr) {
                        if ([vc isKindOfClass:[LandingViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    
                } cancelBlock:nil];
            }
            
        } failed:^(NSData *responseData) {
            [MBProgressController dismiss];
            
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            
            NSString *promptString = @"提交失败，请稍后重试！";
            [geAlert showAlertViewWithTitle:@"提示" message:promptString confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
            
            [_showAnswerArray removeAllObjects];
            [_ebExamLogInfoArray removeAllObjects];
        }];
    } else {
        [_showAnswerArray removeAllObjects];
        [_selectedIndexPaths removeAllObjects];
        [_ebExamLogInfoArray removeAllObjects];
        
        _isShowAnswer = NO;
        
        // 题目随机排序
        self.questionArray = [_questionArray randomizedArray];
        [_questionListTableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_questionListTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)showReference:(UIButton *)button {
    GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
    
    ExamInfo *examInfo = [_questionArray objectAtIndex:button.tag];
    [geAlert showAlertViewWithTitle:@"提示信息" message:examInfo.reference confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
}

#pragma mark - Methods

- (NSInteger)numberOfUserSelectedOptionInSection:(NSInteger)section {
    NSInteger count = 0;
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:section];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:section];
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:section];
    NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:section];
    if ([_selectedIndexPaths containsObject:indexPath1]) {
        count++;
    }
    if ([_selectedIndexPaths containsObject:indexPath2]) {
        count++;
    }
    if ([_selectedIndexPaths containsObject:indexPath3]) {
        count++;
    }
    if ([_selectedIndexPaths containsObject:indexPath4]) {
        count++;
    }
    return count;
}

// 查询题目列表
- (void)queryQuestionList {
    MBProgressHUD *mbProgressHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    
    mbProgressHUD.labelText = @"正在查询...";
    mbProgressHUD.minSize = CGSizeMake(135.f, 90.f);
    
    mbProgressHUD.opacity = 0.8f;
    
    [mbProgressHUD show:YES];
    
    [self.view addSubview:mbProgressHUD];
    
    HealthyDeclareInfoQuery *healthyDeclareInfoQuery = [[[HealthyDeclareInfoQuery alloc] init] autorelease];
    
    NSString *date = @" ";
    if (TaskDelegate.flightDate) {
        date = TaskDelegate.flightDate;
    }
    NSString *baseCode = @" ";
    if ([User currentUser].baseCode) {
        baseCode = [User currentUser].baseCode;
    }
    NSString *planeType = @" ";
    if (TaskDelegate.plane) {
        planeType = TaskDelegate.plane;
    }
    NSString *staffNo = @" ";
    if (TaskDelegate.empId) {
        staffNo = TaskDelegate.empId;
    }
    NSString *fltNo = @" ";
    if (TaskDelegate.flightNo) {
        fltNo = TaskDelegate.flightNo;
    }
    NSString *fltDate = @" ";
    if (TaskDelegate.flightTime) {
        fltDate = TaskDelegate.flightTime;
    }
    NSString *depPort = @" ";
    if (TaskDelegate.depAirport) {
        depPort = TaskDelegate.depAirport;
    }
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval totalTimeDouble = [nowDate timeIntervalSinceDate:TaskDelegate.lastTime];
    NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime = nowDate;
    
    [healthyDeclareInfoQuery postObject:_healthyDeclareInfo date:date baseCode:baseCode planeType:planeType staffNo:staffNo fltNo:fltNo fltDate:fltDate depPort:depPort totalTime:totalTime completion:^(NSArray *responseArray) {
        [mbProgressHUD hide:YES];
        [mbProgressHUD removeFromSuperview];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        if (0 == [responseArray count] || nil == responseArray) {
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"查询失败" message:@"请返回健康申报后重新进入！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        } else {
            for (ExamInfo *examInfo in responseArray) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"answer" ofType:@"plist"];
                NSDictionary *answerDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
                
                examInfo.answer = [examInfo.answer stringByReplacingOccurrencesOfString:@"," withString:@""];
                NSArray *allKeys = [answerDictionary allKeysForObject:examInfo.answer];
                if ([allKeys count] != 0) {
                    examInfo.answer = [allKeys objectAtIndex:0];
                }
            }
            
            self.questionArray = responseArray;
            [_questionListTableView reloadData];
        }
    } failed:^(NSData *responseData) {
        [mbProgressHUD hide:YES];
        [mbProgressHUD removeFromSuperview];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"查询失败" message:@"请返回健康申报后重新进入！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
}

// 题干加上选项的个数，因为选项不一定为四个
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 1;
    if (section != COUNT) {
        ExamInfo *examInfo = [_questionArray objectAtIndex:section];
        if (examInfo.opt1 && ![[examInfo.opt1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            number++;
        }
        if (examInfo.opt2 && ![[examInfo.opt2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            number++;
        }
        if (examInfo.opt3 && ![[examInfo.opt3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            number++;
        }
        if (examInfo.opt4 && ![[examInfo.opt4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            number++;
        }
    }
    return number;
}

- (NSString *)getExamTextStringByExamInfo:(ExamInfo *)examInfo {
    // 对从服务器查询到题目的题干进行处理，去掉原有的编号
    NSMutableString *examString = [NSMutableString stringWithString:examInfo.examText];
    
    NSError *error;
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\d+[、.．]" options:NSRegularExpressionCaseInsensitive error:&error];
    [regularExpression replaceMatchesInString:examString options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [examString length]) withTemplate:@""];
    [regularExpression release];
    
    NSString *examTextString = @"";
    if (examInfo.answer.length == 1) {
        examTextString = [examTextString stringByAppendingFormat:@"%@%@",examString,@"(单选题)"];
    } else {
        examTextString = [examTextString stringByAppendingFormat:@"%@%@",examString,@"(多选题)"];
    }
    
    examTextString = [examTextString stringByReplacingOccurrencesOfString:@"（多选）" withString:@""];
    examTextString = [examTextString stringByReplacingOccurrencesOfString:@"（单选）" withString:@""];
    
    return examTextString;
}

- (NSString *)numberToLetterAnswer:(NSString *)answer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"answer" ofType:@"plist"];
    NSDictionary *answerDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *letterAnswer = [answerDictionary objectForKey:answer];
    return letterAnswer;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 清除数据
        [_showAnswerArray removeAllObjects];
        [_selectedIndexPaths removeAllObjects];
        [_ebExamLogInfoArray removeAllObjects];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_questionListTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.questionArray = [_questionArray randomizedArray];
        [_questionListTableView reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_questionListTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        _isShowAnswer = YES;
        [_questionListTableView reloadData];
    }
}

@end
