//
//  UserModel.m
//  Complay
//
//  Created by FineexMac on 16/4/14.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

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
- (void)initWithDic:(NSDictionary *)dic
{
    _userId    = [dic objectForKey:@"userId"];
    _chatId    = [dic objectForKey:@"chatId"];
    _nickname  = [dic objectForKey:@"nickname"];
    _stage     = [[dic objectForKey:@"stage"] intValue];
    _stageName = [dic objectForKey:@"stageName"];
    
    _email    = [dic objectForKey:@"email"];
    _phoneNum = [dic objectForKey:@"phoneNum"];
    _weboName = [dic objectForKey:@"weboName"];
    _link     = [dic objectForKey:@"link"];
    _linkName = [dic objectForKey:@"linkName"];
    
    _fansCount = [[dic objectForKey:@"fansCount"] intValue];
    _careCount = [[dic objectForKey:@"careCount"] intValue];
    
    _newSendTaskCount = [[dic objectForKey:@"newSendTaskCount"] intValue];
    _newGetTaskCount  = [[dic objectForKey:@"newGetTaskCount"] intValue];
    _oldSendTaskCount = [[dic objectForKey:@"oldSendTaskCount"] intValue];
    _oldGetTaskCount  = [[dic objectForKey:@"oldGetTaskCount"] intValue];
}


@end
