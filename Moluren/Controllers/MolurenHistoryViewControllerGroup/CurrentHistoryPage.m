//
//  CurrentHistoryPage.m
//  Moluren
//
//  Created by zheng lingshan on 15/1/13.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "CurrentHistoryPage.h"
#import "PreviousHistoryViewController.h"
#import "NextHistoryViewController.h"

@interface CurrentHistoryPage ()

-(void)pushNextHistoryPage;
-(void)pushPreviousHistoryPage;

@end

@implementation CurrentHistoryPage

@synthesize navigator = _navigator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubView{
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [right setTitle:@"Tap to push a new view in" forState:UIControlStateNormal];
    [right setFrame:CGRectMake(50, 100, 220, 40)];
    [right addTarget:self action:@selector(pushNextHistoryPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
}

- (void)pushPreviousHistoryPage{
    PreviousHistoryViewController *prevPage = [[PreviousHistoryViewController alloc] init];
    [self.navigator pushViewController:prevPage];
    //[prevPage release];
}

- (void)pushNextHistoryPage{
    NextHistoryViewController *nextPage = [[NextHistoryViewController alloc] init];
    [self.navigator pushViewController:nextPage];
//    [self.navigationController pushViewController:nextPage animated:YES];
    //[nextPage release];
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
