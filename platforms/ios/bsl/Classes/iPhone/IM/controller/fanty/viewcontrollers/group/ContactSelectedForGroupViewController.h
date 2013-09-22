//
//  ContactSelectedForGroupViewController.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-15.
//
//

#import <UIKit/UIKit.h>
@class ImageUploaded;
@class TouchTableView;
@class CustomNavigationBar;
@class ContactSelectedForGroupViewController;

@protocol ContactSelectedForGroupViewControllerDelegate <NSObject>

-(void)dismiss:(ContactSelectedForGroupViewController*)controller;;

@end

@interface ContactSelectedForGroupViewController : UIViewController{
    NSArray *sortedKeys;
    NSDictionary* showDicts;
    

    UINavigationBar* bar;
    TouchTableView* tableView;
    ImageUploaded* imageUploaded;
    UIButton* fliterBg;

    UISearchBar* searchBar;
    NSMutableArray* selectedUserInfos;
    
    NSTimer* timeOutTimer;
}
@property(nonatomic,assign) id<ContactSelectedForGroupViewControllerDelegate> delegate;
@property(nonatomic,retain) NSString* tempNewjid;
@property(nonatomic,retain) NSDictionary* dicts;
@property(nonatomic,retain) NSString* groupName;
@property(nonatomic,retain) NSString*  existsGroupJid;

@end
