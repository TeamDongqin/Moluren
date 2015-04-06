//
//  TdColorPattern.h
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TdTopic : NSObject

+ (TdTopic*)Instance;

-(void)SetCurrentTopic:(Topic)Topic;

-(UIColor*)GetCurrentColorPattern;
-(UIColor*)GetCurrentTopicOpacityColor;
-(UIImage*)GetCurrentTopicPortrait;
-(UIImage*)GetCurrentHistoryDetailDeleteImage;
-(UIImage*)GetCurrentNotificationImage;
-(UIImage*)GetCurrentDisconnectImage;
-(UIImage*)GetCurrentSPowerImage;
-(NSString*)GetCurrentConfirmText;
-(NSString*)GetCurrentTdAlertViewText;
-(NSString*)GetCurrentTdDisconnectViewText;
-(NSString*)GetCurrentTdTransferViewText;

@end
