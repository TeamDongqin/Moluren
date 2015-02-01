//
//  NextHistoryPage.m
//  Moluren
//
//  Created by zheng lingshan on 15/1/13.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "NextHistoryViewController.h"

@interface NextHistoryViewController ()
//TEST
@end

@implementation NextHistoryViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UILabel *popInstruction = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    popInstruction.backgroundColor = [UIColor clearColor];
    popInstruction.text = @"Swipe right to pop current view out";
    popInstruction.textAlignment = UITextAlignmentCenter;
    popInstruction.shadowOffset = CGSizeMake(0, 1);
    popInstruction.shadowColor = [UIColor whiteColor];
    [self.view addSubview:popInstruction];
    
    UILabel *pushInstruction = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
    pushInstruction.backgroundColor = [UIColor clearColor];
    pushInstruction.text = @"Swipe left to push a new view in";
    pushInstruction.textAlignment = UITextAlignmentCenter;
    pushInstruction.shadowOffset = CGSizeMake(0, 1);
    pushInstruction.shadowColor = [UIColor whiteColor];
    [self.view addSubview:pushInstruction];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DYNavigationControllerDelegate

- (UIViewController *)viewControllerToPush {
    UIViewController *anotherDetailViewController = [[UIViewController alloc] init];
    anotherDetailViewController.view.backgroundColor = [UIColor lightGrayColor];
    return anotherDetailViewController;
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
