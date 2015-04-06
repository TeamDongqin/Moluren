//
//  CommonSetting.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

// Common color setting

// 1: Topic color pattern
#define Color_TopicWork_Pattern     0xED1941     // Note: Update to CoffeeRoom
#define Color_TopicLife_Pattern     0xae6642    // Note: Update to Park
#define Color_TopicMotion_Pattern   0x45b97c     // Note: Update to Hotel
#define Color_TopicMusic_Pattern    0x2a5caa     // Note: Update to Street
#define Color_TopicMovie_Pattern    0x6950a1     // Note: Update to Cinema
#define Color_TopicStudy_Pattern    0xf47920     // Note: Update to Campus

#define Color_TopicWork_withOpacity 0xF4758D    // Opacity : 0.6
#define Color_TopicLife_withOpacity 0xE2C8BB    // Opacity : 0.6
#define Color_TopicMotion_withOpacity 0xBCE6D0  // Opacity : 0.6
#define Color_TopicMusic_withOpacity 0xB2C4E1   // Opacity : 0.6
#define Color_TopicMovie_withOpacity 0xC9C0DE   // Opacity : 0.6
#define Color_TopicStudy_withOpacity 0xFBCFAF   // Opacity : 0.6

#define Color_AppTheme              0x213441

// 2: View background color
#define Color_SettingView_Background 0xEFEFF4
#define Color_MulMenuView_Background 0xF7F7F7      // Note: Multimedia menu background color hex

// Ui element
#define Page_History_Header_Height  150

#define Color_History_NavigBar 0xD87A7A
#define Page_History_Navigation_Height 64.0

#define MessageCellNotification_Height 14.5f

#define Notification_Disconnect_Height 44
#define Notification_TdAlertView_Height 44
#define Notification_DisconnectView_Height 44

#define ShareMenuView_PageControl_Height 0

#define Device_Width [[UIScreen mainScreen] bounds].size.width
#define Device_Height [[UIScreen mainScreen] bounds].size.height

// User message suffix
#define iPhone4 @" - iPhone 4 "
#define iPhone4s @" - iPhone 4s "
#define iPhone5  @" - iPhone 5 "
#define iPhone5s @" - iPhone 5s "
#define iPhone6 @" - iPhone 6"
#define iPhone6Plus @" - iPhone 6 Plus"

#define IosDevice_Prefix @" -- From iPhone"
#define iPhone4_Suffix @" -- From iPhone 4 "
#define iPhone4s_Suffix @" -- From iPhone 4s "
#define iPhone5_Suffix  @" -- From iPhone 5 "
#define iPhone5c_Suffix  @" -- From iPhone 5c "
#define iPhone5s_Suffix  @" -- From iPhone 5s "
#define iPhone5s_Suffix_Template @" 我就是我， 不一样的烟火！  -- From iphone 5s"
#define iPhone6_Suffix @" -- From iPhone 6"
#define iPhone6Plus_Suffix @" -- From iPhone 6 Plus"

// User personal signature
#define UserPerSignature_Defaul @"我就是我， 不一样的烟火！"

// Common ui position
#define ratio_firstline 4.68
#define ratio_secondline 2.61
#define ratio_thirdline 1.78

#define ratio_firstcollum 8.2
#define ration_secondcollum 1.65

// User personal signature NSUserDefaults key
#define Key_UserPersonalSignature @"KUserPerSignature"

@interface CommonSetting : NSObject

@end
