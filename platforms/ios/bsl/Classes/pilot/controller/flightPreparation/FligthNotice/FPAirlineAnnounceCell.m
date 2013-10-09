//
//  FPAirlineAnnounceCell.m
//  pilot
//
//  Created by Sencho Kong on 12-11-28.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPAirlineAnnounceCell.h"
#import "NSString+ClassName.h"


@interface AnnounceView : UIView{
    
    FPAirlineAnnounceCell* _cell;
}

@end

@implementation AnnounceView

- (id)initWithFrame:(CGRect)frame cell:(FPAirlineAnnounceCell *)cell
{
    if (self = [super initWithFrame:frame])
    {
       _cell = cell;
        
        
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}




-(void)drawRect:(CGRect)rect{
    
    /*
    机场报表字色显示需求：
     $这个符号就换行
     按分隔符
     [] 蓝色
     () 绿色
     {} 红色
    “< .. >"括起来 no available NTM in this period!显示红色；
     */
    
    
    /*
     Sample:
     "***(A1260\/12) [VHHK] {201211270432-PERM}$GUANGZHOU HAS ALREADY IMPLEMENTED$FORMAT OR NEW FORMAT ARE ACCEPTED","(A1261\/11) [NFFF] {201211110459-PERM}$PER HAS ALREADY IMPLEMENTED$CHANGES PUBLISHED IN AMENDMENT 1 TO THE 1","(A1270\/12) [KFGD] {201210100460-EST}$HONG KONG HAS ALREADY TO SEND THE MESSAGE$PANS-ATM (DOC4444). SUBMISSION FO FPL","(A1271\/10) [AUST] {201210170658-PERM}$AUSTRALIA DON'T HAS INFOMATION$OF AMENDMENT 1 TO THE 15TH EDITION","(A1280\/11) [MLSY] {201209180435-EST}$MALAISIYA HAS ALREADY TO GET HELP$THE ISLAND IS ALTER TO FALL ALIGHT","(A1281\/10) [EGLD] {201210210759-PERM}$ENGLAND DON'T HAS ALTERAIRPORT$ON 15 NOVEMBER 2012","[PE] *no available NTM in this period!*"
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    
     
    NSRange bufferRange;
    NSUInteger leftIndex;
  
    

    CGSize size;

     
    NSArray* stringArray=[_cell.info componentsSeparatedByString:@"$"];

    if (stringArray.count>0) {
        for (NSString* info in stringArray) {
            
            //确认是这样格式的字符串：  (C4189\/12) [杭州]{201212201150-PERM}
            @autoreleasepool {
                
                if (info.length>0 && ![info isEqualToString:@""]&& info!=nil) {
                    
                    if ([info characterAtIndex:0 ]=='(' && [info characterAtIndex:[info length]-1 ]=='}') {
                        
                        for (int i = 0; i < [info length]; i++) {
                            
                            @autoreleasepool {
                                unichar character = [info characterAtIndex:i];
                                
                                if ( character == '[' ||character == '<' || character == '('){
                                    leftIndex=i;
                                }
                                
                                
                                //绘制绿色字符
                                if (character == ')') {
                                    bufferRange = NSMakeRange(leftIndex + 1 , i - leftIndex - 1);
                                    NSString* greenString= [info substringWithRange: bufferRange];
                                    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
                                    size = [greenString drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                                    rect.origin.x += size.width + 5;
                                    
                                }
                                
                                
                                if ( character == ']') {
                                    
                                    //取两个符号中的字符,Range的起点+1 长度＝终点－起点－1
                                    bufferRange = NSMakeRange(leftIndex + 1 , i - leftIndex - 1);
                                    NSString* blueString= [info substringWithRange: bufferRange];
                                    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
                                    size = [blueString drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                                    rect.origin.x += size.width + 5;
                                }
                                
                                if (character == '}') {
                                    
                                    bufferRange = NSMakeRange(leftIndex + 1 , i - leftIndex - 1);
                                    NSString* redString= [info substringWithRange: bufferRange];
                                    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                                    size = [redString drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                                    rect.origin.x=0;
                                    rect.origin.y += size.height;
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }else{
                        //用灰色绘出字符
                        rect.origin.x=0;
                        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
                        size= [info drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                        rect.origin.y += size.height;
                    }

                    
                }
                              

                
            }
            
                       
            
            
        }
    }
    
    
   /*
    
     
    for (int index = 0; index < [_cell.info length]; index++) {

        
        @autoreleasepool {
            
        unichar character = [_cell.info characterAtIndex:index];
      
        switch (character) {
            case '<': case '[': case '{': case '(':
                leftIndex = index;
                break;
            case '>':
                grayStringLeftIndex=index;
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                break;
            case ']':
                grayStringLeftIndex=index;
                CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
                break;
            case '}':
                
                grayStringLeftIndex=index;
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                break;
            case ')':
                grayStringLeftIndex=index;
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
                break;
                
            default:
                break;
        }
       
                 
            if ( character == '[' ||character == '{' || character == '('){
               
                if (index>0) {
                    
                    grayStringRange = NSMakeRange(grayStringLeftIndex + 1 , leftIndex - grayStringLeftIndex - 1);
                    
                    if (grayStringRange.length>0 ) {
                        grayString=[_cell.info substringWithRange:grayStringRange];
                        
                        if ([grayString length]>0 && ![grayString isEqualToString:@" "]) {
                           rect.origin.x = 0;
                            
                            if ([grayString isEqualToString:@"\n"]) {
                                
                                rect.origin.y += 20;
                                
                            }else{
                                
                                CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
                                size=  [grayString drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                                
                                rect.origin.y += size.height;
                            }
                           
                           
                        }
                        
                    }

                    
                }
                                
            }
            
       

        if ( character == ']' ||character == '}' || character == ')') {
         
          
            rightIndex = index;
            //取两个符号中的字符,Range的起点+1 长度＝终点－起点－1
            bufferRange = NSMakeRange(leftIndex + 1 , rightIndex - leftIndex - 1);
            buffer = [_cell.info substringWithRange: bufferRange];
            size = [buffer drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                    
            rect.origin.x += size.width + 5; 
            //rect.origin.y += size.height;
           // if (device_Type == UIUserInterfaceIdiomPhone) {
                if (character == '}') {
                    rect.origin.x = 0;
                   // rect.origin.y += size.height;
                    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
                   //  [buffer drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                }

           // }
                        
            //rect.size.width -= rect.origin.x;
//            if (character == '}') {
//                rect.origin.x = 0;
//               // CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//                buffer = [_cell.info substringFromIndex:rightIndex + 1];
//                [buffer drawInRect:rect withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
//              
//                }

        }
    }
}
    
    
    */
}







-(void)dealloc{
    
   
    [_cell release];
    [super dealloc];
}

@end


@interface FPAirlineAnnounceCell (){
    
    AnnounceView* cellContentView;
}

@end

@implementation FPAirlineAnnounceCell
@synthesize info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
        cellContentView = [[AnnounceView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:cellContentView];

    }
    return self;
}

-(void)setInfo:(NSString *)_info{
    [info release];
    info=[_info retain];
    [cellContentView setNeedsDisplay];
    
}



// 
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        UIView *contentView = (UIView *) object;
        CGRect originalFrame = CGRectMake(5, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)  ;
        cellContentView.frame=CGRectInset(originalFrame, 0.0, 1.0);
        [cellContentView setNeedsDisplay];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [cellContentView release];
    [info release];
    [super dealloc];
}

@end
