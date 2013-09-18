//
//  ChatCell.h
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageDownloadedView;

typedef enum{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse
} NSBubbleType;

@class AsyncImageView;

@interface ChatCell : UITableViewCell{
    AsyncImageView* imageView;
    UILabel* nameLabel;
    UIImageView* noHeaderView;
    UIImageView* bubbleView;
    UILabel* contentLabel;
    UILabel* dateLabel;
}

@property(nonatomic,retain) NSDictionary* emoctionList;

+(UIImage*)bubbleSomeoneImg;
+(UIImage*)bubbleMineImg;


+(float)cellHeight:(NSString*)content bubbleType:(NSBubbleType)bubbleType emoctionList:(NSDictionary*) emoctionList;
-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name content:(NSString*)content sendDate:(NSDate*)date bubbleType:(NSBubbleType)bubbleType;

@end
