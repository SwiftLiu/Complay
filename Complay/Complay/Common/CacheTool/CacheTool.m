//
//  CacheTool.m
//  Complay
//
//  Created by FineexMac on 16/4/18.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "CacheTool.h"

@implementation CacheTool

#pragma mark - 账号管理
+ (void)rememberAccount:(NSString *)account psd:(NSString *)psd
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = @{@"psd" : psd?:@"", @"account" : account?:@""};
    [ud setObject:dic forKey:@"keepUserAndPsd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<NSString*> *)getAccountAndPsd
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud objectForKey:@"keepUserAndPsd"];
    NSArray *result = @[dic[@"account"]?:@"", dic[@"psd"]?:@""];
    return result;
}

+ (void)deletePsd
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud objectForKey:@"keepUserAndPsd"];
    NSDictionary *newDic = @{@"psd" : @"", @"account" : dic[@"account"]?:@""};
    [ud setObject:newDic forKey:@"keepUserAndPsd"];//设置值
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -#pragma mark - 资源文件
///头像缓存路径
+ (NSString *)pathOfUserId:(NSString *)userId
{
    NSString *dirPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/userHeads"];
    NSFileManager *fileMager = [NSFileManager defaultManager];
    if (![fileMager fileExistsAtPath:dirPath]) {
        [fileMager createDirectoryAtPath:dirPath attributes:@{}];
    }
    NSString *path = [dirPath stringByAppendingFormat:@"/%@.png", userId];
    return path;
}

///缓存头像（覆盖）
+ (void)cacheHeadData:(NSData *)headData userId:(NSString *)userId
{
    NSString *path = [CacheTool pathOfUserId:userId];
    [headData writeToFile:path atomically:YES];
}

///沙盒里读取头像
+ (UIImage *)getLocalHeadImgOfUserId:(NSString *)userId
{
    NSString *path = [CacheTool pathOfUserId:userId];
    NSData *imgData = [[NSFileManager defaultManager] contentsAtPath:path];
    UIImage *img = [UIImage imageWithData:imgData];
    return img;
}

@end
