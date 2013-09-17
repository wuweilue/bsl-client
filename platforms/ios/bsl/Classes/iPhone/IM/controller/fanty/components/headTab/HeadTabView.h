//
//  HeadTabView.h
//  
//
//  Created by fanty on 13-8-4.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadTabView;

@protocol HeadTabViewDelegte <NSObject>

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index;

@end

@interface HeadTabView : UIView{
    UIView* selectedImageView;
    NSMutableArray* labelList;
}
@property(nonatomic,assign) id<HeadTabViewDelegte> delegate;
@property(nonatomic,assign) int selectedIndex;
-(void)setTabNameArray:(NSArray*)array;

@end
