//
//  UpdateChecker.h
//  AMP
//
//  Created by Justin Yip on 8/14/12.
//
//

#import <Foundation/Foundation.h>
#import "CubeApplication.h"
#import "HTTPRequest.h"

@protocol CheckUpdateDelegate <NSObject>
@optional
-(void)updateAvailable;
-(void)updateUnavailable;
-(void)updateError:(NSError*)aError;

@end

@interface UpdateChecker : NSObject <UIAlertViewDelegate>
@property(nonatomic,weak) id<CheckUpdateDelegate> delegate;
@property(nonatomic,strong) HTTPRequest *request;
//@property(nonatomic,retain, getter = theNewApp) CubeApplication *newApp;
@property(nonatomic,strong) NSString *downloadUrl;

-(id)initWithDelegate:(id<CheckUpdateDelegate>) delegate;
-(void)check;

@end
