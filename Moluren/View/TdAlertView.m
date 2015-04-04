//
//  TdAlertView.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/4.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "TdAlertView.h"

@interface TdAlertView()



@end

@implementation TdAlertView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    //self.backgroundColor = [[[TdTopic Instance] GetCurrentColorPattern] colorWithAlphaComponent:0.6f];
    self.backgroundColor = [UIColor whiteColor];
    
    //UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 5, 12, Device_Width * 4 / 5, 40)];
    UILabel* label = [[UILabel alloc] init];
    label.text = [[TdTopic Instance] GetCurrentTdAlertViewText];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
//    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
//                                 relatedBy:NSLayoutRelationEqual toItem:self
//                                 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//    
//    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY
//                                 relatedBy:NSLayoutRelationEqual toItem:self
//                                 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self addSubview:label];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopicMotion_SessionDisconnected"]];
    
    [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual toItem:imageView
                                 attribute:NSLayoutAttributeLeading multiplier:17.78 constant:0];
    
    [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual toItem:self
                                 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self addSubview:imageView];
}


@end
