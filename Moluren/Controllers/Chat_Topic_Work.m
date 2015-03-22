//
//  Chat_Topic_Work.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/16.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "Chat_Topic_Work.h"

@interface Chat_Topic_Work ()

@property (nonatomic, strong) UIImage* ChatterPortrait;

@end

@implementation Chat_Topic_Work

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)CustomizeTopicTheme {
    // Set up view title
    UIView *navTitle = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/2-100, 10, 200, 32)];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"工作";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0xed1941);
    titleLabel.frame = CGRectMake(0, 0, 200, 30);
    
    [navTitle addSubview:titleLabel];
    
    // Set up right bar button
    UIImage *RightBarButtonImage = [UIImage imageNamed:@"TopicWork_PowerButton_On"];
    
    UIButton *RightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-150, 24, 30, 30)];
    [RightBarButton setBackgroundImage:RightBarButtonImage forState:UIControlStateNormal];
    [RightBarButton addTarget:self action:@selector(onDisconectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *RightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:RightBarButton];
    
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    
    // Set up chatter's portrait
    self.ChatterPortrait = [UIImage imageNamed:@"Portrait_TopicWork"];
    
    // Set up multimedia menu Ui
    // ? JSMessageViewController inherit ?
}


- (UIImage *)avatarImageForIncomingMessage
{
    return self.ChatterPortrait;
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
