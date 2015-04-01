//
//  ConfirmViewController.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/1.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 1)];
    view4.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self.view addSubview:view4];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, Device_Width, 64)];
    view1.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self.view addSubview:view1];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 5, 12, Device_Width * 3 / 5, 40)];
    label.text = [[TdTopic Instance] GetCurrentConfirmText];
    label.textColor = UIColorFromRGB(0x919191);
    label.textAlignment = NSTextAlignmentCenter;
    
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual toItem:view1
                                 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual toItem:view1
                                 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    [self.view addSubview:label];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, Device_Width, 1)];
    view2.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self.view addSubview:view2];
    
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114, Device_Width, 7)];
    view3.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self.view addSubview:view3];
    
    UIButton* ConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 66, Device_Width, 48)];
    ConfirmButton.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [ConfirmButton setTitle:@"离 开" forState:UIControlStateNormal];
    [ConfirmButton setTitleColor:[[TdTopic Instance] GetCurrentColorPattern] forState:UIControlStateNormal];
    [self.view addSubview:ConfirmButton];
    
    UIButton* CancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 121, Device_Width, 48)];
    CancelButton.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [CancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [CancelButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [self.view addSubview:CancelButton];
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
