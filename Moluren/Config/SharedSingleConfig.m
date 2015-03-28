//
//  SharedSingleConfig.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-13.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "SharedSingleConfig.h"
@interface SharedSingleConfig()

@end
@implementation SharedSingleConfig

@synthesize token;
@synthesize nowsessionid;
@synthesize isConnected;
//@synthesize synchronousServerStatus;
@synthesize onlineNumber;
@synthesize chattingNumber;
@synthesize isReceivingMsg;
@synthesize readMsgArray;
@synthesize readMsgCount;
@synthesize readMsgTimestamps;
@synthesize receivedMsg;
@synthesize networkIsOk;
@synthesize httpRequestTimeoutTimes;
@synthesize customerAvaterImg;
@synthesize customerAvaterImgData;
@synthesize autoConnect;
@synthesize fromDeveceType;


-(id)init
{
    if(self=[super init])
    {
        token=@"";
        isConnected=NO;
        //synchronousServerStatus=NO;
        onlineNumber=0;
        chattingNumber=0;
        isReceivingMsg=NO;
        readMsgArray = [NSMutableArray array];
        readMsgCount = 0;
        readMsgTimestamps = [NSMutableArray array];
        receivedMsg = @"";
        networkIsOk = YES;
        httpRequestTimeoutTimes = 0;
        customerAvaterImg = [self firstInitCustomerAvaterImgString];
        //customerAvaterImg=[NSString stringWithFormat:@"%@.%@",defaultAvaterName,@"png"];
        
        _hisDB = [[ChatHistoryDB alloc] init];
        [_hisDB createDataBase];
        
        nowsessionid=[NSString stringWithFormat:@"%d",[_hisDB getNewSessionId]];
        autoConnect = self.isSettedAutoConnect;
        fromDeveceType = @"unknown";
    }
    return self;
}

-(NSString *)firstInitCustomerAvaterImgString
{
    
    if([self isFileExist:[NSString stringWithFormat:@"%@.%@",defaultAvaterName,@"jpg"]]){
        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),defaultAvaterName,@"jpg"];
        UIImage *avaterImg = [[UIImage alloc]initWithContentsOfFile:aPath3];
        customerAvaterImgData = UIImageJPEGRepresentation(avaterImg, 1.0);
        return [NSString stringWithFormat:@"%@.%@",defaultAvaterName,@"jpg"];
    }else if([self isFileExist:[NSString stringWithFormat:@"%@.%@",defaultAvaterName,@"png"]]){
        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),defaultAvaterName,@"png"];
        UIImage *avaterImg = [[UIImage alloc]initWithContentsOfFile:aPath3];
        customerAvaterImgData = UIImagePNGRepresentation(avaterImg);
        return [NSString stringWithFormat:@"%@.%@",defaultAvaterName,@"png"];
    }else{
        customerAvaterImgData= UIImagePNGRepresentation([UIImage imageNamed:@"Portrait_Self"]);
        return @"";
    }
}

-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingFormat:[NSString stringWithFormat:@"/%@",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

-(BOOL)isSettedAutoConnect
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MolurenAutoConnect"]) {
        return YES;
    }
    else{
        //默认不设置为断开自动重连
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MolurenAutoConnect"];
        return NO;
    }
}

+ (SharedSingleConfig *)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(BOOL)insertMsgDataToTable:(NSString *)msg msgtype:(NSString *)msgtype date:(NSString *)date
{
    ChatHistoryEntity * his = [ChatHistoryEntity new];
    his.tokenid = token;
    his.sessionid = nowsessionid;
    his.msg = msg;
    his.msgtype = msgtype;
    his.date = date;
    return [_hisDB saveHistory:his];

}

-(NSMutableArray *)queryData
{
        NSMutableArray *Mutablearray = [NSMutableArray arrayWithCapacity:0];
        
    return Mutablearray;
}

-(BOOL)updateSessionId
{
    nowsessionid=[NSString stringWithFormat:@"%d",[_hisDB getNewSessionId]];
    return YES;
}

@end
