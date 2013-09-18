//
//  ImageDownloadedView.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-15.
//
//

#import "ImageDownloadedView.h"

@interface ImageDownloadedView()<AsyncImageViewDelegate>

@end

@implementation ImageDownloadedView
@synthesize radius;
@synthesize loadingImageName;

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight){
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0){
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


-(id)init{
    self=[super init];
    if(self){
        self.radius=1.0f;
        self.loadingImageName=@"NoHeaderImge.png";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.radius=1.0f;
        self.loadingImageName=@"NoHeaderImge.png";
    }
    return self;

}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.radius=1.0f;
        self.loadingImageName=@"NoHeaderImge.png";
    }
    
    return self;
    
}

-(void)setUrl:(NSString*)url{
    type=ImageDownloadedViewNone;
    if([url length]>0){
        [self loadImageWithURLString:url];
        type=(self.image!=nil?ImageDownloadedViewFinish:ImageDownloadedViewDownloading);
    }
}


- (void)asyncImageView:(AsyncImageView *)asyncImageView didLoadImageFormURL:(NSURL*)aURL{
    type=(self.image!=nil?ImageDownloadedViewFinish:ImageDownloadedViewDownloading);
}

-(void)setImage:(UIImage *)value{
    if(self.radius!=1.0f){
        if(value!=nil)
            value=[ImageDownloadedView createRoundedRectImage:value size:self.frame.size radius:self.radius];
        [super setImage:value];
    }
    else{
        [super setImage:value];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(type!=ImageDownloadedViewFinish){
        if(loadingView==nil){
            loadingView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:self.loadingImageName]];
            loadingView.clipsToBounds=YES;
            [self addSubview:loadingView];
        }
        [self sendSubviewToBack:loadingView];
        loadingView.frame=self.bounds;
    }
    else{
        [loadingView removeFromSuperview];
        loadingView=nil;
    }

}

-(void)setLoadingImageName:(NSString *)value{
    loadingImageName=value;
    if(loadingView!=nil)
        loadingView.image=[UIImage imageNamed:value];
    [self layoutSubviews];
}

@end
