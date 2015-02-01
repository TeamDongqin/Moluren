//
//  ChatHistoryDB.m
//  Moluren
//
//  Created by tcl-macpro on 14-11-20.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "ChatHistoryDB.h"

@implementation ChatHistoryDB

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db = [ChatHistoryDBManager defaultDBManager].dataBase;
        
    }
    return self;
}

/**
 * @brief 创建数据库
 */
- (void) createDataBase {
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kHistoryTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        [AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (tid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, tokenid VARCHAR(50),sid VARCHAR(20) NOT NULL,msg VARCHAR(1000),msgtype VARCHAR(8),date VARCHAR(20))",kHistoryTableName];
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            [AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            [AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (BOOL) saveHistory:(ChatHistoryEntity *) his{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",kHistoryTableName];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:4];
    if (his.tokenid) {
        [keys appendString:@"tokenid,"];
        [values appendString:@"?,"];
        [arguments addObject:his.tokenid];
    }
    if (his.sessionid) {
        [keys appendString:@"sid,"];
        [values appendString:@"?,"];
        [arguments addObject:his.sessionid];
    }
    if (his.msg) {
        [keys appendString:@"msg,"];
        [values appendString:@"?,"];
        [arguments addObject:his.msg];
    }
    if (his.msgtype) {
        [keys appendString:@"msgtype,"];
        [values appendString:@"?,"];
        [arguments addObject:his.msgtype];
    }
    if (his.date) {
        [keys appendString:@"date,"];
        [values appendString:@"?,"];
        [arguments addObject:his.date];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"%@",query);
    [AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    return [_db executeUpdate:query withArgumentsInArray:arguments];
}

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) deleteMsgWithSId:(NSString *) sid{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE sid = '%@'",kHistoryTableName,sid];
    [AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
/*
- (void) mergeWithUser:(SUser *) user {
    if (!user.uid) {
        return;
    }
    NSString * query = @"UPDATE SUser SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (user.name) {
        [temp appendFormat:@" name = '%@',",user.name];
    }
    if (user.description) {
        [temp appendFormat:@" description = '%@',",user.description];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],user.uid];
    NSLog(@"%@",query);
    
    [AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}
*/
/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
- (NSArray *) findWithTid:(NSString *) tid limit:(int) limit {
    NSString * query = [NSString stringWithFormat:@"SELECT tid,sid,tokenid,msg,msgtype,date FROM %@",kHistoryTableName];
    if (!tid) {
        query = [query stringByAppendingFormat:@" ORDER BY datetime(date) ASC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE tid > %@ ORDER BY datetime(date) ASC limit %d",tid,limit];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        ChatHistoryEntity *his = [ChatHistoryEntity new];
        his.tid = [rs stringForColumn:@"tid"];
        his.sessionid = [rs stringForColumn:@"sid"];
        his.tokenid = [rs stringForColumn:@"tokenid"];
        his.msg = [rs stringForColumn:@"msg"];
        his.msgtype = [rs stringForColumn:@"msgtype"];
        his.date = [rs stringForColumn:@"date"];
        [array addObject:his];
    }
    [rs close];
    return array;
}

- (NSArray *) findWithSidForDetail:(NSString *)sid limit:(int) limit {
    NSString * query = [NSString stringWithFormat:@"SELECT tid,sid,tokenid,msg,msgtype,date FROM %@ WHERE sid='%@' ORDER BY tid",kHistoryTableName,sid];
    //NSLog(query);
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        ChatHistoryEntity *his = [ChatHistoryEntity new];
        his.tid = [rs stringForColumn:@"tid"];
        his.sessionid = [rs stringForColumn:@"sid"];
        his.tokenid = [rs stringForColumn:@"tokenid"];
        his.msg = [rs stringForColumn:@"msg"];
        his.msgtype = [rs stringForColumn:@"msgtype"];
        his.date = [rs stringForColumn:@"date"];
        [array addObject:his];
    }
    [rs close];
    return array;
}

-(NSInteger)findPreSitWithCurrentSid:(NSString *)sid{
    NSInteger res= -1000;
    NSString * query = [NSString stringWithFormat:@"SELECT MAX(cast(sid as INTEGER)) as sid FROM %@ WHERE cast(sid as INTEGER)<%@ ",kHistoryTableName,sid];
    FMResultSet * rs = [_db executeQuery:query];
    if([rs columnCount]!=1){
        return res;
    }
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        res = [rs intForColumn:@"sid"];
    }
    return res;
}


- (NSArray *) findWithSid:(int) limit {
    NSString * query = [NSString stringWithFormat:@"SELECT DISTINCT sid FROM %@ ORDER BY cast(sid as integer)",kHistoryTableName];
    /*if (!tid) {
        query = [query stringByAppendingFormat:@" ORDER BY datetime(date) ASC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE tid > %@ ORDER BY datetime(date) ASC limit %d",tid,limit];
    }*/
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        [array addObject:[rs stringForColumn:@"sid"]];
    }
    [rs close];
    return array;
}

-(NSInteger *)getNewSessionId{
    NSString * query = [NSString stringWithFormat:@"SELECT max(cast(sid as INTEGER)) sid FROM %@",kHistoryTableName];
    FMResultSet * rs = [_db executeQuery:query];
    NSInteger *maxSessionId = 1;
    while ([rs next]) {
        maxSessionId = [rs intForColumn:@"sid"]+1;
    }
    [rs close];
    return maxSessionId;
}

@end
