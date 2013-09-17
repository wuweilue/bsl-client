//
//  LongPressButton.m
//  UIButtonLongPressed
//
//  Created by qiulei on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LongPressButton.h"

@interface TargetObject:NSObject
{
    id __object;
	SEL __action;
}
-(void)execTarget;
-(id)initWithTarget:(id)target actiion:(SEL)action;
@end

@implementation TargetObject

-(id)initWithTarget:(id)target actiion:(SEL)action
{
    if ((self=[super init])) {
        __object=target;
        __action=action;
    }
    return self;
}

-(void)execTarget
{
    [__object performSelector:__action];
}


-(void)dealloc
{
    __object=nil;
}

@end


@interface LongPressButton ()
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSMutableDictionary  *targetDictonary;
@end

@implementation LongPressButton
@synthesize button=__button;
@synthesize targetDictonary=__targetDictonary;
@synthesize minimumPressDuration;


-(void)commonInit
{
    self.targetDictonary=[NSMutableDictionary dictionaryWithCapacity:3];
    minimumPressDuration=0.5f;
    
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
        self.button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.button addTarget:self action:@selector(buttonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.button addTarget:self action:@selector(buttonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.button addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.button setFrame:self.bounds];
        [self addSubview:self.button];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(LongPressEvents)controlEvents
{
    TargetObject *targetObject=[[TargetObject alloc] initWithTarget:target actiion:action];
    switch (controlEvents) {
        case ControlEventTouchCancel:
            [self.targetDictonary setObject:targetObject forKey:@"ControlEventTouchCancel"];
            break;
        case ControlEventTouchInside:
            [self.targetDictonary setObject:targetObject forKey:@"ControlEventTouchInside"];
            break;
        default:
            [self.targetDictonary setObject:targetObject forKey:@"ControlEventTouchLongPress"];
            break;
    }
}




- (void)buttonTouchDown
{
    
    TargetObject *targetObject=[self.targetDictonary objectForKey:@"ControlEventTouchInside"];
    if (targetObject) {
        [targetObject execTarget];
        [self performSelector:@selector(lazyButtontouchDown) withObject:nil afterDelay:self.minimumPressDuration];
    }
    
	
}

-(void)lazyButtontouchDown
{
    TargetObject *targetObject=[self.targetDictonary objectForKey:@"ControlEventTouchLongPress"];
    if (targetObject) [targetObject execTarget];
}


- (void)buttonTouchUpInside
{
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(lazyButtontouchDown)
											   object:nil];
    
    TargetObject *targetObject=[self.targetDictonary objectForKey:@"ControlEventTouchCancel"];
    if (targetObject) [targetObject execTarget];
    
    
}
- (void)buttonTouchUpOutside
{
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(lazyButtontouchDown)
											   object:nil];
    TargetObject *targetObject=[self.targetDictonary objectForKey:@"ControlEventTouchCancel"];
    if (targetObject) [targetObject execTarget];
}






#pragma mark 设置图片，和背景图片。

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [self.button setImage:image forState:state];
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [self.button setBackgroundImage:image forState:state];
}




#pragma mark 设置标题，颜色，阴影
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self.button setTitle:title forState:state];
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setTitleColor:color forState:state];
}
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setTitleShadowColor:color forState:state];
}


-(void)dealloc
{
    __button=nil;
    __targetDictonary=nil;
}

@end
