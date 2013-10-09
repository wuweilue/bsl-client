//
//  NewLoginViewCell.h
//  Mcs
//
//  Created by shaomou chen on 6/11/12.
//  Copyright (c) 2012 RYTong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UITextField *valueTextField;
@property (retain, nonatomic) IBOutlet UILabel *keyLabel;
@property (retain, nonatomic) IBOutlet UIButton *rememberBtn;
-(void)configure:(NSString *)key value:(NSString *)value secure:(BOOL)secure;
@end
