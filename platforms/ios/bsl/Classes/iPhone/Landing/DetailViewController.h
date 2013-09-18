//
//  DetailViewController.h
//  TestVoiceView
//
//  Created by Mr.幸 on 12-12-8.
//  Copyright (c) 2012年 Mr.幸. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VVMessageCell.h"


@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VVMessageCellDelegate>{
    AVAudioRecorder* recorder;
    AVAudioPlayer* player;

}

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UITableView *controlTableView;
@property (strong, nonatomic) IBOutlet UIView *separatieView;

@property (strong, nonatomic) id detailItem;


@end
