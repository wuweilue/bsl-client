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
    id <MessageRecordHeaderViewDelegate> __weak delegate;
    
}
@property (nonatomic,weak)  id <MessageRecordHeaderViewDelegate> delegate;
@property (assign, nonatomic) BOOL isDeleteStatue;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mesageCountBgImageView;
@property (strong, nonatomic) UIButton* deleteBtn;
@property (strong, nonatomic) NSString*  moduleId;
@property NSInteger section;


-(void)configureWithIconUrl:(NSString *)iconurl moduleName:(NSString *)name messageCount:(NSString *)count  sectionIndenx:(int) index ;
-(void)configureWithIconUrl:(NSString *)iconurl moduleName:(NSString *)name messageCount:(NSString *)count  sectionIndenx:(int)index withUnReadCount:(NSString *)unReadCount;
@end
