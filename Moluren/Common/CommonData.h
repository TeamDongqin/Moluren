//
//  CommonData.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Device_Default,
    Device_iPhone4,
    Device_iPhone4s,
    Device_iPhone5c,
    Device_iPhone5,
    Device_iPhone5s,
    Device_iPhone6,
    Device_iPhone6Plus
} DeviceType;

typedef enum {
    Topic_Life,             // Note: Update to Park
    Topic_Motion,           // Note: Update to Hotel
    Topic_Music,            // Note: Update to Street
    Topic_Movie,            // Note: Update to Cinema
    Topic_Study,            // Note: Update to Campus
    Topic_Work              // Note: Update to CoffeeRoom
} Topic;

@interface CommonData : NSObject

@end
