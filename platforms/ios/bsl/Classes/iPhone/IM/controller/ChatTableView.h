//
//  ChatTableView.h
//  cube-ios
//
//  Created by Mr Right on 13-8-14.
//
//

#import <Foundation/Foundation.h>
@protocol TableViewProtocol <NSObject>

@optional
- (void)tableViewTouched;
- (void)beginEditing;

@end

@interface ChatTableView : UITableView
@property (nonatomic, strong) id parent;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)enterEditing: (UIGestureRecognizer *)gestureRecognizer;

@end
