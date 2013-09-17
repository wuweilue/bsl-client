//
//  ImageUploaded.m
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ImageUploaded.h"
#import "AppDelegate.h"
#import "ImageDownloadedView.h"

@interface ImageUploaded()
-(void)confirmClick;
@end


@implementation ImageUploaded
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    
    
    
    UIImage* img=[UIImage imageNamed:@"bottom_bar.png"];
    frame.size.height=48.0f;
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;

        self.image=img;
        confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* btnImg=[UIImage imageNamed:@"RightBarButtonBkg.png"];
        btnImg=[btnImg stretchableImageWithLeftCapWidth:btnImg.size.width*0.5f topCapHeight:btnImg.size.height*0.5f];
        UIImage* btnSelImg=[UIImage imageNamed:@"RightBarButtonBkg_Blue.png"];
        btnSelImg=[btnSelImg stretchableImageWithLeftCapWidth:btnImg.size.width*0.5f topCapHeight:btnImg.size.height*0.5f];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:btnImg forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:btnSelImg forState:UIControlStateSelected];
        [confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        confirmButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
        
        
        confirmButton.enabled=NO;
        [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.frame=CGRectMake(frame.size.width-64.0f-8.0f, (frame.size.height-btnImg.size.height)*0.5f, 64.0f, btnImg.size.height);
        
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, CGRectGetMinX(confirmButton.frame)-10.0f, frame.size.height)];
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        
        [self addSubview:scrollView];
        [self addSubview:confirmButton];
        
        
        imageViews=[[NSMutableDictionary alloc] initWithCapacity:2];

        left=0.0f;
        img=[UIImage imageNamed:@"addphotoHL.png"];
        uploadButton=[UIButton buttonWithType:UIButtonTypeCustom];
        uploadButton.frame=CGRectMake(left, (frame.size.height-33.0f)*0.5f, 33.0f, 33.0f);
        [uploadButton setImage:img forState:UIControlStateNormal];
        [scrollView addSubview:uploadButton];
    }
    return self;
}


-(void)addNewImage:(NSString*)iId url:(NSString*)url{
    [imageViews enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL* stop){

        if([iId isEqualToString:key]){
            *stop=YES;
            return;
        }

    }];
    CGRect rect=uploadButton.bounds;
    rect.origin.x=left;
    rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
    ImageDownloadedView* view=[[ImageDownloadedView alloc] initWithFrame:rect];
    [view setUrl:url];
    
    [scrollView addSubview:view];
    [imageViews setObject:view forKey:iId];
    
    
    [confirmButton setTitle:[NSString stringWithFormat:@"%@(%d)",@"确定",[imageViews count]] forState:UIControlStateNormal];
    confirmButton.selected=([imageViews count]>0);
    confirmButton.enabled=([imageViews count]>0);
    
    left=CGRectGetMaxX(rect)+2.0f;
    view.alpha=0.3f;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha=1.0f;
        
    } completion:^(BOOL finish){
    
    }];
    
    [UIView animateWithDuration:0.2f delay:0.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect=uploadButton.frame;
        rect.origin.x=left;
        uploadButton.frame=rect;
        
    } completion:^(BOOL finish){
        scrollView.contentSize=CGSizeMake(left+uploadButton.frame.size.width+10.0f, self.frame.size.height);

    }];

    
}

-(void)removeImage:(NSString*)iId{
    
    [imageViews enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL* stop){
        
        if([iId isEqualToString:key]){
            *stop=YES;

            ImageDownloadedView* view=value;
            [imageViews removeObjectForKey:key];
            [confirmButton setTitle:[NSString stringWithFormat:@"%@(%d)",@"确定",[imageViews count]] forState:UIControlStateNormal];
            confirmButton.selected=([imageViews count]>0);
            confirmButton.enabled=([imageViews count]>0);

            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.alpha=0.0f;
                    
            } completion:^(BOOL finish){
                [view removeFromSuperview];
            }];
                
            [UIView animateWithDuration:0.2f delay:0.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                left=0.0f;
                [imageViews enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL* stop){
                    ImageDownloadedView* view=value;
                    CGRect rect=view.frame;
                    rect.origin.x=left;
                    rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
                    view.frame=rect;
                    left=CGRectGetMaxX(rect)+2.0f;
                }];
                CGRect rect=uploadButton.frame;
                rect.origin.x=left;
                uploadButton.frame=rect;
                    
            } completion:^(BOOL finish){
                scrollView.contentSize=CGSizeMake(left+uploadButton.frame.size.width+10.0f, self.frame.size.height);
                    
            }];
            
            return;
        }
        
    }];
}

-(void)confirmClick{
    if([self.delegate respondsToSelector:@selector(didConfirmImageUploaded:)])
        [self.delegate didConfirmImageUploaded:self];
}

@end
