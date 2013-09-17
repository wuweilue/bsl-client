//
//  RemoteDebuggerViewController.h
//  cube-ios
//
//  Created by apple2310 on 13-9-7.
//
//

#import <UIKit/UIKit.h>


@class DownloadedAsync;
@interface RemoteDebuggerViewController : UIViewController{
    
    DownloadedAsync* async;
    
    UILabel*  titleLabel;
    UITextField* textField;
    
    
    UIActivityIndicatorView* loadingView;
    
    UIProgressView*  progrewwView;
    
    NSString* rootPath;
    
    NSMutableArray*  list;
    
    NSString* hostname;
}

@end
