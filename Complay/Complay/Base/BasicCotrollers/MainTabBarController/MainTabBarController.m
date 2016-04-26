//
//  MainTabBarController.m
//  Complay
//
//  Created by FineexMac on 16/4/8.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MainTabBarController.h"
#import "TabBarItem.h"
#import "HomeViewController.h"
#import "TaskViewController.h"
#import "ConvListViewController.h"
#import "MineViewController.h"
#import "AddView.h"
#import "MsgTool.h"
#import "CommonConstants.h"
#import <BmobIMSDK/BmobIMSDK.h>

@interface MainTabBarController ()<MainTabBarDelegate>
{
    AddView *addView;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingStatusBarAndNavigationBar];
    [self initCotrollers];
    [self initTabBar];
    [self initClearBadgeBlock];
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
    _mTabBar = [MainTabBar tabBar];
    _mTabBar.delegate = self;
    _mTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:_mTabBar];
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
    
    ConvListViewController *msgVC = [ConvListViewController new];
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

//设置未读消息数Badge清空事件
- (void)initClearBadgeBlock
{
    //设置未读消息数
    [_mTabBar setHideBadgeBlock:^(int num, NSInteger index) {
        if (index == 2) {
            //设置未读消息数
            NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
            for (BmobIMConversation *conv in array) {
                [conv updateLocalCache];
                //通知清空所有未读消息数
                [[NSNotificationCenter defaultCenter] postNotificationName:kClearAllNewMsgNotifacation object:nil];
            }
        }
    }];
}

#pragma mark - 刷新tabBar未读消息总数
+ (void)updateNewMsgTotalClear:(BOOL)clear
{
    //设置未读消息数
    int newMsgNum = 0;
    if (!clear) {
        NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
        for (BmobIMConversation *conv in array) {
            newMsgNum += conv.unreadCount;
        }
    }
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    MainTabBarController *mTBC = (MainTabBarController *)rootVC;
    [mTBC.mTabBar setBadgeNum:newMsgNum atIndex:2];
}


#pragma mark - <MainTabBarDelegate>协议实现
- (void)didSelectedIndex:(NSInteger)index
{
    if (self.selectedIndex != index) {
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
