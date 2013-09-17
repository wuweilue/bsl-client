//
//  RecentTalkView.h
//  cube-ios
//
//  Created by apple2310 on 13-9-12.
//
//

#import "TouchScroller.h"

@class RecentTalkView;
@class RectangleChat;
@protocol RecentTalkViewDelegate <NSObject>
-(void)rectentTalkViewDidSelected:(RecentTalkView*)recentTalkView rectangleChat:(RectangleChat*)rectangleChat;

@end

@interface RecentTalkView : TouchTableView{
    NSMutableArray* list;
    
    NSTimer* laterReloadTimer;
}
@property(nonatomic,weak) id<RecentTalkViewDelegate> rectentDelegate;
-(void)loadData;
@end
