//
//  TouchScroller.h
//  TouchLibrary
//
//  Created by fanty on 13-4-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchScrollerDelegate <NSObject>
@optional
- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UIScrollView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;

@end

@interface  TouchScrollView : UIScrollView
@property (nonatomic,weak) id<TouchScrollerDelegate> touchDelegate;
@end

@interface TouchTableView : UITableView
@property (nonatomic,weak) id<TouchScrollerDelegate> touchDelegate;
@end
