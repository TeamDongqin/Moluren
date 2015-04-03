//
//  ConfirmView.h
//  Moluren
//
//  Created by zheng lingshan on 15/4/1.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmViewDelegate <NSObject>

@required

-(void)SendConfirmButtonClickEvent;
-(void)SendCancelButtonClickEvent;

@end

@interface ConfirmView : UIView

@property (nonatomic,weak) id<ConfirmViewDelegate> ConfirmViewDelegate;

@end
