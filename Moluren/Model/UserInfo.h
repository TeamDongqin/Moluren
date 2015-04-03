//
//  UserInfo.h
//  Moluren
//
//  Created by zheng lingshan on 15/4/3.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo*)Instance;

-(NSString*)GetUserPersonalSignature;
-(void)SetUserPersonalSignature:(NSString*)String;

@end
