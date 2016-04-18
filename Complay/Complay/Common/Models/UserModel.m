//
//  UserModel.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel : NSObject 

#pragma mark - 单利
+ (UserModel *)shareModel
{
    static UserModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UserModel alloc] init];
    });
    return model;
}

#pragma mark - 初始化数据
- (void)initWithBmobUser:(BmobUser *)user
{
    _isLogin   = user ? YES : NO;
    _userId    = [user objectForKey:@"userId"];
    _bmobId    = user.objectId;
    _nickname  = user.username;
    _stage     = [[user objectForKey:@"stage"] intValue];
    _stageName = [user objectForKey:@"stageName"];
    
    _email    = user.email;
    _phoneNum = user.mobilePhoneNumber;
    _weboName = [user objectForKey:@"weboName"];
    _link     = [user objectForKey:@"link"];
    _linkName = [user objectForKey:@"linkName"];
    
    _fansCount = [[user objectForKey:@"fansCount"] intValue];
    _careCount = [[user objectForKey:@"careCount"] intValue];
    _newSendTaskCount = [[user objectForKey:@"newSendTaskCount"] intValue];
    _newGetTaskCount  = [[user objectForKey:@"newGetTaskCount"] intValue];
    _oldSendTaskCount = [[user objectForKey:@"oldSendTaskCount"] intValue];
    _oldGetTaskCount  = [[user objectForKey:@"oldGetTaskCount"] intValue];
}


@end
