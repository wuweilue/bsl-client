//
//  XMPPFriendsViewController.h
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "AppDelegate.h"
#import "IMFriendsCell.h"
@interface XMPPFriendsViewController : UIViewController{
    UISearchBar* tableViewSearchBar;
    BOOL isCanRefresh;
    
}
@property (retain, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *userFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *friendsFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign)BOOL isOpen;
@property (assign)BOOL isSearch;
@property (assign)BOOL isChange;
@property (assign)BOOL isGroupOpen;
@property (assign)BOOL isCanChange;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign)NSInteger oldSelectIndex;
@property (nonatomic,retain)NSString* curFliterStr;


@end

