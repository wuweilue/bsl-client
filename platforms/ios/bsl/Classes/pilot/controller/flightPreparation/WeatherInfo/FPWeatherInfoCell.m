//
//  FPWeatherInfoCell.m
//  pilot
//
//  Created by Sencho Kong on 12-12-3.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPWeatherInfoCell.h"
#import "WeatherInfo.h"

//第一行的自定义view
@interface FPWeatherInfoHeadCellView : UIView{
    FPWeatherInfoCell* _cell;
}

@end

@implementation FPWeatherInfoHeadCellView


- (id)initWithFrame:(CGRect)frame cell:(FPWeatherInfoCell *)cell
{
    if (self = [super initWithFrame:frame])
    {
        _cell = cell;
        
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    CGSize size;
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    rect.origin.x =10.0;
    rect.origin.y =10.0;
    rect.size.width=rect.size.width-10;
    
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    size = [ @"航       线："drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    rect.origin.x +=size.width+5;
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    if (_cell.airportWeatherInfo.depArpFullName &&_cell.airportWeatherInfo.arvArpFullName) {
        NSString* airline=[NSString stringWithFormat:@"%@-%@",_cell.airportWeatherInfo.depArpFullName,_cell.airportWeatherInfo.arvArpFullName];
        size = [airline drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    }
   
    
    
    rect.origin.x =10.0;
    rect.origin.y+=size.height+3;
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    size = [@"ROUTE  ：" drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    rect.origin.x +=size.width+5;
    if (_cell.airportWeatherInfo.depArpCd&&_cell.airportWeatherInfo.arvArpCd) {
        NSString* route=[NSString stringWithFormat:@"%@-%@",_cell.airportWeatherInfo.depArpCd,_cell.airportWeatherInfo.arvArpCd];
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        size = [route drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
  
    }
    
    
    rect.origin.x =10.0;
    rect.origin.y+=size.height+3;
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    size = [@"查询时间：" drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    rect.origin.x +=size.width;
    rect.size.width-=rect.origin.x;
     CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    [_cell.airportWeatherInfo.queryTime drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    
}

@end





/*中间行的自定义view*/

@interface FPWeatherInfoView : FPWeatherInfoHeadCellView
    
@end

@implementation FPWeatherInfoView


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextSaveGState(context);
    
     
    //绘制标题
    NSString* cellTitle=nil;
    CGSize size;
    
    
    if ([_cell.weatherInfo.arpType isEqualToString:@"depArp"]) {
        cellTitle=@"出发机场：\n";
    }else if([_cell.weatherInfo.arpType isEqualToString:@"arvArp"]){
        cellTitle=@"到达机场：\n";
    }else if([_cell.weatherInfo.arpType isEqualToString:@"divArvArp"]){
        cellTitle=@"备降机场实况 \n(The Alternate Airports Report)：\n";
    }
    else if([_cell.weatherInfo.arpType isEqualToString:@"divArvArpFcst"]){
        cellTitle=@"备降机场预报\n(The Alternate Airports Forecast)：\n";
    }
    else if([_cell.weatherInfo.arpType isEqualToString:@"infoArea"]){
        cellTitle=@"飞越的情报区、管制区\n(The Significant Meteorological Information)：\n";
    }
    else if([_cell.weatherInfo.arpType isEqualToString:@"afterPort"]){
        cellTitle=@"后续机场：\n";
    }

    
    rect.origin.x =10.0;
    rect.size.width-=10.0;
    rect.origin.y =10.0;
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    size = [cellTitle drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
    rect.origin.y   += size.height + 3;
    
    
    
    
    //绘制内容
        
    if (![_cell.weatherInfo.optTxts isKindOfClass:[NSArray class]]&&_cell.weatherInfo.optTxts) {
        
         NSCharacterSet* aCharacterSet=[NSCharacterSet characterSetWithCharactersInString:@"[]"];
        NSString* info=(NSString*) _cell.weatherInfo.optTxts;
        //  扫描天气信息类型  类型是SP,MV,WA,WS的话，就要显示红色
        NSScanner *scanner = [NSScanner scannerWithString:info];
        NSString *weatherType = nil;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&weatherType];
        
        //去除[]
         NSString* redString = [weatherType stringByTrimmingCharactersInSet:aCharacterSet];
        
        //类型是SP,MV,WA,WS的话，就要显示红色
        if ([redString isEqualToString:@"SP"]||[redString isEqualToString:@"MV"]||[redString isEqualToString:@"WA"]||[redString isEqualToString:@"WS"]) {
            
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            
        }else{
            
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            
        }
        
        size = [info drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
        rect.origin.y   += size.height + 3;

        
        
        
    }
    else{
        
        if ( _cell.weatherInfo.optTxts.count>0) {
            
            NSCharacterSet* aCharacterSet=[NSCharacterSet characterSetWithCharactersInString:@"[]"];
            
            NSString*  redString=nil ;
            for (int i=0 ;i<_cell.weatherInfo.optTxts.count;i++) {
                @autoreleasepool {
                    
                
                NSString* info= [_cell.weatherInfo.optTxts objectAtIndex:i];
                //  扫描天气信息类型  类型是SP,MV,WA,WS的话，就要显示红色
                NSScanner *scanner = [NSScanner scannerWithString:[_cell.weatherInfo.optTxts objectAtIndex:i]];
                NSString *weatherType = nil;
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&weatherType];
                
                //去除[]
                redString = [weatherType stringByTrimmingCharactersInSet:aCharacterSet];
                
                //类型是SP,MV,WA,WS的话，就要显示红色
                if ([redString isEqualToString:@"SP"]||[redString isEqualToString:@"MV"]||[redString isEqualToString:@"WA"]||[redString isEqualToString:@"WS"]) {
                    
                    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                    
                }else{
                    
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    
                }
                
                size = [info drawInRect:rect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:UILineBreakModeWordWrap];
                rect.origin.y   += size.height + 3;
                
                
                
            }
        }
            
        }
        
    }
    
    
   
    
    
}


@end






@interface FPWeatherInfoCell (){
     UIView* cellContentView;
    
}

@end

@implementation FPWeatherInfoCell

@synthesize airportWeatherInfo;
@synthesize weatherInfo;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentViewStyle:(ContentStyle)contentViewStyle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (contentViewStyle==kHeadCell) {
            cellContentView = [[FPWeatherInfoHeadCellView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
          
            
        }else{
            cellContentView = [[FPWeatherInfoView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
           
            
        }
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:cellContentView];
    }
    return self;
}


-(void)setAirportWeatherInfo:(AirportWeatherInfo *)_airportWeatherInfo{
    [airportWeatherInfo release];
    airportWeatherInfo=[_airportWeatherInfo retain];
    [cellContentView setNeedsDisplay];
    
}

-(void)setWeatherInfo:(WeatherInfo *)_weatherInfo{
    [weatherInfo release];
    weatherInfo=[_weatherInfo retain];
    [cellContentView setNeedsDisplay];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)dealloc{
    [airportWeatherInfo release];
    [weatherInfo release];
    [cellContentView release];
    [super dealloc];
}
@end
