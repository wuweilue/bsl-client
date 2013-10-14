//
//  MainIphoneWebViewController.h
//  bsl
//
//  Created by dong on 13-10-14.
//
//

#import <UIKit/UIKit.h>


@class CubeWebViewController;
@interface MainIphoneWebViewController : UIViewController{
    CubeWebViewController *aCubeWebViewController;
}

@property(nonatomic,strong) UINavigationController* navController;

@property (strong, nonatomic) NSString *selectedModule;