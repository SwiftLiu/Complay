//
//  UserModel.h
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobUser.h>

///用户账户修改通知
static NSString *UserDidChangeNotification = @"userDidChangeNotification";

@interface UserModel : NSObject

///用户登录状态
@property (assign, nonatomic, readonly) BOOL isLogin;

///用户Id
@property (strong, nonatomic, readonly) NSString *userId;
///Bmob Id
@property (strong, nonatomic, readonly) NSString *bmobId;
///昵称
@property (strong, nonatomic, readonly) NSString *nickname;
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


///单利
+ (UserModel *)shareModel;
///初始化所有数据
- (void)initWithBmobUser:(BmobUser *)user;

@end