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
#import "UserModel.h"
#import "CacheTool.h"
#import "NetTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置Bmob AppKey
    [self initBmobKey];
    
    //自动登录
    [self autoLogin];
    
    //初始化window
    [self initWindow];
    
    return YES;
}

///配置Bmob AppKey
- (void)initBmobKey
{
    [Bmob registerWithAppKey:@"0ca519009e02689ee294f290496521f3"];
}

///自动登录
- (void)autoLogin
{
    [[UserModel shareModel] initWithBmobUser:[BmobUser getCurrentUser]];
    NSString *account = [CacheTool getAccountAndPsd].firstObject;
    NSString *psd = [CacheTool getAccountAndPsd].lastObject;
    if (account && account.length && psd && psd.length) {
        [NetTool loginWithAccount:account psd:psd succeed:^(BmobObject *object) {
            NSLog(@"自动登录成功!");
        } failed:^{
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
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
