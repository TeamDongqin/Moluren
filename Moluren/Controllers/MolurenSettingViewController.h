//
//  MainTabViewController.h
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SettingsTableViewCell.h"

@interface MolurenSettingViewController : BaseViewController

@property(nonatomic,strong) NSDictionary *UserViewCellDic;
@property (nonatomic, strong) NSArray *listGroupname;

@end
