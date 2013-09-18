//
//  UIColor+Random.m
//  Scent
//
//  Created by Justin Yip on 7/23/11.
//  Copyright 2011 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AsyncImageViewDelegate;
@class HTTPRequest;
@interface AsyncImageView : UIImageView {
    
    HTTPRequest *_request;
    
    UIActivityIndicatorView* indicator;
    
    NSData *_loadedImageData;
    
    BOOL _loaded;
    NSMutableDictionary *_userInfo;
    id<AsyncImageViewDelegate> delegate;
}
@property(nonatomic,retain)HTTPRequest *request;
@property(nonatomic,retain)NSData *loadedImageData;
@property(nonatomic,assign)id<AsyncImageViewDelegate> delegate;

- (void)loadImageWithURLString:(NSString*)urlString;
//清理下载
- (void)cleanupRequest;

- (void)startLoading;
- (void)stopLoading;
- (void)broken;

//处理图像
//-(UIImage*)processImage:(UIImage*)aImage;
//异步加载图像
- (void)loadImageFromData:(NSData*)data animated:(BOOL)animated;

@end


/**
 * if you wanna reuse the downloaded image or something, use following delegate functions:
 */
@protocol AsyncImageViewDelegate

- (void)asyncImageView:(AsyncImageView *)asyncImageView didLoadImageFormURL:(NSURL*)aURL;

@end
