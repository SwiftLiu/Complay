//
//  NetworkTool.m
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "NetTool.h"
#import "UserModel.h"

#define T_USER @"_User"
#define T_TASK @"Task"

@implementation NetTool

#pragma mark - 账户管理
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed
{
    [BmobUser loginInbackgroundWithAccount:account andPassword:psd block:^(BmobUser *user, NSError *error) {
        if (!error) {
            //更新用户信息单例数据
            [[UserModel shareModel] initWithBmobUser:user];
            //缓存用户信息
            /*已使用BmobUser缓存机制*/
            //登录成功回调
            if (succeed) succeed(user);
        }else{
            if (failed) failed();
            NSLog(@"登录失败：%@", error);
        }
    }];
}

+ (void)logout
{
    [BmobUser logout];
    [[UserModel shareModel] initWithBmobUser:[BmobUser getCurrentUser]];
}

@end
