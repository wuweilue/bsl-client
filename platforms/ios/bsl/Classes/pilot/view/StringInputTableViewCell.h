//
//  StringInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringInputTableViewCell;

@protocol StringInputTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value;
- (void)tableViewCell:(StringInputTableViewCell *)cell didBeginEditing:(UITextField *)textField;
@end


@interface StringInputTableViewCell : UITableViewCell <UITextFieldDelegate> {
	UITextField *textField;
}

@property (nonatomic, retain) NSString *stringValue;
@property (nonatomic, retain) UITextField *textField;
@property (assign) IBOutlet id<StringInputTableViewCellDelegate> delegate;

@end
