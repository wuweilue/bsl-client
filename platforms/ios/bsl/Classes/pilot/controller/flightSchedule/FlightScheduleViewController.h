//
//  FlightScheduleViewController.h
//  pilot
//
//  Created by wuzheng on 8/28/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightScheduleViewController : UIViewController<UIWebViewDelegate>{
    UIBarButtonItem                     *refreshButton_;
    id                                  delegate;
    SEL                                 backMethod;
    
    BOOL                                offline;        //离线标示
}

@property (retain, nonatomic) IBOutlet UIView *msgView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (retain, nonatomic) IBOutlet UIWebView *myWebView;

@property (assign, nonatomic) id delegate;

@property (assign, nonatomic) SEL backMethod;

- (void)loadWebPage;

@end
