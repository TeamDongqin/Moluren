//
//  SharedSingleConfig.h
//  Moluren
//
//  Created by tcl-macpro on 14-10-13.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatHistoryDB.h"

@interface SharedSingleConfig : NSObject

@property (nonatomic, strong) ChatHistoryDB * hisDB;

@property (nonatomic, retain) NSString *token;
@property (nonatomic) NSString *nowsessionid;
@property (nonatomic) BOOL isConnected;
//@property (nonatomic) BOOL synchronousServerStatus;
@property (nonatomic) NSInteger onlineNumber;
@property (nonatomic) NSInteger chattingNumber;
@property (nonatomic) BOOL isReceivingMsg;

@property (strong, nonatomic) NSMutableArray *readMsgArray;
@property (nonatomic) NSInteger *readMsgCount;
@property (strong, nonatomic) NSMutableArray *readMsgTimestamps;
@property (nonatomic, retain) NSString *receivedMsg;
@property (nonatomic) BOOL *networkIsOk;
@property (nonatomic) NSInteger httpRequestTimeoutTimes;
@property (nonatomic, retain) NSString *customerAvaterImg;
@property (nonatomic, retain) NSData *customerAvaterImgData;
@property (nonatomic) BOOL *autoConnect;
@property (nonatomic, retain) NSString *fromDeveceType;//unknown、web、android、ios


+ (SharedSingleConfig *)Instance;

-(BOOL)insertMsgDataToTable:(NSString *)msg msgtype:(NSString *)msgtype date:(NSString *)date;
-(NSMutableArray *)queryData;
-(BOOL)updateSessionId;
@end
