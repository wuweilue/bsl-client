//
//  ContactCheckBoxCell.h
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;

@interface ContactCheckBoxCell : UITableViewCell{
    UIImageView* roundImageView;
    UIImageView* checkboxImageView;
    
    ImageDownloadedView* imageView;
    UILabel* nicknameLabel;
    UIImageView* lineView;
    
}

-(void)headerUrl:(NSString*)headerUrl nickname:(NSString*)nickname;

+(float)height;

-(void)setChecked:(BOOL)value animate:(BOOL)animate;

@end
