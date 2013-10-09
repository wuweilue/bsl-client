//
//  PDFDocumentsCheckBoxCell.h
//  pilot
//
//  Created by Sencho Kong on 12-10-17.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ebook.h"

@protocol PDFDocumentsCheckBoxCellDelegate <NSObject>

-(void)didClickCheckBoxButton:(UIButton*)button bookTitle:(NSString*)title Check:(BOOL)isCheck;

-(void)didClickCheckBoxButton:(UIButton*)button ebook:(Ebook*)aEbook Check:(BOOL)isCheck;

@end

@interface PDFDocumentsCheckBoxCell : UITableViewCell


@property(nonatomic,retain)UIButton*    checkBoxButton;
@property(nonatomic,retain)UIImageView* bookImageView;
@property(nonatomic,retain)UILabel*     bookTitleLabel;
@property(nonatomic,retain)UILabel*     progressLabel;
@property(assign)id <PDFDocumentsCheckBoxCellDelegate> delegate;
@property(nonatomic,assign)BOOL                   isChecked;      //是否选中标识状态
@property(nonatomic,assign)BOOL                   isFound;        //是否找到关键字状态
@property(nonatomic,assign)BOOL                   isNotFound;      //找不到结果的状态，
@property(nonatomic,retain)Ebook* aEbook;


-(void)spinnerStartAnimating;
-(void)spinnerStopAnimating;

@end
