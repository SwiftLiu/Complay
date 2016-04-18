//
//  LPAlertView.h
//  FineExCourierAPP
//
//  Created by FineexMac on 15/8/28.
//  Copyright (c) 2015年 FineEX-LF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPCustomHUD : UIView

/// 加载指示器
+ (void)startLoading;
+ (void)endLoading;


/// 提示信息，持续时间按信息长短
+ (void)show:(NSString *)msg;
/// 提示信息
+ (void)show:(NSString *)msg time:(NSTimeInterval)timeInterval;
/// 在指定视图提示信息
+ (void)show:(NSString *)msg inView:(UIView *)view time:(NSTimeInterval)timeInterval;

@end
