//
//  SetttingIMViewController.h
//  cube-ios
//
//  Created by 东 on 13-3-27.
//
//

#import <UIKit/UIKit.h>

@interface SetttingIMViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *IMStatue;
@property (strong, nonatomic) IBOutlet UILabel *PushStatue;

@property (strong, nonatomic) IBOutlet UISwitch *switchPUSH;
@property (strong, nonatomic) IBOutlet UISwitch *switchIM;

- (IBAction)switchIMTouchdown:(id)sender;

- (IBAction)switchPushTouchdown:(id)sender;

@end
