//
//  LPBadgeView.h
//  Demo
//
//  Created by FineexMac on 16/2/26.
//  Copyright © 2016年 iOS_LiuLiuLiu. All rights reserved.
//
//  作者GitHub主页 https://github.com/SwiftLiu
//  作者邮箱 1062014109@qq.com
//  下载链接 https://github.com/SwiftLiu/LPBadgeView.git

#import <UIKit/UIKit.h>

@protocol LPBadgeViewDelegate <NSObject>

@optional
///清除
- (void)badgeViewDidClearValue:(int)value;
///开始拖动动画时
- (void)badgeViewDidBeganAnimation;
///结束拖动动画时
- (void)badgeViewDidEndAnimation;

@end


#define LPBadgeDefalutTintColor [UIColor redColor]

@interface LPBadgeView : UIView

///值
@property (assign, nonatomic) int value;
///代理
@property (weak, nonatomic) id <LPBadgeViewDelegate> delegate;

///便利初始化，默认color(主题颜色)为红色
+ (LPBadgeView *)badgeWithColor:(UIColor *)color;

@end
