//
//  GroupPanel.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-18.
//
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GroupPanel;

@protocol GroupPanelDelegate <NSObject>

-(void)addGroupClick:(GroupPanel*)groupPanel;
-(void)removeGroupClick:(GroupPanel*)groupPanel;
@end

@interface GroupSubPanel : UIButton{
    ImageDownloadedView* imageDownloadedView;
    UIButton* closeButton;
    UILabel* titleLabel;
}
@end

@interface GroupPanel : UIView{
    NSMutableArray*  list;
    
    UIButton* uploadButton;

}

@property(nonatomic,strong) NSString* selectedJid;
@property(nonatomic,weak) id<GroupPanelDelegate> delegate;

-(void)setArray:(NSArray*)userInfos;

-(void)hideAddButton;

-(void)hideRemoveButtons;

-(void)removeUserJid:(NSString*)jid;

@end
