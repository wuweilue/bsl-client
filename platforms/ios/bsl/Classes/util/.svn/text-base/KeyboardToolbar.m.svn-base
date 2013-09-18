//
//  KeyboardObserver.m
//  CSMBP
//
//  Created by Justin Yip on 11-12-4.
//  Copyright (c) 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import "KeyboardToolbar.h"
#import "UIView+CG.h"
@interface KeyboardToolbar()

@property(nonatomic,retain)UIToolbar *keyboardToolBar;


@end

@implementation KeyboardToolbar

static const int kKeyboardHeight = 30;
static KeyboardToolbar *instance = nil;

@synthesize keyboardToolBar;

+(id)sharedInstance {
    if (instance == nil) {
        instance = [[KeyboardToolbar alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _stack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_stack release];
    self.keyboardToolBar = nil;
    
    [super dealloc];
}

- (void)pushBindingViewController:(UIViewController*)aVC
{
    [_stack addObject:aVC];
}

- (void)popBindingViewController
{
    [_stack removeLastObject];
}

-(UIToolbar*)createToolBarWithFrame:(CGRect)aFrame
{
    //init toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:aFrame];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didClickDone:)];
    toolbar.items = [NSArray arrayWithObjects: space, doneButton, nil];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent=TRUE;
    [space release];
    [doneButton release];
    
    return [toolbar autorelease];
}

-(UIWindow*) keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

//if bindingViewController is kind of UINavigationController, using it's topViewController(fix 20px issue)
- (UIViewController*)theRootViewController
{
    UIViewController *root = [_stack lastObject];
    //    if (nil == root) {
    //        return [UIApplication sharedApplication].keyWindow;
    //    }
    
    if ([root isKindOfClass:[UINavigationController class]]) {
        root = ((UINavigationController*)root).topViewController;
    }
    
    return root;
}
- (UIView*)theRootView
{
    UIViewController *root = [_stack lastObject];
//    if (nil == root) {
//        return [UIApplication sharedApplication].keyWindow;
//    }
    
    if ([root isKindOfClass:[UINavigationController class]]) {
        root = ((UINavigationController*)root).topViewController;
    }
    
    return root.view;
}

-(void) enableObserver {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    
    [self disableObserver];
    
 
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillHide:) 
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];
    
    
    }
}

- (void)disableObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)note {
    
    //prepare values
    NSValue *keyboardFrameBeginValue = [[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *keyboardFrameEndValue = [[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *keyboardAnimationDurationValue = [[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *keyboardAnimationCurveValue = [[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardFrameBegin;
    CGRect keyboardFrameEnd;
    UIViewAnimationOptions animationCurve;
    [keyboardFrameBeginValue getValue:&keyboardFrameBegin];
    [keyboardFrameEndValue getValue:&keyboardFrameEnd];
    [keyboardAnimationCurveValue getValue:&animationCurve];
    
    //scroll to current first responder
    UIView *first = [[self theRootView] findFirstResponder];
    NSString *name=NSStringFromClass([first class]);
    NSLog(@"----------%@",name);
    //屏蔽webView对键盘的调整
    
    
    if (![name isEqualToString:@"UIWebBrowserView"]) {
    
        [self.keyboardToolBar removeFromSuperview];
        self.keyboardToolBar = [self createToolBarWithFrame:CGRectMake(0, CGRectGetMinY(keyboardFrameBegin) - 30, CGRectGetWidth(keyboardFrameBegin), 30)];
        //TODO: enum keyboard window
        [[self keyWindow] addSubview:self.keyboardToolBar];
        
        //iOS5中文键盘会调用两次keyboardWillShow，需要记录最原始的视图frame
        if (CGRectEqualToRect(_originalFrame, CGRectZero)) {
            CGRect frame = [self theRootView].frame;
            _originalFrame = frame;
        }
        
        [UIView animateWithDuration:[keyboardAnimationDurationValue floatValue] delay:0 options:animationCurve animations:^{
                CGRect newFrameForRootView = _originalFrame;
                newFrameForRootView.size.height -= keyboardFrameEnd.size.height + 30;
                    [self theRootView].frame = newFrameForRootView;
                self.keyboardToolBar.frame = CGRectMake(0, CGRectGetMinY(keyboardFrameEnd) - 30, CGRectGetWidth(keyboardFrameEnd), 30);
        } completion:^(BOOL s){
            [first scrollToVisible];
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification*)note {
    
    //屏蔽webView对键盘的调整
    UIView *first = [[self theRootView] findFirstResponder];
    instance.lastResponseView=first;
    NSString *name=NSStringFromClass([first class]);
    NSLog(@"----------%@",name);
    if (![name isEqualToString:@"UIWebBrowserView"]) {
    
    NSValue *keyboardFrameBeginValue = [[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *keyboardFrameEndValue = [[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *keyboardAnimationDurationValue = [[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *keyboardAnimationCurveValue = [[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardFrameBegin;
    CGRect keyboardFrameEnd;
    UIViewAnimationCurve animationCurve;
    [keyboardFrameBeginValue getValue:&keyboardFrameBegin];
    [keyboardFrameEndValue getValue:&keyboardFrameEnd];
    [keyboardAnimationCurveValue getValue:&animationCurve];
    
    [UIView animateWithDuration:0 delay:0 options:animationCurve animations:^{
            [self theRootView].frame = _originalFrame;
        self.keyboardToolBar.frame = CGRectMake(0, CGRectGetMinY(keyboardFrameEnd) + 30, CGRectGetWidth(keyboardFrameEnd), 30);
    } completion:^(BOOL finished) {
        _originalFrame = CGRectZero;
        [self.keyboardToolBar removeFromSuperview]; 
        self.keyboardToolBar = nil;
    }];
    
    }
}

- (void)didClickDone:(id)sender
{
    [[self theRootView] endEditing:YES];
    if (_clickDone) {
        self.clickDone();
    }
}

@end
