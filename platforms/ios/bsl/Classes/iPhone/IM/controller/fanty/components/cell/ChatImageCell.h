//
//  ChatImageCell.h
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import <UIKit/UIKit.h>
#import "ChatCell.h"


@class ChatImageCell;
@class AsyncImageView;

@protocol ChatImageCellDelegate <NSObject>

-(void)chatImageCellDidSelect:(ChatImageCell*)cell image:(UIImage*)image;

@end

@interface ChatImageCell : UITableViewCell{
    AsyncImageView* imageView;
    UIImageView* noHeaderView;

    UIButton* avatorView;
    UIImageView* bubbleView;
    UILabel* nameLabel;

    AsyncImageView* contentImageView;
    
    UIImageView* noContentView;
    UILabel* dateLabel;

}
@property(nonatomic,weak) id<ChatImageCellDelegate> delegate;
+(float)cellHeight:(NSBubbleType)bubbleType;
-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name imageFile:(NSString*)imageFile sendDate:(NSDate*)date bubbleType:(NSBubbleType)bubbleType;

@end
