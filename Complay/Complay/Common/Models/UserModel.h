//
//  UserModel.h
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface BmobUser (UserModel)

///用户Id
- (NSString *)userId;
///头像Url
- (NSString *)avatarUrl;
///等级
- (NSInteger)stage;
///等级名称
- (NSString *)stageName;

///微博
- (NSString *)weboName;
///个人链接
- (NSString *)link;
///链接名称
- (NSString *)linkName;

///粉丝数
- (NSInteger)fansCount;
///关注数
- (NSInteger)careCount;
///新任务数(发布)
- (NSInteger)newSendTaskCount;
///新任务数(接手)
- (NSInteger)newGetTaskCount;
///历史任务数(发布)
- (NSInteger)oldSendTaskCount;
///历史任务数(接手)
- (NSInteger)oldGetTaskCount;

///登录后才处理
+ (void)dealBlock:(void(^)())block;

@end