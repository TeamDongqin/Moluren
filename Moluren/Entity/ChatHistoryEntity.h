//
//  ChatHistoryEntity.h
//  Moluren
//
//  Created by tcl-macpro on 14-11-20.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatHistoryEntity : NSObject

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *tokenid;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgtype;
@property (nonatomic, copy) NSString *date;


@end
