//
//  MolurenHistoryNavigController.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatHistoryDB.h"

@protocol HistoryNavigControllerDelegate

@required

-(void)PushViewController;

-(void)PopViewController;

@end

@interface MolurenHistoryNavigController : UINavigationController<HistoryNavigControllerDelegate>{
    ChatHistoryDB * hisDB;
    NSMutableArray * _hisData;
}

- (id) initWithSid:(NSString *) sid;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleView;
@property (strong, nonatomic) UINavigationItem *CustomNavigItem;

@end
