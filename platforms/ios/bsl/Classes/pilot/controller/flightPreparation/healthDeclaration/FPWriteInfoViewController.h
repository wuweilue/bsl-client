//
//  FPWriteInfoViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-12.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPHealthDeclarationViewController.h"

@interface FPWriteInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

// 用于让用户输入所服用药品的名称
@property (retain, nonatomic) IBOutlet UITableView *writeInfoTableView;

@property (retain, nonatomic) FPHealthDeclarationViewController *fpHealthDeclarationViewController;

@end
