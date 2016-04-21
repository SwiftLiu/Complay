//
//  NetworkTool.m
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "NetTool.h"
#import "CacheTool.h"
#import "MineViewController.h"

#define T_USER @"_User"
#define T_TASK @"Task"

@implementation BmobIMUserInfo (BmobIMUser)

+(instancetype)userInfoWithBmobUser:(BmobUser *)user
{
    BmobIMUserInfo *info  = [[BmobIMUserInfo alloc] init];
    info.userId = user.objectId;
    info.name = user.username;
    BmobFile *file = [user objectForKey:@"headImg"];
    info.avatar = file.url;
    return info;
}

@end

@implementation NetTool

#pragma mark - 账户管理
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed
{
    int oldHeadVersion = [[[BmobUser getCurrentUser] objectForKey:@"headVersion"] intValue];
    [BmobUser loginInbackgroundWithAccount:account andPassword:psd block:^(BmobUser *user, NSError *error) {
        if (!error) {
            //若头像版本更改，则删除本地缓存头像
            int newHeadVersion = [[user objectForKey:@"headVersion"] intValue];
            if (oldHeadVersion && newHeadVersion > oldHeadVersion) {
                [NetTool loadAvatarFromUrl:user.avatarUrl userId:user.userId complete:^(UIImage *img) {
                    [MineViewController updateUserBaseInfo];
                }];
            }
            //缓存用户信息
            /*已使用BmobUser缓存机制*/
            //登录成功回调
            if (succeed) succeed(user);
        }else{
            NSLog(@"登录失败：%@", error);
            if (error.code == 101) {
                if (failed) failed(@"账号或密码错误");
            }
        }
    }];
}

+ (void)logout
{
    [BmobUser logout];
    [CacheTool deletePsd];
}


#pragma mark - 资源文件管理
///下载头像
+ (void)loadAvatarFromUrl:(NSString *)url userId:(NSString *)userId complete:(void (^)(UIImage *))block
{
    NSURL *URL = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *img = [UIImage imageWithData:data];
        //缓存
        [CacheTool saveAvatarData:data forUserId:userId];
        //回调（主线程）
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(img);
        });
    });
}

///先从本地获取头像，若没有则下载并缓存头像（按用户Id）
+ (void)getAvatarFromUrl:(NSString *)url userId:(NSString *)userId complete:(void (^)(UIImage *))block
{
    if (!userId || !userId.length) {
        if (block) block(nil);
        return;
    }
    //获取本地缓存头像
    UIImage *locImg = [CacheTool getLocalAvatarOfUserId:userId];
    if (locImg) {
        if (block) block(locImg);
    }
    //异步下载
    else if(url && url.length) {
        [NetTool loadAvatarFromUrl:url userId:userId complete:block];
    }
}


///上传并缓存用户头像
+ (void)uploadAvatarData:(NSData *)avatarData complete:(void (^)(BOOL))block
{
    //上传文件
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *fileName = [user.userId stringByAppendingPathExtension:@"png"];
    BmobFile *newFile = [[BmobFile alloc] initWithFileName:fileName withFileData:avatarData];
    [newFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //上传路径到用户表
            BmobUser *user = [BmobUser getCurrentUser];
            
            //更新头像路径
            BmobFile *oldFile = [user objectForKey:@"headImg"];
            [user setObject:newFile forKey:@"headImg"];
            //更新头像版本
            int oldHeadVersion = [[user objectForKey:@"headVersion"] intValue];
            [user setObject:@(oldHeadVersion+1) forKey:@"headVersion"];
            
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (!error && isSuccessful) {
                    //回调
                    if (block) block(YES);
                    //缓存头像
                    [CacheTool saveAvatarData:avatarData forUserId:user.userId];
                    //删除原头像
                    [oldFile deleteInBackground];
                }else {
                    //回调
                    if (block) block(NO);
                    NSLog(@"头像上传失败：%@", error);
                    //删除新头像
                    [newFile deleteInBackground];
                }
            }];
        }else{
            if (block) block(NO);
            NSLog(@"头像上传(资源文件)失败：%@", error);
        }
    } withProgressBlock:^(CGFloat progress) {
        NSLog(@"头像上传进度：%.0lf%%", progress*100);
    }];
}



#pragma mark - 下载用户信息
+ (void)loadUserWithUserId:(NSString *)objectId completion:(void (^)(BmobIMUserInfo *))block
{
    BmobQuery *query = [BmobQuery queryForUser];
    [query getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
        if (!error) {
            BmobUser *user = (BmobUser *)object;
            BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
            if (block) block(info);
        }else{
            if (block) block(nil);
            NSLog(@"下载特定用户信息失败：%@", error);
        }
    }];
}


+ (void)loadUsersWithUserIds:(NSArray *)array completion:(void (^)(NSArray<BmobIMUserInfo *> *))block
{
    NSArray *objectIds = [[BmobIM sharedBmobIM] allConversationUsersIds];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" containedIn:objectIds];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
        if (!error) {
            NSMutableArray<BmobIMUserInfo *> *array = [NSMutableArray array];
            for (BmobUser *user in array1) {
                BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
                [array addObject:info];
            }
            if (block && array.count) block(array);
        }else{
            NSLog(@"批量下载用户信息失败：%@", error);
        }
    }];
}

@end
