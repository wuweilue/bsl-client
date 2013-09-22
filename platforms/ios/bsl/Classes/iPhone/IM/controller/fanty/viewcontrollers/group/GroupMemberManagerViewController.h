//
//  GroupMemberManagerViewController.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-18.
//
//

#import <UIKit/UIKit.h>

@class GroupPanel;
@class NSManagedObjectContext;
@class NSFetchedResultsController;

@class GroupMemberManagerViewController;

@protocol GroupMemberManagerViewControllerDelegate <NSObject>

-(void)updateMemberName:(GroupMemberManagerViewController*)controller memberName:(NSString*)memberName;

@end

@interface GroupMemberManagerViewController : UIViewController{
    UITableView* tableView;
    GroupPanel* groupPanel;
    UIButton* quitButton;
    NSMutableArray* list;
    
    NSManagedObjectContext *managedObjectContext;
    
    NSFetchedResultsController *fetchedResultsController;

    UIPopoverController *popover;

//btn_red
}
@property(nonatomic,weak) id<GroupMemberManagerViewControllerDelegate> delegate;
@property (strong,nonatomic) NSString* messageId;
@property(strong,nonatomic) NSString* chatName;
@property(nonatomic,assign) BOOL isGroupChat;
@property(nonatomic,assign) BOOL isQuit;

@end
