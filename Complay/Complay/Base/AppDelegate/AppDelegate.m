//
//  AppDelegate.m
//  Complay
//
//  Created by FineexMac on 16/4/7.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "UserModel.h"
#import "CacheTool.h"
#import "NetTool.h"
#import "MsgTool.h"

@interface AppDelegate ()

@property (strong, nonatomic) BmobIM *shareIM;
@property (strong, nonatomic) MsgTool *msgTool;

@end

@implementation AppDelegate

#pragma mark - App Launch
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //崩溃日志搜集
    NSSetUncaughtExceptionHandler(uncaughtHandler);
    
    //配置Bmob AppKey
    [self initBmobKey];
    
    //自动登录
    [self autoLogin];
    
    //初始化window
    [self initWindow];
    
    return YES;
}

//崩溃日志搜集
void uncaughtHandler(NSException *exception) {
    NSString *reason = [exception reason];
    NSLog(@"崩溃日志reason--------------%@", reason);
};

///配置Bmob AppKey
- (void)initBmobKey
{
    static NSString *AppKey = @"0ca519009e02689ee294f290496521f3";
    [Bmob registerWithAppKey:AppKey];
    [Bmob setBmobRequestTimeOut:25];
    //即时聊天
    self.shareIM = [BmobIM sharedBmobIM];
    [self.shareIM registerWithAppKey:AppKey];
    self.msgTool = [MsgTool new];
    self.shareIM.delegate = self.msgTool;
    
    //链接即时聊天服务器
    [self loginIM];
    
    //注册通知，监听账户的登录和注销
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogout:) name:kLoginOrLogoutNotification object:nil];
}

///自动登录
- (void)autoLogin
{
    NSString *account = [CacheTool getAccountAndPsd].firstObject;
    NSString *psd = [CacheTool getAccountAndPsd].lastObject;
    if (account && account.length && psd && psd.length) {
        [NetTool loginWithAccount:account psd:psd succeed:^(BmobObject *object) {
            NSLog(@"自动登录成功!");
        } failed:^(NSString *msg) {
            NSLog(@"自动登录失败!");
        }];
    }
}

///初始化window
- (void)initWindow
{
    _window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    MainTabBarController *tabBC = [MainTabBarController new];
    _window.rootViewController = tabBC;
    [_window makeKeyAndVisible];
    //刷新未读消息总数
    [MainTabBarController updateNewMsgTotalClear:NO];
}

#pragma mark - 即使聊天登录退出处理
//监听
- (void)loginOrLogout:(NSNotification *)noti
{
    if ([noti.object boolValue]) {
        [self loginIM];
        //刷新未读消息总数
        [MainTabBarController updateNewMsgTotalClear:NO];
    }else {
        [self logoutIM];
        //未读消息总数清零
        [MainTabBarController updateNewMsgTotalClear:YES];
    }
}

//退出登录
- (void)logoutIM
{
    [self.shareIM disconnect];
    NSLog(@"iM即时聊天服务器 已断开");
}

//连接Bmob即使聊天服务器
- (void)loginIM
{
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        [self.shareIM setupBelongId:user.objectId];
//        [self.shareIM setupDeviceToken:@""];
        [self.shareIM connect];
        NSLog(@"iM即时聊天服务器 已连接");
    }
}


#pragma mark - App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //退出即时聊天服务器
    if ([self.shareIM isConnected]) {
        [self logoutIM];
    }
}

#pragma mark - App进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //链接即时聊天服务器
    [self loginIM];
}


#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
