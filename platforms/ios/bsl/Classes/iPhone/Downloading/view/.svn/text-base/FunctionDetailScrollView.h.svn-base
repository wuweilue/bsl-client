//
//  FunctionDetailScrollView.h
//  Cube-iOS
//
//  Created by Pepper's mpro on 1/22/13.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol FunctionDetailScrollViewDataSource <NSObject>

@required
-(NSMutableArray *)urlArrayForImages;


@end

@interface FunctionDetailScrollView : UIScrollView

@property (assign,nonatomic) NSInteger currentPage;
@property (assign,nonatomic) CGFloat pageMargin;
@property (assign,nonatomic) CGFloat pageWidth;
@property (assign,nonatomic) CGFloat pageCornerWidth;
@property (assign,nonatomic) NSInteger imageWidth;
@property (assign,nonatomic) id<FunctionDetailScrollViewDataSource> dataSource;
@property (retain,nonatomic)   NSMutableArray *urlArray;

-(void)notifyDataChange;

@end
