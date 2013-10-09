//
//  PlaneTypeViewController.h
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TowFilesViewController.h"

@interface PlaneTypeViewController : UITableViewController{
    NSArray                         *planeTypeArr;
    NSString                        *selectedType;
    id<PlaneTypeSelectDelegate>     typeDelegate;
}

@property (nonatomic, retain) NSArray *planeTypeArr;
@property (nonatomic, retain) NSString *selectedType;
@property (nonatomic, assign) id<PlaneTypeSelectDelegate> typeDelegate;

@end
