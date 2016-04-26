//
//  MainTabBarController.h
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBar.h"

@interface MainTabBarController : UITabBarController

@property (weak, nonatomic) MainTabBar *mTabBar;

///刷新tabBar未读消息总数
+ (void)updateNewMsgTotalClear:(BOOL)clear;

@end
