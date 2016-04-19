//
//  UserModel.h
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface UserModel : NSObject

///用户登录状态
@property (assign, nonatomic, readonly) BOOL isLogin;

///用户Id
@property (strong, nonatomic, readonly) NSString *userId;
///Bmob Id
@property (strong, nonatomic, readonly) NSString *bmobId;
///昵称
@property (strong, nonatomic, readonly) NSString *nickname;
///头像Url
@property (strong, nonatomic) NSString *headUrl;
///是否需要下载新头像
@property (assign, nonatomic) BOOL newHead;
///等级
@property (assign, nonatomic, readonly) int stage;
///等级名称
@property (strong, nonatomic, readonly) NSString *stageName;

///邮箱
@property (strong, nonatomic, readonly) NSString *email;
///手机
@property (strong, nonatomic, readonly) NSString *phoneNum;
///微博
@property (strong, nonatomic, readonly) NSString *weboName;
///个人链接
@property (strong, nonatomic, readonly) NSString *link;
///链接名称
@property (strong, nonatomic, readonly) NSString *linkName;

///粉丝数
@property (assign, nonatomic, readonly) NSInteger fansCount;
///关注数
@property (assign, nonatomic, readonly) NSInteger careCount;

///新任务数(发布)
@property (assign, nonatomic, readonly) NSInteger newSendTaskCount;
///新任务数(接手)
@property (assign, nonatomic, readonly) NSInteger newGetTaskCount;
///历史任务数(发布)
@property (assign, nonatomic, readonly) NSInteger oldSendTaskCount;
///历史任务数(接手)
@property (assign, nonatomic, readonly) NSInteger oldGetTaskCount;


///单利（当前用户）
+ (UserModel *)currentUser;
///初始化所有数据
- (void)initWithBmobUser:(BmobUser *)user;

///登录后才处理
+ (void)dealBlock:(void(^)())block;

@end