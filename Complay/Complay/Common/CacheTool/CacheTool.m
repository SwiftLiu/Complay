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
///缓存头像（覆盖）
+ (void)cacheHeadImg:(UIImage *)img userId:(NSString *)userId;
{
    
}

///沙盒里读取头像
+ (UIImage *)getLocalHeadImgOfUserId:(NSString *)userId
{
    return [UIImage new];
}

@end
