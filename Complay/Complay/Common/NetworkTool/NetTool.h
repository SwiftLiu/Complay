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
typedef void (^FailedBlock)();

@interface NetTool : NSObject

#pragma mark - 账户管理
///登录
+ (void)loginWithAccount:(NSString *)account psd:(NSString *)psd succeed:(SucceedBlock)succeed failed:(FailedBlock)failed;
///注销账号
+ (void)logout;

@end
