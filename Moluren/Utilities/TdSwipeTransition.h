//
//  TdSwipeTransition.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TdSwipeTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

- (void)attachToViewController:(UIViewController *)viewController;

@end
