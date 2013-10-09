//
//  GroupPanel.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-18.
//
//

#import "GroupPanel.h"
#import "ImageDownloadedView.h"

@interface GroupSubPanel()
@property(nonatomic,strong) NSString* jid;
-(void)addCloseButtonClick:(id)target action:(SEL)action;
-(void)hideRemoveButton;
@end

@implementation GroupSubPanel
@synthesize jid;
-(id)initWithTitle:(NSString*)value imageUrl:(NSString*)imageUrl{
    
    self=[self initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    if(self){
        imageDownloadedView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 40.0f, 40.0f)];
        [imageDownloadedView setUrl:imageUrl];
        [self addSubview:imageDownloadedView];

        

        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f,60.0f,30.0f)];
        titleLabel.font=[UIFont systemFontOfSize:12.0f];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=value;
        titleLabel.numberOfLines=0;
        [titleLabel sizeToFit];
        
        
        
        CGRect rect=titleLabel.frame;
        if(rect.size.height>30.0f){
            rect.size.height=30.0f;
        }
        rect.origin.x=(self.frame.size.width-rect.size.width)*0.5f;
        titleLabel.frame=rect;
        
        [self addSubview:titleLabel];
        
        
        closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage* img=[UIImage imageNamed:@"btn_remove.png"];
        [closeButton setImage:img forState:UIControlStateNormal];
        closeButton.frame=CGRectMake(self.frame.size.width-img.size.width-10.0f, -10.0f, img.size.width*2.0f, img.size.height);
        [self addSubview:closeButton];

    }
    return self;
}

-(void)hideRemoveButton{
    closeButton.hidden=YES;
}

-(void)addCloseButtonClick:(id)target action:(SEL)action{
    [closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)dealloc{
    self.jid=nil;
}

@end

@interface GroupPanel()
-(void)btnUploadClick:(UIButton*)button;
-(void)removeClick:(UIButton*)closeButton;
@end

@implementation GroupPanel

@synthesize delegate;
@synthesize selectedJid;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        list=[[NSMutableArray alloc] initWithCapacity:2];
        
        UIImage* img=[UIImage imageNamed:@"addphotoHL.png"];
        uploadButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [uploadButton addTarget:self action:@selector(btnUploadClick:) forControlEvents:UIControlEventTouchUpInside];

        uploadButton.frame=CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        [uploadButton setBackgroundImage:img forState:UIControlStateNormal];
        [self addSubview:uploadButton];

    }
    return self;
}

-(void)dealloc{
    self.selectedJid=nil;
}


-(void)setArray:(NSArray*)_tags{
    [list makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [list removeAllObjects];
    
    float left=10.0f;
    float top=10.0f;
    float width=self.frame.size.width-20.0f;

    int index=0;
    
    NSString* myJid=[[ShareAppDelegate xmpp].xmppStream.myJID bare];
    
    for(NSDictionary* dict in _tags){
        NSString* username=[dict objectForKey:@"username"];
        GroupSubPanel* subView=[[GroupSubPanel alloc] initWithTitle:username imageUrl:@""];
        subView.jid=[dict objectForKey:@"jid"];
        if([myJid isEqualToString:subView.jid]){
            [subView hideRemoveButton];
        }
        [subView addCloseButtonClick:self action:@selector(removeClick:)];
        subView.tag=index;
        [self addSubview:subView];
        [list addObject:subView];
        
        CGRect rect=subView.frame;
        if(left+rect.size.width>width){
            left=10.0f;
            top+=rect.size.height+10.0f;
        }
        rect.origin.x=left;
        rect.origin.y=top;
        subView.frame=rect;
        
        left+=rect.size.width+10.0f;

    }
    
    [self bringSubviewToFront:uploadButton];
    CGRect rect=uploadButton.frame;
    if(left+rect.size.width>width){
        left=17.0f;
        top+=rect.size.height+10.0f;
    }
    rect.origin.x=left;
    rect.origin.y=top;
    uploadButton.frame=rect;

    
    rect=self.frame;
    rect.size=CGSizeMake(self.frame.size.width, top+50.0f);
    self.frame=rect;
}

-(void)btnUploadClick:(GroupSubPanel*)subView{

    if([self.delegate respondsToSelector:@selector(addGroupClick:)])
        [self.delegate addGroupClick:self];
}

-(void)hideAddButton{
    uploadButton.hidden=YES;
}

-(void)hideRemoveButtons{
    for(GroupSubPanel* subView in list){
        [subView hideRemoveButton];
    }
}

-(void)removeClick:(UIButton*)closeButton{
    GroupSubPanel* subView=(GroupSubPanel*)closeButton.superview;
    self.selectedJid=subView.jid;
    if([self.delegate respondsToSelector:@selector(removeGroupClick:)])
        [self.delegate removeGroupClick:self];

}

-(void)removeUserJid:(NSString*)jid{
    BOOL isRemove=NO;
    for(GroupSubPanel* subView in list){
        if([subView.jid isEqualToString:jid]){
            [subView removeFromSuperview];
            [list removeObject:subView];
            isRemove=YES;
            
            break;
        }
    }
    if(isRemove){
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            float top=10.0f;
            
            float left=10.0f;
            
            float width=self.frame.size.width-20.0f;
            
            int index=0;
            for(GroupSubPanel* subView in list){
                subView.tag=index;
                CGRect rect=subView.frame;
                if(left+rect.size.width>width){
                    left=10.0f;
                    top+=rect.size.height+10.0f;
                }
                rect.origin.x=left;
                rect.origin.y=top;
                subView.frame=rect;
                
                left+=rect.size.width+10.0f;
                
            }
            
            [self bringSubviewToFront:uploadButton];
            CGRect rect=uploadButton.frame;
            if(left+rect.size.width>width){
                left=17.0f;
                top+=rect.size.height+10.0f;
            }
            rect.origin.x=left;
            rect.origin.y=top;
            uploadButton.frame=rect;
            
            rect=self.frame;
            rect.size=CGSizeMake(self.frame.size.width, top+50.0f);
            self.frame=rect;
            
        } completion:^(BOOL finish){
        }];
    }

}

@end
