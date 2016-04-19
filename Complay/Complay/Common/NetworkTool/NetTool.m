//
//  NetworkTool.m
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "NetTool.h"
#import "CacheTool.h"

#define T_USER @"_User"
#define T_TASK @"Task"

@implementation NetTool

#pragma mark - 账户管理
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed
{
    int oldHeadVersion = [[[BmobUser getCurrentUser] objectForKey:@"headVersion"] intValue];
    [BmobUser loginInbackgroundWithAccount:account andPassword:psd block:^(BmobUser *user, NSError *error) {
        if (!error) {
            //头像版本是否更改
            int newHeadVersion = [[user objectForKey:@"headVersion"] intValue];
            [UserModel currentUser].newHead = oldHeadVersion != newHeadVersion;
            //更新用户信息单例数据
            [[UserModel currentUser] initWithBmobUser:user];
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
    [[UserModel currentUser] initWithBmobUser:[BmobUser getCurrentUser]];
    [CacheTool deletePsd];
}


#pragma mark - 资源文件管理
///异步下载
+ (void)getHeadImgFromUrl:(NSString *)url userId:(NSString *)userId complete:(void (^)(UIImage *))block
{
    NSURL *URL = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *img = [UIImage imageWithData:data];
        //缓存
        [CacheTool cacheHeadData:data userId:userId];
        //回调（主线程）
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(img);
        });
    });
}

///先从本地获取头像，若没有则下载并缓存头像（按用户Id）
+ (void)getHeadImgOfUser:(UserModel *)user complete:(void (^)(UIImage *))block
{
    //如果头像版本更新则需要下载
    if (user.newHead) {
        [NetTool getHeadImgFromUrl:user.headUrl userId:user.userId complete:block];
    }else {
        //获取本地缓存头像
        UIImage *locImg = [CacheTool getLocalHeadImgOfUserId:user.userId];
        if (locImg) {
            if (block) block(locImg);
        }
        //异步下载
        else {
            [NetTool getHeadImgFromUrl:user.headUrl userId:user.userId complete:block];
        }
    }
}

///上传并缓存用户头像
+ (void)uploadHeadData:(NSData *)headData complete:(void (^)(BOOL))block
{
    //上传文件
    NSString *fileName = [[UserModel currentUser].userId stringByAppendingPathExtension:@"png"];
    BmobFile *newFile = [[BmobFile alloc] initWithFileName:fileName withFileData:headData];
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
                    //修改model
                    [UserModel currentUser].headUrl = newFile.url;
                    //缓存头像
                    [CacheTool cacheHeadData:headData userId:[UserModel currentUser].userId];
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


@end
