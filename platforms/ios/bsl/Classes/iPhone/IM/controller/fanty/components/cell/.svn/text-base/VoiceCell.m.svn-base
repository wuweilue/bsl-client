//
//  VoiceCell.m
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import "VoiceCell.h"
#import "AsyncImageView.h"

#define MAX_WIDTH  180.0f

static UIImage* receiveImg=nil;
static UIImage* receiveHLImg=nil;

static UIImage* senderImg=nil;
static UIImage* senderHLImg=nil;

@interface VoiceCell()<AsyncImageViewDelegate>

@end

@implementation VoiceCell

@synthesize type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        if(receiveImg==nil){
            receiveImg=[UIImage imageNamed:@"VOIPReceiverVoiceNodeBkg.png"];
            receiveImg=[[receiveImg stretchableImageWithLeftCapWidth:receiveImg.size.width*0.5f topCapHeight:receiveImg.size.height*0.5f] retain];
        }
        if(receiveHLImg==nil){
            receiveHLImg=[UIImage imageNamed:@"VOIPReceiverVoiceNodeBkgHL.png"];
            receiveHLImg=[[receiveHLImg stretchableImageWithLeftCapWidth:receiveHLImg.size.width*0.5f topCapHeight:receiveHLImg.size.height*0.5f] retain];

        }
        if(senderImg==nil){
            senderImg=[UIImage imageNamed:@"VOIPSenderVoiceNodeBkg.png"];
            receiveHLImg=[[receiveHLImg stretchableImageWithLeftCapWidth:receiveHLImg.size.width*0.5f topCapHeight:receiveHLImg.size.height*0.5f] retain];

        }
        if(senderHLImg==nil){
            senderHLImg=[UIImage imageNamed:@"VOIPSenderVoiceNodeBkgHL.png"];
            senderHLImg=[[senderHLImg stretchableImageWithLeftCapWidth:senderHLImg.size.width*0.5f topCapHeight:senderHLImg.size.height*0.5f] retain];
        }
        
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        noHeaderView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoHeaderImge.png"]];
        CGRect rect=noHeaderView.frame;
        rect.size=CGSizeMake(55.0f, 55.0f);
        noHeaderView.frame=rect;

        imageView=[[AsyncImageView alloc] initWithFrame:noHeaderView.frame];
        //        imageView.radius=4.0f;
        imageView.delegate=self;
        [self addSubview:imageView];
        [imageView release];
        
        [self addSubview:noHeaderView];
        [noHeaderView release];
        
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, 15.0f)];
        nameLabel.font=[UIFont systemFontOfSize:11.0f];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:nameLabel];
        [nameLabel release];

        
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        


        rect=button.frame;
        rect.size.width=receiveImg.size.width;
        rect.size.height=50.0f;
        button.frame=rect;

        [self addSubview:button];

        voiceImageView=[[UIImageView alloc] init];
        voiceImageView.animationDuration=1.0f;
        voiceImageView.animationRepeatCount=0;
        [button addSubview:voiceImageView];
        [voiceImageView release];

        
        dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 20.0f)];
        dateLabel.font=[UIFont systemFontOfSize:12.0f];
        dateLabel.textColor=[UIColor blackColor];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:dateLabel];
        [dateLabel release];


    }
    return self;
}

-(void)dealloc{
    imageView.delegate=nil;
    [super dealloc];
}

-(void)headerUrl:(NSString*)headerUrl{
    noHeaderView.hidden=NO;
    if([headerUrl length]>0)
        [imageView loadImageWithURLString:headerUrl];
    
}

-(void)setType:(NSBubbleType)value{
    type=value;
    UIImage* img=nil;
    UIImage* imgHL=nil;
    NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:3];
    if(type==BubbleTypeSomeoneElse){
        img=receiveImg;
        imgHL=receiveHLImg;
        for(int i=1;i<4;i++){
            UIImage* img=[UIImage imageNamed:[NSString stringWithFormat:@"bottleReceiverVoiceNodePlaying%03d.png",i]];
            [array addObject:img];
        }
    }
    else{
        img=senderImg;
        imgHL=senderHLImg;
        for(int i=1;i<4;i++){
            UIImage* img=[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying%03d.png",i]];
            [array addObject:img];
        }
    }
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:imgHL forState:UIControlStateHighlighted];

    voiceImageView.image=[array objectAtIndex:2];
    voiceImageView.animationImages=array;
    
    CGRect rect=voiceImageView.frame;
    rect.size=((UIImage*)[array objectAtIndex:0]).size;
    voiceImageView.frame=rect;
    [array release];
}

-(void)voiceLength:(float)voiceLegth animate:(BOOL)animate{
    voiceWidth=[UIImage imageNamed:@"VOIPReceiverVoiceNodeBkg.png"].size.width;
    
    voiceWidth=voiceWidth+(voiceWidth/5.0f * voiceLegth);
    if(voiceWidth>MAX_WIDTH)
        voiceWidth=MAX_WIDTH;
    if(animate){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
    }
    
    CGRect rect=button.frame;
    rect.size.width=voiceWidth;
    button.frame=rect;

    
    if(animate){
        [UIView commitAnimations];
    }
}

-(void)playAnimated:(BOOL)play{
    if(play){
        [voiceImageView startAnimating];
    }
    else{
        [voiceImageView stopAnimating];
    }
}

-(void)name:(NSString*)name{
    nameLabel.text=name;
}
-(void)sendDate:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"发送时间：yyyy-MM-dd HH:mm:ss"];
    dateLabel.text=[formatter stringFromDate:date];
    [formatter release];

}


+(float)cellHeight:(NSBubbleType)type{
    return 90.0f;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float cellHeight=[VoiceCell cellHeight:type];
    if (type == BubbleTypeSomeoneElse){
        
        CGRect rect=nameLabel.frame;
        rect.origin.x=10.0f;
        rect.origin.y=cellHeight-rect.size.height-5.0f;
        nameLabel.frame=rect;
        
        rect=imageView.frame;
        rect.origin.x=10.0f;
        rect.origin.y=CGRectGetMinY(nameLabel.frame)-rect.size.height;
        imageView.frame=rect;
        
        
        rect=dateLabel.frame;
        rect.origin.x=CGRectGetMaxX(imageView.frame)+5.0f;
        rect.origin.y=cellHeight-rect.size.height-5.0f;
        dateLabel.frame=rect;
        dateLabel.textAlignment=NSTextAlignmentLeft;

        
        rect=button.frame;
        rect.origin.x=CGRectGetMaxX(imageView.frame);
        rect.origin.y=CGRectGetMinY(dateLabel.frame)-rect.size.height;
        button.frame=rect;
        
        rect=voiceImageView.frame;
        rect.origin.x=25.0f;
        rect.origin.y=(button.frame.size.height-rect.size.height)*0.5f;
        voiceImageView.frame=rect;
        
        
    }
    else {
        CGRect rect=nameLabel.frame;
        rect.origin.x=self.frame.size.width-10.0-rect.size.width;
        rect.origin.y=cellHeight-rect.size.height-5.0f;
        nameLabel.frame=rect;
        
        rect=imageView.frame;
        rect.origin.x=self.frame.size.width-10.0-rect.size.width;
        rect.origin.y=CGRectGetMinY(nameLabel.frame)-rect.size.height;
        imageView.frame=rect;
        
        rect=dateLabel.frame;
        rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width-5.0f;
        rect.origin.y=cellHeight-rect.size.height-5.0f;
        dateLabel.frame=rect;
        dateLabel.textAlignment=NSTextAlignmentRight;

        
        rect=button.frame;
        rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width;
        rect.origin.y=CGRectGetMinY(dateLabel.frame)-rect.size.height;
        button.frame=rect;

        rect=voiceImageView.frame;
        rect.origin.x=button.frame.size.width-rect.size.width-25.0f;
        rect.origin.y=(button.frame.size.height-rect.size.height)*0.5f;
        voiceImageView.frame=rect;

    }
    
    noHeaderView.frame=imageView.frame;
}


-(void)addVoiceButton:(id)target action:(SEL)action{
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark  asyncimage delegate

- (void)asyncImageView:(AsyncImageView *)asyncImageView didLoadImageFormURL:(NSURL*)aURL{
    noHeaderView.hidden=YES;
}

@end
