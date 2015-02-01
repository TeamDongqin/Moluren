//
//  NextHistoryPage.h
//  Moluren
//
//  Created by zheng lingshan on 15/1/13.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYNavigationController.h"

@interface NextHistoryViewController : UIViewController<DYNavigationControllerDelegate>

@property (nonatomic, assign) NSInteger *HistoryIndex;

@end
