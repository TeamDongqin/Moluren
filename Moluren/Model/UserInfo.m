//
//  UserInfo.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/3.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo()

@property (nonatomic) NSString* UserPersonalSignature;

@end

@implementation UserInfo

+ (UserInfo*)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(NSString*)GetUserPersonalSignature{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Key_UserPersonalSignature])
    {
        self.UserPersonalSignature = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserPersonalSignature];
    }
    else
    {
        self.UserPersonalSignature = @"";
    }
    
    return self.UserPersonalSignature;
}

-(void)SetUserPersonalSignature:(NSString*)String{
    
    self.UserPersonalSignature = String;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.UserPersonalSignature forKey:Key_UserPersonalSignature];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
