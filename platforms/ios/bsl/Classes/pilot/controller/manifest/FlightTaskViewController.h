//
//  FlightTaskViewController.h
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CabinOrderQuery.h"

@interface FlightTaskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray                     *flightTaskArray;
}

@property (retain, nonatomic) NSArray *flightTaskArray;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;

// 保持住，防止在回调取消请求的方法前被释放
@property (retain, nonatomic) CabinOrderQuery *cabinOrderQuery;

@end
