//
//  HomeBgImage.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/29.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "HomeBgImage.h"

@interface HomeBgImage()

@property (strong, nonatomic) UIImage* Image;

@end

@implementation HomeBgImage

+ (HomeBgImage*)Instance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(UIImage*)GetHomeBgImage{
    if(self.Image == nil){
        self.Image = [UIImage imageNamed:[self GetImageFileName]];
    }
    
    return self.Image;
}

-(NSString*)GetImageFileName{
    
    NSString *ImageFileName = nil;
    
    DeviceType deviceType = [[TdUtilities Instance] GetDeviceType];
    switch (deviceType) {
        case Device_iPhone4:
        case Device_iPhone4s:
            {
                ImageFileName = @"SkynightBG4s";
            }
                break;
        case Device_iPhone5:
        case Device_iPhone5c:
        case Device_iPhone5s:
            {
                ImageFileName = @"SkynightBG5s";
            }
            break;
        case Device_iPhone6:
            {
                ImageFileName = @"SkynightBG5s";
            }
            break;
        case Device_iPhone6Plus:
            {
                ImageFileName = @"SkynightBG5s";
            }
            break;
        case Device_Default:
        default:
            {
                ImageFileName = @"SkynightBG5s";
            }
            break;
    }
    
    return ImageFileName;
}

@end
