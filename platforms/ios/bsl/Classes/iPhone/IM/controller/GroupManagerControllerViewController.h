//
//  GroupManagerControllerViewController.h
//  cube-ios
//
//  Created by Mr Right on 13-8-13.
//
//

#import <UIKit/UIKit.h>


@interface GroupManagerControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *groupChatArrCopy;
}
@property (strong, nonatomic)  UITableView *GroupManagerTable;
@property (nonatomic,strong)NSMutableArray *groupChatUserArr;
- (IBAction)ExitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *ExitButton;


@end
