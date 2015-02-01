//
//  CurrentHistoryViewController.h
//  Moluren
//
//  Created by zheng lingshan on 15/1/24.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYNavigationController.h"
#import "JSMessagesViewController.h"
#import "ChatHistoryDB.h"

@interface HistoryViewController : JSMessagesViewController<DYNavigationControllerDelegate>{
    ChatHistoryDB * hisDB;
    NSMutableArray * _hisData;
}

- (id) initWithSid:(NSString *) sid;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign) int HistoryDBIndex;

@end