//
//  TestCell.h
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "RatingView.h"

@interface MsgListCell : UITableViewCell
{
    
    UIImageView *_headPhoto;
    UILabel *_headText;
    UILabel *_msgTitle;
    UITextView *_msgContent;
    UILabel *_receiveTime;
    RatingView *_rateView;
    BOOL _isReaded;

}

@property BOOL isReaded;
@property (strong, nonatomic) IBOutlet UIImageView *headPhoto;
@property (strong, nonatomic) IBOutlet UILabel *headText;
@property (strong, nonatomic) IBOutlet UILabel *msgTitle;
@property (strong, nonatomic) IBOutlet UITextView *msgContent;
@property (strong, nonatomic) IBOutlet UILabel *receiveTime;
@property (strong, nonatomic) IBOutlet RatingView *rateView;


@end
