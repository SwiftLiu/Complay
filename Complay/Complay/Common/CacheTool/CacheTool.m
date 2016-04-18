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
    [ud setObject:dic forKey:@"keepUserAndPsd"];//设置值
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<NSString*> *)getAccountAndPsd
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud objectForKey:@"keepUserAndPsd"];
    NSArray *result = @[dic[@"account"]?:@"", dic[@"psd"]?:@""];
    return result;
}

#pragma mark - 

@end
