//
//  TdDisconnectView.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/4.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "TdDisconnectView.h"

@implementation TdDisconnectView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIColor* color = [[TdTopic Instance] GetCurrentTopicOpacityColor];
    [color setFill];  // changes are here
    UIRectFill(rect);               // and here
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 7, 3, Device_Width * 7 / 9, 40)];
    //UILabel* label = [[UILabel alloc] init];
    label.text = [[TdTopic Instance] GetCurrentTdDisconnectViewText];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    //    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
    //                                 relatedBy:NSLayoutRelationEqual toItem:self
    //                                 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    //
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual toItem:self
                                 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self addSubview:label];
    
    long margin_x = Device_Width / 14 - 10 + 5; //Divide 14: Get the image center x; 10: half of image width;5: coordination
    long margin_y = Notification_DisconnectView_Height / 2 - 10 + 2; // Same with margin_x
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin_x, margin_y, 20, 20)];
    imageView.image = [[TdTopic Instance] GetCurrentSPowerImage];
    
    [self addSubview:imageView];
}

@end
