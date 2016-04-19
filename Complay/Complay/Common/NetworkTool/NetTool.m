//
//  NetworkTool.m
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "NetTool.h"
#import "UserModel.h"
#import "CacheTool.h"

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
    [[UserModel shareModel] initWithBmobUser:[BmobUser getCurrentUser]];
    [CacheTool deletePsd];
}


#pragma mark - 资源文件管理
///先从本地获取头像，若没有则下载并缓存头像（按用户Id）
- (void)getHeadImgOfUserId:(NSString *)userId complete:(void(^)(UIImage *img))block
{
    
}

///上传并缓存用户头像
- (void)uploadHeadImg:(UIImage *)img complete:(void (^)(NSString *))block
{
    //上传文件
    NSString *fileName = [UserModel shareModel].userId;
    NSData *fileData = UIImagePNGRepresentation(img);
    BmobFile *file = [[BmobFile alloc] initWithFileName:fileName withFileData:fileData];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //上传路径到用户表
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:file forKey:@"headImg"];
            [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (!error && isSuccessful) {
                    if (block) block(file.url);
                }else if (block) {
                    block(nil);
                }
            }];
        }else{
            if (block) block(nil);
        }
    } withProgressBlock:^(CGFloat progress) {
        NSLog(@"头像上传进度：%lf", progress);
    }];
}



@end
