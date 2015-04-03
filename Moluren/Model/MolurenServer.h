//
//  MolurenServer.h
//  Moluren
//
//  Created by zheng lingshan on 15/4/3.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MolurenServer : NSObject

+ (TdTopic*)Instance;

-(Session)GetConnectionStatus;
-(void)Connect;
-(void)Disconnect;

@end
