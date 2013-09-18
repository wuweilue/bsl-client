//
//  AnnouncementTableViewCell.m
//  Cube-iOS
//
//  Created by chen shaomou on 2/5/13.
//
//

#define margin_top 10
#define margin_left 20
#define margin_right 20
#define border_left 5
#define border_right 5
#define border_gap 5
#define content_hight 17
#define gap_line_hight 2
#define bottom_gap 10

#import "AnnouncementTableViewCell.h"
#import "UIColor+expanded.h"

@implementation AnnouncementTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)initView:(BOOL)edit{
    
}



-(void)configoure:(Announcement *)announcement  isEdit:(BOOL)edit{
    
    float cell_hight = 0.0;
    
    if(!_isReadLabel){
        _isReadLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.frame.size.width - margin_right  - 55+(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:150), margin_top, 55, content_hight)];
        
        [self addSubview:_isReadLabel];
    }
    [_isReadLabel setTextAlignment:NSTextAlignmentRight];
    [_isReadLabel setFont:[UIFont systemFontOfSize:15]];
    
    [_isReadLabel setBackgroundColor:[UIColor clearColor]];
    
    
    
    cell_hight = cell_hight + 17 + margin_top;
    
    cell_hight = cell_hight + border_gap;   
    
    cell_hight = cell_hight + border_gap;
    
  
   
    
    if(!_line1){
        _line1 = [[UIView alloc] init];
        [_line1 setBackgroundColor:[UIColor lightGrayColor]];
       
        
        [self addSubview:_line1];
    }
    _line1.frame = CGRectMake(margin_left-10 + (edit ? 31:0) + UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:31 , cell_hight, self.frame.size.width - margin_left -margin_right+20-(edit ? 31:0) +( UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:154), 1);
    
       cell_hight = cell_hight + border_gap + _line1.frame.size.height;
    
    
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
    }
    _titleLabel.frame =  CGRectMake(margin_left+ (edit ? 31:0)+ UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:51, margin_top, 200-(edit ? 31:0)+( UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:154), content_hight);

    [_titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    
    if(!_contentLabel){
        
        _contentLabel = [[UILabel alloc] init];
        
        [self addSubview:_contentLabel];
    }
    
    _contentLabel.frame = CGRectMake(margin_left + (edit ? 31:0)+ UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:51, cell_hight, self.frame.size.width - margin_left -margin_right-(edit ? 31:0), 0);
    
    
    //[self.contentLabel setText:announcement.content];
    
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    
    [_contentLabel setNumberOfLines:0];
    
    [_contentLabel setFont:[UIFont systemFontOfSize:14]];
    _contentLabel.textColor = [UIColor colorWithRGBHex:0x212121];
    [_contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    
    //一行高度
    CGFloat oneLineHeight = [announcement.content sizeWithFont:_contentLabel.font
                                                    forWidth:CGRectGetWidth(_contentLabel.frame) - (edit ? 31:0)
                                               lineBreakMode:UILineBreakModeTailTruncation].height;
    //多行高度
    CGFloat multiLineHeight = [announcement.content sizeWithFont:_contentLabel.font
                                             constrainedToSize:CGSizeMake(CGRectGetWidth(_contentLabel.frame) - (edit ? 31:0), 99999)
                                                 lineBreakMode:UILineBreakModeTailTruncation].height;
    
    //重设caption高度
    CGFloat finalCaptionHeight = (_contentLabel.numberOfLines == 1) ? oneLineHeight : multiLineHeight;
    
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, finalCaptionHeight)];
    
    
    cell_hight = cell_hight + bottom_gap + finalCaptionHeight;
    if(!_timeLabel){
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180+(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 0:150), cell_hight, 166, content_hight)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
    }
    
    [_timeLabel setFont:[UIFont systemFontOfSize:15]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [self.timeLabel setText:[df stringFromDate:announcement.reviceTime]];
    self.timeLabel.textColor = [UIColor colorWithRGBHex:0x969696];
    cell_hight = cell_hight + content_hight + border_gap;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cell_hight)];
    self.backgroundColor = [UIColor whiteColor];
    
    
   
}


-(void)moveView{
    [_contentLabel setCenter: CGPointMake( _contentLabel.center.x +30 , _contentLabel.center.y)];
    [_titleLabel setCenter: CGPointMake( _titleLabel.center.x +30 , _titleLabel.center.y)];
    [_line1 setCenter: CGPointMake( _line1.center.x +31, _line1.center.y)];
     _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x , _contentLabel.frame.origin.y, _contentLabel.frame.size.width-31, _contentLabel.frame.size.height );
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x , _titleLabel.frame.origin.y, _titleLabel.frame.size.width-31, _titleLabel.frame.size.height );
    _line1.frame = CGRectMake(_line1.frame.origin.x , _line1.frame.origin.y, _line1.frame.size.width-31, _line1.frame.size.height );
}

@end
