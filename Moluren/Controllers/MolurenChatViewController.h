//
//  MolurenChatViewController.h
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "ChatHistoryDB.h"
#import "BaseViewController.h"
#import "ConfirmView.h"
#import "MolurenServer.h"

@interface MolurenChatViewController : JSMessagesViewController<ConfirmViewDelegate>

@property (nonatomic, strong) ConfirmView* confirmView;
@property (nonatomic, strong) UIAlertView* tdAlertView;
@property (nonatomic) BOOL *bConnected;

-(void)addReceivedMessage:(NSString *)receivedMsg;
-(void)backToMainView;

@end
