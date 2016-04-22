//
//  NetworkTool.h
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>

static NSString *kLoginOrLogoutNotification = @"loginOrlogoutNotification";

typedef void (^SucceedBlock)(BmobObject *object);
typedef void (^FailedBlock)(NSString *msg);

@interface NetTool : NSObject

#pragma mark - 账户管理
///登录
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed;
///注销账号
+ (void)logout;


#pragma mark - 资源文件管理
/////先从本地获取头像，若没有则下载并缓存头像（按用户Id）
//+ (void)getAvatarFromUrl:(NSString *)url userId:(NSString *)userId complete:(void (^)(UIImage *))block;
///上传并缓存用户头像
+ (void)uploadAvatarData:(NSData *)avatarData complete:(void (^)(NSString *url))block;


#pragma mark - 下载用户信息
///加载特定用户的信息
+ (void)loadUserWithUserId:(NSString *)objectId completion:(void(^)(BmobIMUserInfo *result))block;
///批量加载用户的信息
+ (void)loadUsersWithUserIds:(NSArray *)array completion:(void(^)(NSArray<BmobIMUserInfo *> *result))block;


@end
