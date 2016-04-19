//
//  NetworkTool.h
//  Complay
//
//  Created by FineexMac on 16/4/15.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

typedef void (^SucceedBlock)(BmobObject *object);
typedef void (^FailedBlock)(NSString *msg);

@interface NetTool : NSObject

#pragma mark - 账户管理
///登录
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed;
///注销账号
+ (void)logout;


#pragma mark - 资源文件管理
///先从本地获取头像，若没有则下载并缓存头像（按用户Id）
- (void)getHeadImgOfUserId:(NSString *)userId complete:(void(^)(UIImage *img))block;
///上传并缓存用户头像
- (void)uploadHeadImg:(UIImage *)img complete:(void (^)(NSString *headUrl))block;

@end
