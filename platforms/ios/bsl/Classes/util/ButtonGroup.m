//
//  ButtonGroup.m
//  Cube-iOS
//
//  Created by hibad(Alfredo) on 13/1/29.
//
//

#import "ButtonGroup.h"


@interface ButtonGroup ()

@property (strong,nonatomic) NSMutableArray *buttons;
@end

@implementation ButtonGroup


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect) frame ButtonTitle:(NSArray *) titles andBackground:(NSArray *) imageNames andActiveBackground:(NSArray *) activeImageNames{
    self = [super initWithFrame:frame];
    if(self){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.buttons = array;
        self.imageNames = imageNames;
        self.activeImageNames = activeImageNames;
        self.buttonTitles = titles;
        [self setUpButtons];
    }
    return self;
}


-(void)setUpButtons{
    CGFloat buttonWidth = self.frame.size.width / self.buttonTitles.count;
    CGFloat buttonOriginX = 0;
    //三者长度不等
    if(self.buttonTitles.count != self.imageNames.count&&self.buttonTitles.count!= self.activeImageNames.count)
        return;
    //初始化按钮
    for(int i = 0; i < self.buttonTitles.count; i++){
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, 0, buttonWidth, 30)];
        if(i == 0){
            [button setBackgroundImage:[UIImage imageNamed:[self.activeImageNames objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.textColor = [UIColor whiteColor];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:[self.imageNames objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.textColor = [UIColor blackColor];
        }
        button.tag = i;
        [button addTarget:self action:@selector(clickSubButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self addSubview:button];
        buttonOriginX += buttonWidth;
    }
}

//点击事件
-(void)clickSubButton:(UIButton *)button{
    
    NSInteger targetIndex = button.tag;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didClickButtonGroup:)]){
        [_delegate performSelector:@selector(didClickButtonGroup:) withObject:[NSNumber numberWithInteger:targetIndex]];
    }
        
    for(UIButton *subButton in self.subviews){
        if(subButton.tag == targetIndex){
            [subButton setBackgroundImage:[UIImage imageNamed:[self.activeImageNames objectAtIndex:targetIndex]] forState:UIControlStateNormal];
        }
        else{
            [subButton setBackgroundImage:[UIImage imageNamed:[self.imageNames objectAtIndex:subButton.tag]] forState:UIControlStateNormal];
            subButton.titleLabel.textColor = [UIColor blackColor];
            
        }
    }
}



@end
