//
//  ChatHistoryDB.h
//  Moluren
//
//  Created by tcl-macpro on 14-11-20.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "ChatHistoryDBManager.h"
#import "ChatHistoryEntity.h"

@interface ChatHistoryDB : NSObject {
    FMDatabase * _db;
}


/**
 * @brief 创建数据库
 */
- (void) createDataBase;
/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (BOOL) saveHistory:(ChatHistoryEntity *) his;

/**
 * @brief 删除一条用户数据
 *
 * @param tid 需要删除的用户的id
 */
- (void) deleteMsgWithSId:(NSString *) sid;

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */

//- (void) mergeWithHistory:(ChatHistoryEntity *) his;

/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
- (NSArray *) findWithTid:(NSString *) tid limit:(int) limit;

- (NSArray *) findWithSidForDetail:(NSString *) sid limit:(int) limit;

- (NSArray *) findWithSid:(int) limit;

-(NSInteger)findPreSitWithCurrentSid:(NSString *)sid;

-(NSInteger *)getNewSessionId;

@end
