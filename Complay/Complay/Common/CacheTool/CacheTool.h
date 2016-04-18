//
//  CacheTool.h
//  Complay
//
//  Created by FineexMac on 16/4/18.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheTool : NSObject

#pragma mark - 账号管理
///记住账号密码
+ (void)rememberAccount:(NSString *)account psd:(NSString *)psd;
///获取缓存的账号密码
+ (NSArray<NSString*> *)getAccountAndPsd;

@end
