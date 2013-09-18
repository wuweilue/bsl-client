//
//  ChatPanel.h
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIExpandingTextView;
@class ChatPanel;
@class EmoctionPanel;
@class CameraPanel;

@protocol ChatPanelDelegate <NSObject>
-(void)chatPanelDidSend:(ChatPanel*)chatPanel;
-(void)chatPanelRecordTouch:(ChatPanel*)chatPanel isTouch:(BOOL)touch;
-(void)chatPanelRecordCancel:(ChatPanel*)chatPanel;
-(void)chatPanelDidSelectedAdd:(ChatPanel*)chatPanel;
@end

@interface ChatPanel : UIView{
    
    UIImageView* chatPanelBgView;
    UIButton* chatButton;
    UIImageView*  textBgView;
    UIButton* recordButton;
    UIExpandingTextView* textView;
    UIButton* emoctionButton;
    UIButton* addButton;
    
    EmoctionPanel* emoctionPanel;
    CameraPanel* camerPanel;
}

@property(nonatomic,assign) id<ChatPanelDelegate> delegate;
@property(nonatomic,assign) NSUInteger limitMaxNumber;
@property(nonatomic,retain) NSString* text;
@property(nonatomic,retain) NSDictionary* emoctionList;


-(float)panelHeight;

@end
