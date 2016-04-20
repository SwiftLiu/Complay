//
//  MainTabBarController.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MainTabBarController.h"
#import "TabBarItem.h"
#import "MainTabBar.h"
#import "HomeViewController.h"
#import "TaskViewController.h"
#import "MsgListViewController.h"
#import "MineViewController.h"
#import "AddView.h"
#import "CommonConstants.h"

@interface MainTabBarController ()<MainTabBarDelegate>
{
    MainTabBar *tabBar;
    AddView *addView;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingStatusBarAndNavigationBar];
    [self initCotrollers];
    [self initTabBar];
}

//设置状态栏和导航栏
- (void)settingStatusBarAndNavigationBar
{
    //状态栏风格
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //导航栏
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [UINavigationBar appearance].titleTextAttributes = attr;
    [UINavigationBar appearance].barTintColor = [UIColor colorWithWhite:0 alpha:0.95];
}

//初始化自定义标签栏
- (void)initTabBar
{
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    tabBar = [MainTabBar tabBar];
    tabBar.delegate = self;
    tabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabBar];
}

//初始化根控制器
- (void)initCotrollers
{
    HomeViewController *homeVC = [HomeViewController new];
    homeVC.title = @"首页";
    UINavigationController *homeNC =  [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    TaskViewController *taskVC = [TaskViewController new];
    taskVC.title = @"任务";
    UINavigationController *taskNC =  [[UINavigationController alloc] initWithRootViewController:taskVC];
    
    MsgListViewController *msgVC = [MsgListViewController new];
    msgVC.title = @"消息";
    UINavigationController *msgNC =  [[UINavigationController alloc] initWithRootViewController:msgVC];
    
    MineViewController *mineVC = [MineViewController new];
    mineVC.title = @"我的";
    UINavigationController *mineNC =  [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[homeNC, taskNC, msgNC, mineNC];
    for (UITabBarItem *item in self.tabBar.items) {
        item.title = nil;
    }
}


#pragma mark - <MainTabBarDelegate>协议实现
- (void)didSelectedIndex:(NSInteger)index
{
    if (self.selectedIndex != index) {
        //个人中心需登录
        if (index == 3) {
            
        }
        [self setSelectedIndex:index];
    }
}

- (void)pressedAddButton:(UIButton *__weak)addButton
{
    if (addButton.selected) {
        addView = [AddView new];
        [addView setHideBlock:^{ addButton.selected = NO; }];
        [addView show];
    }else{
        [addView hide];
        addView = nil;
    }
}

@end
