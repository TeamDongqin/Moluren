//
//  SGActionMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-3.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, SGActionViewStyle){
    SGActionViewStyleLight = 0,     // 浅色背景，深色字体
    SGActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^SGMenuActionHandler)(NSInteger index);

@interface SGActionView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) SGActionViewStyle style;

/**
 *  获取单例
 */
+ (SGActionView *)sharedActionView;

/**
 *	提示框弹出层（单按钮）
 *
 *	@param 	title       标题
 *	@param 	message 	提示内容
 *	@param 	buttonTitle 按钮标题
 *	@param 	handler 	点击按钮时回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle
            selectedHandle:(SGMenuActionHandler)handler;

/**
 *	提示框弹出层（双按钮）
 *
 *	@param 	title       标题
 *	@param 	message 	提示内容
 *	@param 	leftTitle 	左按钮标题
 *	@param 	rightTitle 	右按钮标题
 *	@param 	handler 	回调， 0 为左， 1 为右
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftTitle
          rightButtonTitle:(NSString *)rightTitle
            selectedHandle:(SGMenuActionHandler)handler;


@end
