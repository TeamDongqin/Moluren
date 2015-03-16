//
//  Chat_Topic_Work.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/16.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "Chat_Topic_Work.h"

@interface Chat_Topic_Work ()

@end

@implementation Chat_Topic_Work

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)CustomizeTopicTheme {
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(MainScreenWidth-130, 0, 60, 30);
    [Btn setImage:[UIImage imageNamed:@"ExitTopicWork"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = Btn;
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
