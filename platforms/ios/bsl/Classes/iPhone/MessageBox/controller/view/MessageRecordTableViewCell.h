//
//  MessageRecordTableViewCell.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/1/13.
//
//

#import <UIKit/UIKit.h>

@interface MessageRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviceTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UILabel *isReadLabel;

- (void)configureWithModuleName:(NSString *)moduleName reviceTime:(NSDate *)reviceTime alert:(NSString *)alert;

@end
