//
//  MolurenHistoryViewController.h
//  Moluren
//
//  Created by tcl-macpro on 14-11-6.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatHistoryDB.h"

@interface MolurenHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{

    ChatHistoryDB * hisDB;
    NSMutableArray * _hisData;
}

@property (strong, nonatomic) UITableView *tableView;

@end
