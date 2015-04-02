//
//  PersonViewController.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/2.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

#pragma View life cycle

-(void)viewWillAppear:(BOOL)animated{
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect tableFrame = CGRectMake(0.0f, Page_History_Navigation_Height, Device_Width, Device_Height - Page_History_Navigation_Height);
    self.view.frame = tableFrame;
    //self.view.backgroundColor = UIColorFromRGB(Color_SettingView_Background);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,Page_History_Navigation_Height,Device_Width,Device_Height) style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Ui operation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 5, 12, Device_Width * 3 / 5, 40)];
    label.text = @"个性签名";
    label.textColor = UIColorFromRGB(0x919191);
    label.textAlignment = NSTextAlignmentCenter;
    
    // Set the data for this cell:
    UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 20, Device_Width, 40)];
    [cell addSubview:label];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
