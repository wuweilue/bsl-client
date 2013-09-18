//
//  GroupPeopleViewViewController.m
//  cube-ios
//
//  Created by Mr Right on 13-8-14.
//
//

#import "GroupPeopleViewViewController.h"

@interface GroupPeopleViewViewController ()

@end

@implementation GroupPeopleViewViewController

-(id)init
{
    self =[super init];
    if (self)
    {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"GroupPeopleViewViewController"owner:self options:nil];
      return [nibView objectAtIndex:0];
    }

    return self;
}

//-(id)initWithFrame:(CGRect)frame
//{
//    self =[super initWithFrame:frame];
//    if (self) {
//        UIView* nibView =(UIView*) [[[NSBundle mainBundle] loadNibNamed:@"GroupPeopleViewViewController"owner:self options:nil]objectAtIndex:0];
//        [nibView setFrame:frame];
//        return [nibView ];
//    }
//}

@end
