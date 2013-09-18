//
//  MessageRecordHeaderView.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/1/13.
//
//

#import <UIKit/UIKit.h>

@protocol MessageRecordHeaderViewDelegate
-(void)deleteModuleData:(NSString*)moduleIdendity;
-(void)shouldShowCellInModule:(NSString *)moduleId atIndex:(NSInteger)section;
@end

@interface MessageRecordHeaderView : UIView{
    id <MessageRecordHeaderViewDelegate> delegate;
    
}
@property (nonatomic,assign)  id <MessageRecordHeaderViewDelegate> delegate;
@property (assign, nonatomic) BOOL isDeleteStatue;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *mesageCountBgImageView;
@property (retain, nonatomic) UIButton* deleteBtn;
@property (retain, nonatomic) NSString*  moduleId;
@property NSInteger section;


-(void)configureWithIconUrl:(NSString *)iconurl moduleName:(NSString *)name messageCount:(NSString *)count  sectionIndenx:(int) index ;
-(void)configureWithIconUrl:(NSString *)iconurl moduleName:(NSString *)name messageCount:(NSString *)count  sectionIndenx:(int)index withUnReadCount:(NSString *)unReadCount;
@end
