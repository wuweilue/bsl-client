//
//  MessagesViewController.h
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import <UIKit/UIKit.h>
#import "MsgListCell.h"

@interface MessagesViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *datas;
@property (strong,nonatomic) MsgListCell *cell;

@end
