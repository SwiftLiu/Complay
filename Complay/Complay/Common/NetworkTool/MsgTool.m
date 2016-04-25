//
//  MsgTool.m
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "MsgTool.h"
#import <BmobSDK/Bmob.h>
#import "NetTool.h"
#import "MainTabBarController.h"


typedef NS_ENUM(int,SystemMessageContact){
    SystemMessageContactAdd = 0,
    SystemMessageContactAgree,
    SystemMessageContactRefuse
};

@implementation MsgTool

#pragma mark - <BmobIMDelegate>
//未读历史消息
- (void)didGetOfflineMessagesWithIM:(BmobIM *)im
{
    //获取哪些人的消息还未读
    NSArray *objectIds = [im allConversationUsersIds];
    NSLog(@"未读消息：%@", objectIds);
    if (objectIds && objectIds.count > 0) {
        //Demo里面的方法去查找服务器相关人物的信息
        [NetTool loadUsersWithUserIds:objectIds completion:^(NSArray<BmobIMUserInfo *> *result) {
            //保存到本地数据库
            [im saveUserInfos:result];
            //发新用户的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewChaterNotifacation object:nil];
            //刷新未读消息总数
            [MainTabBarController updateNewMsgTotal];
        }];
    }
}


//接收到消息
- (void)didRecieveMessage:(BmobIMMessage *)message withIM:(BmobIM *)im
{
    NSLog(@"接收到消息：%@", message.content);
    //查看本地有无这个用户的信息
    BmobIMUserInfo *userInfo = [im userInfoWithUserId:message.fromId];
    if (!userInfo) {
        //如果没有则去下载
        [NetTool loadUserWithUserId:message.fromId completion:^(BmobIMUserInfo *result) {
            if (result) {
                //保存到本地数据库
                [im saveUserInfo:result];
                //发新用户的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewChaterNotifacation object:nil];
            }
            //发接收到新信息的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewMsgNotifacation object:message];
            //刷新未读消息总数
            [MainTabBarController updateNewMsgTotal];
        }];
    }else{
        //发接收到新信息的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewMsgNotifacation object:message];
        //刷新未读消息总数
        [MainTabBarController updateNewMsgTotal];
    }
}



@end
