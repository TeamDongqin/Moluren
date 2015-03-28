//
//  BaseViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "BaseViewController.h"
#import "SharedSingleConfig.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView
{
    [super loadView];
    _sharedConfig = [SharedSingleConfig Instance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
