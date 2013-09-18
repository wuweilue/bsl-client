//
//  AJNotificationView.h
//  Cube-iOS
//
//  Created by Mr Right on 12-22.
//
//

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

typedef enum {
    AJNotificationTypeDefault,
    AJNotificationTypeBlue,
    AJNotificationTypeRed,
    AJNotificationTypeGreen,
    AJNotificationTypeOrange,
    AJNotificationTypeWhite
} AJNotificationType;

typedef enum {
    AJLinedBackgroundTypeDisabled,
    AJLinedBackgroundTypeStatic,
    AJLinedBackgroundTypeAnimated
} AJLinedBackgroundType;

@interface AJNotificationView : UIView

//Show default notification (gray), hide after 2.5 seg
+ (AJNotificationView *)showNoticeInView:(UIView *)view title:(NSString *)title;

//Show default notification (gray)
+ (AJNotificationView *)showNoticeInView:(UIView *)view title:(NSString *)title hideAfter:(NSTimeInterval)hideInterval;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title hideAfter:(NSTimeInterval)hideInterval;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval detailDisclosure:(BOOL)show;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval offset:(float)offset;

//Response blocks are called when a user taps on the banner notification
+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval response:(void (^)(void))response;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval offset:(float)offset delay:(NSTimeInterval)delayInterval response:(void (^)(void))response;

+ (AJNotificationView *)showNoticeInView:(UIView *)view type:(AJNotificationType)type title:(NSString *)title linedBackground:(AJLinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval offset:(float)offset delay:(NSTimeInterval)delayInterval detailDisclosure:(BOOL)show response:(void (^)(void))response;

//Hide
- (void)hide;

@end