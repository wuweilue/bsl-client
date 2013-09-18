//
//  InputAlertView.h
//  
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAlertView : UIAlertView<UIAlertViewDelegate>{
    UILabel *titleView;
    UITextField* textField;
    
}
@property(nonatomic,weak) id<UIAlertViewDelegate> callback;

-(void)showTitle:(NSString*)value;
-(void)showTextField;
-(void)textFieldText:(NSString*)value;
-(NSString*)textFieldText;

@end
