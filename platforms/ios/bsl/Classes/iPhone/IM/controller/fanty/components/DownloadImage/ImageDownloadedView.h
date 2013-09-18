//
//  ImageDownloadedView.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-15.
//
//

#import "AsyncImageView.h"

typedef enum{
    ImageDownloadedViewNone=0,
    ImageDownloadedViewDownloading,
    ImageDownloadedViewFinish
}ImageDownloadedViewType;

@interface ImageDownloadedView : AsyncImageView{
    UIImageView* loadingView;
    ImageDownloadedViewType type;
}

@property(nonatomic,assign) float radius;
@property(nonatomic,strong) NSString* loadingImageName;
-(void)setUrl:(NSString*)url;
@end
