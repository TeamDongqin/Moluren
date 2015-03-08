//
//  MolurenHistoryDetailViewController.h
//  Moluren
//
//  Created by tcl-macpro on 14-11-23.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "ChatHistoryDB.h"
#import "BaseViewController.h"

#import <UIKit/UIKit.h>


@interface MolurenHistoryDetailViewController : BaseViewController{
    ChatHistoryDB * hisDB;
    NSMutableArray * _hisData;
}

- (id) initWithSid:(NSString *) sid;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleView;

@end
