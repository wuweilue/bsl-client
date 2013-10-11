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
    
    UIActivityIndicatorView* indicator;
    
    NSData *_loadedImageData;
    
    BOOL _loaded;
    NSMutableDictionary *_userInfo;
    id<AsyncImageViewDelegate> __weak delegate;
    
    HTTPRequest *request;
}
@property(nonatomic,strong)NSData *loadedImageData;
@property(nonatomic,weak)id<AsyncImageViewDelegate> delegate;

+(UIImage*)imageWithThumbnail:(UIImage *)image size:(CGSize)thumbSize;

- (void)loadImageWithURLString:(NSString*)urlString;
//清理下载
- (void)cleanupRequest;

- (void)startLoading;
- (void)stopLoading;
- (void)broken;

- (void)loadImageFromData:(NSData*)data animated:(BOOL)animated;

@end


/**
 * if you wanna reuse the downloaded image or something, use following delegate functions:
 */
@protocol AsyncImageViewDelegate

- (void)asyncImageView:(AsyncImageView *)asyncImageView didLoadImageFormURL:(NSURL*)aURL;

@end
