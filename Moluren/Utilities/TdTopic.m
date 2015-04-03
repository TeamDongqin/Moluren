//
//  TdColorPattern.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "TdTopic.h"

@interface TdTopic()

@property (strong,nonatomic) UIColor *CurrentColorPattern;
@property (atomic) Topic CurrentTopic;

@end

@implementation TdTopic

+ (TdTopic*)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(void)SetCurrentTopic:(Topic)Topic{
    self.CurrentTopic = Topic;
}

-(UIColor*)GetCurrentColorPattern{
    UIColor* color = [[UIColor alloc] init];
    
    switch (self.CurrentTopic) {
        case Topic_Life:
            {
                color = UIColorFromRGB(Color_TopicLife_Pattern);
            }
            break;
        case Topic_Motion:
            {
                color = UIColorFromRGB(Color_TopicMotion_Pattern);
            }
            break;
        case Topic_Movie:
            {
                color = UIColorFromRGB(Color_TopicMovie_Pattern);
            }
            break;
        case Topic_Music:
            {
                color = UIColorFromRGB(Color_TopicMusic_Pattern);
            }
            break;
        case Topic_Study:
            {
                color = UIColorFromRGB(Color_TopicStudy_Pattern);
            }
            break;
        case Topic_Work:
            {
                color = UIColorFromRGB(Color_TopicWork_Pattern);
            }
            break;
        default:
            break;
    }
    
    return color;
}

-(UIImage*)GetCurrentTopicPortrait{
    UIImage* image = [[UIImage alloc] init];
    
    switch (self.CurrentTopic) {
        case Topic_Life:
        {
            image = [UIImage imageNamed:@"Portrait_TopicLife"];
        }
            break;
        case Topic_Motion:
        {
            image = [UIImage imageNamed:@"Portrait_TopicMotion"];
        }
            break;
        case Topic_Movie:
        {
            image = [UIImage imageNamed:@"Portrait_TopicMovie"];
        }
            break;
        case Topic_Music:
        {
            image = [UIImage imageNamed:@"Portrait_TopicMusic"];
        }
            break;
        case Topic_Study:
        {
            image = [UIImage imageNamed:@"Portrait_TopicStudy"];
        }
            break;
        case Topic_Work:
        {
            image = [UIImage imageNamed:@"Portrait_TopicWork"];
        }
            break;
        default:
            break;
    }
    
    return image;
}

-(UIImage*)GetCurrentHistoryDetailDeleteImage{
    UIImage* image = [[UIImage alloc] init];
    
    switch (self.CurrentTopic) {
        case Topic_Life:
        {
            image = [UIImage imageNamed:@"Button_Delete_Park"];
        }
            break;
        case Topic_Motion:
        {
            image = [UIImage imageNamed:@"Button_Delete_Hotel"];
        }
            break;
        case Topic_Movie:
        {
            image = [UIImage imageNamed:@"Button_Delete_Cinema"];
        }
            break;
        case Topic_Music:
        {
            image = [UIImage imageNamed:@"Button_Delete_Street"];
        }
            break;
        case Topic_Study:
        {
            image = [UIImage imageNamed:@"Button_Delete_Campus"];
        }
            break;
        case Topic_Work:
        {
            image = [UIImage imageNamed:@"Button_Delete_CoffeeRoom"];
        }
            break;
        default:
            break;
    }
    
    return image;
}

-(UIImage*)GetCurrentNotificationImage{
    UIImage* image = [[UIImage alloc] init];
    
    switch (self.CurrentTopic) {
        case Topic_Life:
        {
            image = [UIImage imageNamed:@"Notification_Park"];
        }
            break;
        case Topic_Motion:
        {
            image = [UIImage imageNamed:@"Notification_Hotel"];
        }
            break;
        case Topic_Movie:
        {
            image = [UIImage imageNamed:@"Notification_Cinema"];
        }
            break;
        case Topic_Music:
        {
            image = [UIImage imageNamed:@"Notification_Street"];
        }
            break;
        case Topic_Study:
        {
            image = [UIImage imageNamed:@"Notification_Campus"];
        }
            break;
        case Topic_Work:
        {
            image = [UIImage imageNamed:@"Notification_CoffeeRoom"];
        }
            break;
        default:
            break;
    }
    
    return image;
}

-(NSString*)GetCurrentConfirmText{
    NSString* string = [[NSString alloc] init];
    
    switch (self.CurrentTopic) {
        case Topic_Life:
        {
            string = @"确定离开'公园'吗?";
        }
            break;
        case Topic_Motion:
        {
            string = @"确定离开'旅社'吗?";
        }
            break;
        case Topic_Movie:
        {
            string = @"确定离开'影院'吗?";
        }
            break;
        case Topic_Music:
        {
            string = @"确定离开'步行街'吗?";
        }
            break;
        case Topic_Study:
        {
            string = @"确定离开'校园'吗?";
        }
            break;
        case Topic_Work:
        {
            string = @"确定离开'咖啡厅'吗?";
        }
            break;
        default:
            break;
    }
    
    return string;
}

@end
