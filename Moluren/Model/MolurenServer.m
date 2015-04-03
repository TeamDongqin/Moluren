//
//  MolurenServer.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/3.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "MolurenServer.h"

@interface MolurenServer()

@property (atomic) Session CurrentSessionStatus;

@end

@implementation MolurenServer

+ (TdTopic*)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(Session)GetConnectionStatus{
    return self.CurrentSessionStatus;
}

-(void)Connect{

}

-(void)Disconnect{
    
}

@end
