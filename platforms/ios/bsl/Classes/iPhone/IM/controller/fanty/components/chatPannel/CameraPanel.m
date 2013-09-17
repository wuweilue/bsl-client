//
//  CameraPanel.m
//  cube-ios
//
//  Created by apple2310 on 13-9-7.
//
//

#import "CameraPanel.h"


@interface CameraPanel()
-(void)btnClick:(UIButton*)button;
@end


@implementation CameraPanel

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        UIImage* img=[UIImage imageNamed:@"sharemore_video.png"];
        
        cameraButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton.tag=CameraPanelClickTypeCamera;
        [cameraButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cameraButton setImage:img forState:UIControlStateNormal];
        cameraButton.frame=CGRectMake(10.0f, 20.0f, img.size.width, img.size.height);
        [self addSubview:cameraButton];
        
        img=[UIImage imageNamed:@"sharemore_pic.png"];
        
        phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        phoneButton.tag=CameraPanelClickTypeCamera;
        [phoneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [phoneButton setImage:img forState:UIControlStateNormal];
        phoneButton.frame=CGRectMake(CGRectGetMaxX(cameraButton.frame)+20.0f, 20.0f, img.size.width, img.size.height);
        [self addSubview:phoneButton];
        
    }
    return self;
}

-(void)btnClick:(UIButton*)button{
    if([self.delegate respondsToSelector:@selector(cameraPanelDidClick:clickType:)])
        [self.delegate cameraPanelDidClick:self clickType:button.tag];
}

@end
