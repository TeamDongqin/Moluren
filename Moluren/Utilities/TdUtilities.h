//
//  TdUtilities.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TdUtilities : NSObject

+ (TdUtilities*)Instance;

-(DeviceType)GetDeviceType;
-(NSString*)GetUserSignature:(NSString*)content;

@end