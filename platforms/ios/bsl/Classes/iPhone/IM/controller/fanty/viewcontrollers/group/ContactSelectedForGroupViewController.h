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
@interface ContactSelectedForGroupViewController : UIViewController{
    NSArray *sortedKeys;
    NSDictionary* showDicts;
    

    UINavigationBar* bar;
    TouchTableView* tableView;
    ImageUploaded* imageUploaded;
    UIButton* fliterBg;

    UISearchBar* searchBar;
    NSMutableArray* selectedUserInfos;
}

@property(nonatomic,strong) NSDictionary* dicts;

@end
