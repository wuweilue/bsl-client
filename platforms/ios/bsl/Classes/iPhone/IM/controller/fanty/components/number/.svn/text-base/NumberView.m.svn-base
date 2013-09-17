//
//  NumberView.m
//  WeChat
//
//  Created by apple2310 on 13-9-4.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import "NumberView.h"
@interface NumberView()
-(void)initialize;
@end

@implementation NumberView

-(id)init{
    self=[super init];
    if (self) {
        [self initialize];
    }

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[self initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    UIImage* img=[UIImage imageNamed:@"message_number_single.png"];
    img=[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f];
    CGRect frame=self.frame;
    frame.size=img.size;
    self.frame=frame;
    self.image=img;
    UILabel* label=[[UILabel alloc] initWithFrame:self.bounds];
    label.tag=1;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    label.textColor=[UIColor whiteColor];
    
    label.numberOfLines=1;
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    [label release];
    self.hidden=YES;

}

-(void)number:(int)number{
    UIImage* img=self.image;
    
    CGRect rect=self.bounds;
    if(number>99){
        rect.size.width=img.size.width+img.size.width*0.35f;
    }
    else if(number>9){
        rect.size.width=img.size.width+img.size.width*0.2f;
    }
    else{
        rect.size.width=img.size.width;
    }
    self.bounds=rect;
    UILabel* label=(UILabel*)[self viewWithTag:1];
    rect.origin.y-=1.5f;
    label.frame=rect;
    label.text=[NSString stringWithFormat:@"%d",number];
    self.hidden=(number<1);
}

@end
