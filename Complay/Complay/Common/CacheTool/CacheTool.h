//
//  CacheTool.h
//  Complay
//
//  Created by FineexMac on 16/4/18.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheTool : NSObject

#pragma mark - 账号管理
///记住账号密码
+ (void)rememberAccount:(NSString *)account psd:(NSString *)psd;
///获取缓存的账号密码
+ (NSArray<NSString*> *)getAccountAndPsd;
///删除保存的密码
+ (void)deletePsd;

#pragma mark - 资源文件
///缓存头像（覆盖）
+ (void)saveAvatarData:(NSData *)headData forUserId:(NSString *)userId;
///沙盒里读取头像
+ (UIImage *)getLocalAvatarOfUserId:(NSString *)userId;

@end
