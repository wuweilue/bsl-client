//
//  FunctionDetailScrollView.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 1/22/13.
//
//

#define DETAIL_SCROLLVIEW_ORIGINY 165

#import "FunctionDetailScrollView.h"

#define GET_DEVICE_TYPE ^(){if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){if(iPhone5){return @"iphone5";}else{return @"iphone";}}else{return @"ipad";}}


@interface FunctionDetailScrollView ()


@property (assign,nonatomic) NSInteger pageCount;

@property (assign,nonatomic) CGFloat imageViewWidth;


@end


@implementation FunctionDetailScrollView
@synthesize urlArray = _urlArray;
@synthesize pageWidth;
@synthesize pageMargin;
@synthesize pageCornerWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //滑动展示布局
//    UIView *superView = [UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIApplication sharedApplication], <#CGFloat height#>);
    self.clipsToBounds=NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.currentPage=0;

}

-(NSInteger)setScrollPageWidth{
    if([GET_DEVICE_TYPE() isEqualToString:@"ipad"] ){
        if(([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            
        }else{
            
        }
    }else{
        return 320;
    }
    return 0;
}

-(void)calculateViewProperties{
    CGFloat screenWidth = [[UIApplication sharedApplication] statusBarFrame].size.width;
    self.pageCount = self.urlArray.count;
    
    if (CDV_IsIPhone5()) {
         self.imageViewWidth = (self.frame.size.height+100) * 2/3;
    }else{
        self.imageViewWidth = (self.frame.size.height+200) * 2/3;
    }
   
    self.pageCornerWidth = (screenWidth - self.imageViewWidth)/5;
    self.pageMargin = (screenWidth - self.imageViewWidth)/3;
    self.frame = CGRectMake(0, DETAIL_SCROLLVIEW_ORIGINY, self.imageViewWidth+self.pageMargin, self.frame.size.height);
    
    self.pageWidth = self.imageViewWidth + self.pageMargin;
    
    if (CDV_IsIPhone5()) {
        self.contentSize = CGSizeMake(self.pageCornerWidth + self.urlArray.count * self.imageViewWidth + (self.urlArray.count-1) * self.pageMargin,self.frame.size.height+100);
    }else{
        self.contentSize = CGSizeMake(self.pageCornerWidth + self.urlArray.count * self.imageViewWidth + (self.urlArray.count-1) * self.pageMargin,self.frame.size.height+200);
    }
    
}

-(void)addImageViews{
    if(self.urlArray.count == 0){
        self.scrollEnabled = false;
    }
    for(int i = 1; i <= self.urlArray.count; i++){
        AsyncImageView *tempAsyncImageView=[[AsyncImageView alloc] init];
        CGFloat offsetX = self.pageCornerWidth + (i-1) * self.imageViewWidth + i * self.pageMargin;

        tempAsyncImageView.frame = CGRectMake(offsetX,0,self.imageViewWidth,self.contentSize.height);
        
        [tempAsyncImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [tempAsyncImageView.layer setBorderWidth:2.0];
        [tempAsyncImageView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [tempAsyncImageView.layer setShadowOffset:CGSizeMake(0, 0)];
        [tempAsyncImageView.layer setShadowOpacity:0.5];
        [tempAsyncImageView.layer setShadowRadius:3.0];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =  [defaults objectForKey:@"token"];
        NSString* url = [[self.urlArray objectAtIndex:i-1] stringByAppendingFormat:@"?sessionKey=%@&appKey=%@",token,kAPPKey];
        [tempAsyncImageView loadImageWithURLString:url];
        [self addSubview:tempAsyncImageView];
    }
}

-(void)notifyDataChange{
    self.urlArray = [self.dataSource urlArrayForImages];
    [self drawRect:self.frame];
    [self calculateViewProperties];
    [self addImageViews];
}

@end
