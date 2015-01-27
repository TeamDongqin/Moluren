//
//  PreviousHistoryPage.h
//  Moluren
//
//  Created by zheng lingshan on 15/1/13.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYNavigationController.h"
#import "JSMessagesViewController.h"
#import "ChatHistoryDB.h"

@interface PreviousHistoryPage : JSMessagesViewController<DYNavigationControllerDelegate>{
    ChatHistoryDB * hisDB;
    NSMutableArray * _hisData;
}


- (id) initWithSid:(NSString *) sid;
@property (strong, nonatomic) UITableView *tableView;
@end
