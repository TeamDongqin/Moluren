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

@interface MolurenChatViewController : JSMessagesViewController

-(void)addReceivedMessage:(NSString *)receivedMsg;
-(void)backToMainView;

@end
