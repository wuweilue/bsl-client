//
//  TowFilesViewController.h
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlaneTypeSelectDelegate <NSObject>

- (void)didSelectPlaneType:(NSString *)planeType;

@end

@interface TowFilesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PlaneTypeSelectDelegate>{
    NSArray                         *fileNameList;
    id<PlaneTypeSelectDelegate>     typeDelegate;
    NSString                        *selectedType;
    UITextField                     *portCodeField;
}

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UITableView *queryTable;
@property (retain, nonatomic) IBOutlet UITableView *resultTable;
@property (nonatomic, retain) UITextField *portCodeField;
@property (nonatomic, assign) id<PlaneTypeSelectDelegate> typeDelegate;
@property (nonatomic, retain) NSArray *fileNameList;

- (IBAction)queryFileList:(id)sender;

- (void)queryTowFileWithPlaneType:(NSString*)planeType andFileName:(NSString *)fileName;

@end
