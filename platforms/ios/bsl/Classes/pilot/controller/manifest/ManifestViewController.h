//
//  ManifestViewController.h
//  pilot
//
//  Created by wuzheng on 9/18/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CabinOrder.h"

@interface ManifestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    CabinOrder              *cabinOrder;
    NSMutableDictionary     *cabinOrderDic;
    NSArray                 *titleArray;
}

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@property (retain, nonatomic) CabinOrder *cabinOrder;
@property (retain, nonatomic) NSMutableDictionary *cabinOrderDic;


- (void)initDispalyData;

@end
