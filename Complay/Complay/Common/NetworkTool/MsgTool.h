//
//  MsgTool.h
//  Complay
//
//  Created by FineexMac on 16/4/20.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "UserModel.h"

///新消息通知
static NSString *kNewMsgNotifacation = @"newMsgNotifacation";
///新聊天用户通知
static NSString *kNewChaterNotifacation = @"newChaterNotifacation";
///清空所有未读消息数通知
static NSString *kClearAllNewMsgNotifacation = @"clearAllNewMsgNotifacation";

@interface MsgTool : NSObject <BmobIMDelegate>


@end
