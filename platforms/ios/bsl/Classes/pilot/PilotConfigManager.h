//
//  ConfigManager.h
//  pilot
//
//  Created by wuzheng on 8/30/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#ifndef pilot_ConfigManager_h
#define pilot_ConfigManager_h

//#define appDelegate				((PilotAppDelegate *)[[UIApplication sharedApplication] delegate])
#define currentInterfaceOrientation [[UIApplication sharedApplication] statusBarOrientation]
#define appType                 @"pilot"
#define OS_Type                 @"IOS"

#define device_Type              [[UIDevice currentDevice] userInterfaceIdiom]

//UIAlertView tag
#define login_oa_tag                    101
#define feedback_success_tag            102
#define device_register_success_tag     103
#define feedBack_save_success_tag       104
#define check_available_tag             105
#define check_unavailable_tag             106

//query flag
#define query_success_flag              @"success"
#define query_failed_flag               @"failed"

#define device_register_flag            @"register"
#define device_unRegister_flag          @"unRegister"
#define device_SM_error                 @"sm_error"
#define device_verifCode_error          @"verifCode_error"

//version check
#define check_available                 @"available"
#define check_newest                    @"newest"
#define check_unAvailable               @"unAvailable"

#endif
