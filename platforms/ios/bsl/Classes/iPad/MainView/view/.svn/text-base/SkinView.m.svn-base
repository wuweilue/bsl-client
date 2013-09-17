//
//  SkinView.m
//  cube-ios
//
//  Created by 东 on 6/25/13.
//
//

#import "SkinView.h"
#import "NSFileManager+Extra.h"

#define ImageWidth  133.4
#define ImageHeight 100

#define ScrollerHeight 200

@implementation SkinView
@synthesize delegate;
@synthesize _activityItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithActivityItems:(NSArray *)activityItems{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self._activityItems = activityItems;
        UIControl *baseView = [[UIControl alloc] initWithFrame:self.frame];
        baseView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [baseView addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
        
        baseView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:baseView];
        
        CGRect baseRect = CGRectMake(0, CGRectGetHeight(baseView.frame) - ScrollerHeight, baseView.frame.size.width, ScrollerHeight);
        _panelView = [[AAPanelView alloc] initWithFrame:baseRect];
        _panelView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
//        _panelView.transform = CGAffineTransformMakeScale(1.0, 0.1);
        [baseView addSubview:_panelView];
        [UIView animateWithDuration:0.1 animations:^ {
            _panelView.transform = CGAffineTransformIdentity;
            _panelView.alpha = 0.6;
        }];
        CGRect baseRect1 = CGRectMake(0, CGRectGetWidth(baseView.frame) - ScrollerHeight, baseView.frame.size.width, ScrollerHeight);
        imageScrollView  = [[UIScrollView alloc]initWithFrame:baseRect1];
        [baseView addSubview:imageScrollView];
        [self initScrollView];
    }
    return self;
}

-(void)initScrollView{
    float widthGap = 30;
    
    
    
    for (int i = 0 ; i < [self._activityItems count] ;i++) {
        NSURL* documentUrl =  [NSFileManager applicationDocumentsDirectory];
        NSString* imageName = [NSString stringWithFormat:@"www/pad%@", [[self._activityItems objectAtIndex:i] objectForKey:@"imgThum"]];
        NSURL* imageUrl  =  [documentUrl URLByAppendingPathComponent:imageName];
        NSData* data = [[NSData alloc]initWithContentsOfURL:imageUrl];
        
        
        
        UIButton* imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*(ImageWidth + widthGap)+widthGap,CGRectGetHeight(imageScrollView.frame) > ImageHeight ? (CGRectGetHeight(imageScrollView.frame) - ImageHeight)/2  : 0 , ImageWidth, ImageHeight)];
        imageBtn.tag = 1000+i;
      
        [imageBtn setImage:  [UIImage imageWithData:data] forState:UIControlStateNormal];
        [data release];
        [imageBtn addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [imageScrollView addSubview:imageBtn];
        [imageBtn release];
    }
    
    float scrollViewContentWidth = [_activityItems count] * (ImageWidth + widthGap) ;
    imageScrollView.contentSize = CGSizeMake(scrollViewContentWidth+30, CGRectGetHeight(imageScrollView.frame) < ImageHeight ? ImageHeight : CGRectGetHeight(imageScrollView.frame) );
   
}

-(void)clickPhoto:(UIButton*)btn{
    [self dismissActionSheet];
    NSLog(@"click Photo %@",[NSDate date]);
    
    if (delegate) {
        [delegate onclick:(btn.tag-1000) source:self._activityItems];
    }
}

#pragma mark Appearence

- (void)show
{
    // for keyboard overlay.
    // But not perfect fix for all case.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [UIApplication sharedApplication].windows) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    UIView *topView = [[UIApplication sharedApplication].keyWindow.subviews objectAtIndex:0];
    
    [self showInView:keyboardWindow ? : topView];
}

- (void)showInView:(UIView *)view
{
//    _panelView.title = @"选择皮肤";
    self.frame = view.bounds;
     [view addSubview:self];
    
    CGRect panelFrame =  _panelView.frame ;
    
    if (panelFrame.origin.y<=( CGRectGetHeight(self.frame) - ScrollerHeight)) {
        CGRect panelFrame =  CGRectMake(0, CGRectGetHeight(self.frame), self.frame.size.width, ScrollerHeight);;
        panelFrame.origin.y = CGRectGetWidth(self.frame);
        _panelView.frame = panelFrame;
        imageScrollView.frame = panelFrame;
    }
    
    [UIView animateWithDuration:0.4 animations:^ {
         CGRect baseRect = CGRectMake(0, CGRectGetHeight(self.frame) - ScrollerHeight, self.frame.size.width, ScrollerHeight);
        _panelView.frame = baseRect;
        imageScrollView.frame = baseRect;
    } completion:^(BOOL finished) {
        
    }];
    _isShowing = YES;
}

- (void)dismissActionSheet
{
    if (self.isShowing) {
        [UIView animateWithDuration:0.4 animations:^ {
            CGRect panelFrame =  CGRectMake(0, CGRectGetHeight(self.frame), self.frame.size.width, ScrollerHeight);
            _panelView.frame = panelFrame;
            imageScrollView.frame = panelFrame;
             
        } completion:^ (BOOL finished){
           [self removeFromSuperview];
        }];
        _isShowing = NO;
    }
}

@end
