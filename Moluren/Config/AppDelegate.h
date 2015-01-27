//
//  AppDelegate.h
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * @brief 在状态栏显示 一些Log
 *
 * @param string 需要显示的内容
 * @param duration  需要显示多长时间
 */
+ (void) showStatusWithText:(NSString *) string duration:(NSTimeInterval) duration;
@end

