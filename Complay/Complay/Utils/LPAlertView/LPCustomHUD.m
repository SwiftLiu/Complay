//
//  LPAlertView.m
//  FineExCourierAPP
//
//  Created by FineexMac on 15/8/28.
//  Copyright (c) 2015年 FineEX-LF. All rights reserved.
//

#import "LPCustomHUD.h"

#define MARGIN 18

@interface LPCustomHUD ()

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UILabel *msgLabel;

@end

@implementation LPCustomHUD

#pragma mark - 单例
+ (LPCustomHUD *)shareInstance
{
    static LPCustomHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
        instance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        //黑色背景框
        instance.baseView = [UIView new];
        instance.baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        instance.baseView.alpha = 0;
        instance.baseView.clipsToBounds = YES;
        instance.baseView.layer.cornerRadius = 5;
        instance.baseView.userInteractionEnabled = YES;
        [instance addSubview:instance.baseView];
        //提示信息
        instance.msgLabel = [UILabel new];
        instance.msgLabel.numberOfLines = 0;
        instance.msgLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        instance.msgLabel.font = [UIFont systemFontOfSize:16];
        instance.msgLabel.textAlignment = NSTextAlignmentCenter;
        [instance.baseView addSubview:instance.msgLabel];
        //指示器
        instance.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [instance.baseView addSubview:instance.indicator];
    });
    return instance;
}

#pragma mark - 加载
+ (void)startLoading
{
    LPCustomHUD *alertView = [LPCustomHUD shareInstance];
    UIView *view = [[UIApplication sharedApplication].delegate window];
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    
    alertView.msgLabel.hidden = YES;
    alertView.indicator.hidden = NO;
    [alertView.indicator startAnimating];
    
    //位置大小
    CGSize size = alertView.indicator.bounds.size;
    alertView.baseView.bounds = CGRectMake(0, 0, size.width+MARGIN*2, size.height+MARGIN*2);
    alertView.indicator.center = CGPointMake(CGRectGetMidX(alertView.baseView.bounds), CGRectGetMidY(alertView.baseView.bounds));
    alertView.baseView.center = CGPointMake(CGRectGetMidX(alertView.bounds), CGRectGetMidY(alertView.bounds));
    
    //动画
    alertView.baseView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        alertView.baseView.alpha = 1;
    }];
}

+ (void)endLoading
{
    LPCustomHUD *alertView = [LPCustomHUD shareInstance];
    [UIView animateWithDuration:0.3 animations:^{
        alertView.baseView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
    }];
}


#pragma mark - 提示
+ (void)show:(NSString *)msg
{
    double time = msg.length/20.0l + 1;
    [LPCustomHUD show:msg time:time];
}

+ (void)show:(NSString *)msg time:(NSTimeInterval)timeInterval
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [LPCustomHUD show:msg inView:view time:timeInterval];
}


+ (void)show:(NSString *)msg inView:(UIView *)view time:(NSTimeInterval)timeInterval
{
    LPCustomHUD *alertView = [LPCustomHUD shareInstance];
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    
    alertView.msgLabel.text = msg;
    alertView.msgLabel.hidden = NO;
    alertView.indicator.hidden = YES;
    
    //位置大小
    CGSize maxSize = CGSizeMake(alertView.bounds.size.width *.65, alertView.bounds.size.height *.65);
    CGSize size = CGSizeMake(maxSize.width-MARGIN*2, maxSize.height-MARGIN*2);
    NSDictionary *attributes = @{NSFontAttributeName : alertView.msgLabel.font};
    CGRect bounds = [msg boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    alertView.msgLabel.bounds = bounds;
    alertView.baseView.bounds = CGRectMake(0, 0, bounds.size.width+MARGIN*2, bounds.size.height+MARGIN*2);
    alertView.msgLabel.center = CGPointMake(CGRectGetMidX(alertView.baseView.bounds), CGRectGetMidY(alertView.baseView.bounds));
    alertView.baseView.center = CGPointMake(CGRectGetMidX(alertView.bounds), CGRectGetMidY(alertView.bounds));
    
    //动画
    NSTimeInterval duration = 0.3;
    alertView.baseView.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        alertView.baseView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:timeInterval-duration*2 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            alertView.baseView.alpha = 0;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];
}


@end
