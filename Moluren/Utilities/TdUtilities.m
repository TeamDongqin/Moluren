//
//  TdUtilities.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TdUtilities.h"
#import "sys/utsname.h"

@interface TdUtilities()

//-() GetDeviceType{
//    
//}

@end

@implementation TdUtilities

#pragma mark - Singleton method

+ (TdUtilities*)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(DeviceType)GetDeviceType{
    DeviceType CurrentDeviceType = Device_Default;
    NSDictionary* deviceNamesByCode = nil;
    
    deviceNamesByCode = @{
                          @"iPhone3,1" :[NSNumber numberWithInt:Device_iPhone4],        //
                          @"iPhone4,1" :[NSNumber numberWithInt:Device_iPhone4s],       //
                          @"iPhone5,1" :[NSNumber numberWithInt:Device_iPhone5],        // (model A1428, AT&T/Canada)
                          @"iPhone5,2" :[NSNumber numberWithInt:Device_iPhone5],        // (model A1429, everything else)
                          @"iPhone5,3" :[NSNumber numberWithInt:Device_iPhone5c],       // (model A1456, A1532 | GSM)
                          @"iPhone5,4" :[NSNumber numberWithInt:Device_iPhone5c],       // (model A1507, A1516, A1526 (China), A1529 | Global)
                          @"iPhone6,1" :[NSNumber numberWithInt:Device_iPhone5s],       // (model A1433, A1533 | GSM)
                          @"iPhone6,2" :[NSNumber numberWithInt:Device_iPhone5s],       // (model A1457, A1518, A1528 (China), A1530 | Global)
                          @"iPhone7,1" :[NSNumber numberWithInt:Device_iPhone6Plus],
                          @"iPhone7,2" :[NSNumber numberWithInt:Device_iPhone6]
                          };
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    CurrentDeviceType = [[deviceNamesByCode objectForKey:code] integerValue];
    
    if (CurrentDeviceType == Device_Default) {
        CurrentDeviceType = Device_iPhone4s;  // Default
    }
    
    return CurrentDeviceType;
}

-(NSString*)GetUserSignature:(NSString*)content{
    NSString *UserSingauture = nil;
    DeviceType deviceType = [self GetDeviceType];
    switch (deviceType) {
        case Device_Default:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, IosDevice_Prefix];
            }
            break;
        case Device_iPhone4:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone4_Suffix];
            }
            break;
        case Device_iPhone4s:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone4s_Suffix];
            }
            break;
        case Device_iPhone5:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone5_Suffix];
            }
            break;
        case Device_iPhone5c:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone5c_Suffix];
            }
            break;
        case Device_iPhone5s:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone5s_Suffix];
            }
            break;
        case Device_iPhone6:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone6_Suffix];
            }
            break;
        case Device_iPhone6Plus:
            {
                UserSingauture = [NSString stringWithFormat: @" ", content, iPhone6Plus_Suffix];
            }
            break;
        default:
            break;
    }
    
    return UserSingauture;
}

@end