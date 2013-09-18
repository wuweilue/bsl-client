//
//  iphoneVoiceDetailViewController.h
//  Cube-iOS
//
//  Created by Mr.幸 on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VVMessageCell.h"

@interface iphoneVoiceDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,VVMessageCellDelegate>{
    AVAudioRecorder* recorder;
    AVAudioPlayer* player;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
