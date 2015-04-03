//
//  PersonNavigController.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/3.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "PersonNavigController.h"

@interface PersonNavigController ()

@property (strong, nonatomic) UIColor *CurrentColorPattern;
@property (strong, nonatomic) UINavigationItem *CustomNavigItem;

@end

@implementation PersonNavigController

#pragma View life cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self CustomizeNavigBar];
}

-(void)CustomizeNavigBar{
    UINavigationBar *CustomNavigBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), Page_History_Navigation_Height)];
    
    self.CustomNavigItem = [[UINavigationItem alloc] init];
    
    self.CurrentColorPattern = [[TdTopic Instance] GetCurrentColorPattern];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)/3, 64);
    label.text = @"陌路者";
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.CurrentColorPattern;
    
    self.CustomNavigItem.titleView = label;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Button_Return_Default"];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    self.CustomNavigItem.leftBarButtonItem = backBarButtonItem;
    
    //    UIImage *rightButtonImage = [UIImage imageNamed:@"Button_Return"];
    //
    //    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:nil];
    //
    //    newItem.rightBarButtonItem = rightBarButtonItem;
    
    [CustomNavigBar setItems:@[self.CustomNavigItem]];
    [CustomNavigBar setTintColor: self.CurrentColorPattern];
    
    [self.view addSubview:CustomNavigBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Ui operation

- (void)backTapped:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
