//
//  TdAlertView.h
//  Moluren
//
//  Created by zheng lingshan on 15/4/4.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TdAlertViewDelegate <NSObject>

-(void)Show;
-(void)Dismiss;

@end

@interface TdAlertView : UIView

@property (nonatomic,weak) id<TdAlertViewDelegate> TdAlertViewDelegate;

@end
