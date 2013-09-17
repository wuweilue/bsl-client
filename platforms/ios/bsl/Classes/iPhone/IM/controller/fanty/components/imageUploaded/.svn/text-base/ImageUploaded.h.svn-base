//
//  ImageUploaded.h
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageUploaded;
@protocol ImageUploadedDelegate <NSObject>

-(void)didConfirmImageUploaded:(ImageUploaded*)imageUploaded;

@end

@interface ImageUploaded : UIImageView{
    
    UIScrollView* scrollView;
    UIButton* confirmButton;
    NSMutableDictionary* imageViews;
    UIButton* uploadButton;
    float left;
}

@property(nonatomic,assign) id<ImageUploadedDelegate> delegate;

-(void)addNewImage:(NSString*)iId url:(NSString*)url;
-(void)removeImage:(NSString*)iId;
@end
