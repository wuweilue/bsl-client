//
//
//  GroupManagerControllerViewController.m
//  cube-ios
//
//  Created by Mr Right on 13-8-13.
//
//

#import <UIKit/UIKit.h>


@interface MultiSelectTableViewCell : UITableViewCell 
{
    UIImageView *  _mSelectedIndicator; //show the selected mark
    BOOL           _mSelected;        //differ from property selected
}

@property (nonatomic, assign) BOOL mSelected;


- (void)changeMSelectedState;
-(void)config;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@end
