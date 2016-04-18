//
//  MainTabBar.h
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTabBarDelegate <NSObject>

@optional
- (void)didSelectedIndex:(NSInteger)index;
- (void)pressedAddButton:(__weak UIButton *)addButton;

@end

@interface MainTabBar : UIView

@property (weak, nonatomic) UITabBarController <MainTabBarDelegate> *delegate;

+ (MainTabBar *)tabBar;

@end
