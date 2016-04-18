//
//  LPAlertView.h
//  FineExAPP
//
//  Created by FineexMac on 15/12/21.
//  Copyright © 2015年 FineEX-LF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPAlertView : UIView

#pragma mark -
///自定义警示框（一个确定按钮，无事件响应，默认主题）
+ (void)showComfireWithMessage:(NSString *)message;

///自定义警示框（一个确定按钮，无事件响应）
+ (void)showComfireWithTitle:(NSString *)title message:(NSString *)message;

#pragma mark -
///自定义警示框（一个按钮，无事件响应，默认主题）
+ (void)showOneButtonWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle;

///自定义警示框（一个按钮，无事件响应）
+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

///自定义警示框（一个按钮，有事件响应）
+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(void (^)())block;

#pragma mark -
///自定义警示框（“确定” + 无事件“取消”）
+ (void)showOkCancelWithTitle:(NSString *)title message:(NSString *)message okBlock:(void (^)())okBlock;

///自定义警示框（“确定” + “取消”）
+ (void)showOkCancelWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock okBlock:(void (^)())okBlock;


#pragma mark -
///自定义警示框
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
            leftTitle:(NSString *)leftTitle
           rightTitle:(NSString *)rightTitle
            leftBlock:(void (^)())leftBlock
           rightBlock:(void (^)())rightBlock;

///自定义警示框（左上角有取消按钮）
+ (void)showCancelWithTitle:(NSString *)title
                    message:(NSString *)message
                  leftTitle:(NSString *)leftTitle
                 rightTitle:(NSString *)rightTitle
                  leftBlock:(void (^)())leftBlock
                 rightBlock:(void (^)())rightBlock;

@end
